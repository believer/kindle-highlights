import lineByLine from 'n-readlines'
import { promisify } from 'util'
import path from 'path'
import fs from 'fs'
import { allowCors } from '../utils/allowCors'
import md5 from 'md5'
import { NowRequest, NowResponse } from '@vercel/node'

const writeFile = promisify(fs.writeFile)
const removeFile = promisify(fs.unlink)

interface Metadata {
  page: string
  location: string
  date: string | null
}

export const metadata = (line: Buffer | false): Metadata => {
  const meta = line
    .toString('utf8')
    .match(
      /on (page (?<page>\w+))?( \| )?(location (?<location>(\d+-\d+|\d+)))?( \| )?(added on (?<unparsedDate>.+))?/i
    )

  const { page = '', location = '', unparsedDate } = meta?.groups ?? {}
  const parsedDate = Date.parse(unparsedDate)
  const date = parsedDate ? new Date(parsedDate).toISOString() : null

  return {
    page,
    location: location.includes('-') ? location.split('-')[0] : location,
    date,
  }
}

interface TitleAuthor {
  title: string
  series: string | null
  authors: string[]
}

export const titleAndAuthors = (line: Buffer | false): TitleAuthor => {
  try {
    if (line.toString('utf8').startsWith('- Your')) {
      throw new Error('Highlight row as title')
    }

    const titleRow = line
      .toString('utf8')
      .match(
        /^(?<title>[^\(]+)( ?\((?<series>[^\)]+)\))?( ?\((?<author>[^\)]+))?/
      )

    const { title, author, series } = titleRow?.groups ?? {}
    const parsedAuthor = series && !author ? series : author

    const titleWithoutSubtitle = title.includes(':')
      ? title.replace(/:.+/, '')
      : title

    return {
      title: series
        ? titleWithoutSubtitle.replace(/ \((.+)\)/, '').trim()
        : titleWithoutSubtitle.trim(),
      series: series && author ? series : null,
      authors: parsedAuthor
        ? parsedAuthor.split(';').map((author: string) => {
            if (author.includes(',')) {
              const [lastName, firstName] = author.split(', ')

              return `${firstName.trim()} ${lastName.trim()}`
            }

            return author
          })
        : [],
    }
  } catch (e) {
    console.error(e, line.toString('utf8'))

    return {
      title: '',
      authors: [],
      series: null,
    }
  }
}

interface IssueProps {
  bodyLength: number
  containsSimilar: boolean
}

enum Issue {
  similar = 'similar',
  short = 'shortContent',
}

export const findIssues = ({
  bodyLength,
  containsSimilar,
}: IssueProps): Issue[] => {
  const issues = []

  if (containsSimilar) {
    issues.push(Issue.similar)
  }

  if (bodyLength <= 10) {
    issues.push(Issue.short)
  }

  return issues
}

const isValidBody = ({
  body,
  ids,
  id,
}: {
  body: string[]
  ids: Record<string, boolean>
  id: string
}): boolean => body[0] !== '\r' && body[0] !== '' && !ids[id]

export const handler = async (req: NowRequest, res: NowResponse) => {
  const { data } = JSON.parse(req.body)
  let line: Buffer | false
  const output = []
  const fileName = path.join('/tmp', 'temp.txt')
  const ids: Record<string, boolean> = {}

  await writeFile(fileName, data)

  const liner = new lineByLine(fileName)

  while ((line = liner.next())) {
    const body = []

    // Skip block start line
    // Next line, title and author
    const { title, authors, series } = titleAndAuthors(line)

    // Next line, meta data
    if (!line.toString('utf8').startsWith('- Your')) {
      line = liner.next()
    }

    const { date, page, location } = metadata(line)

    // Skip space between meta and content
    // Next line, content
    line = liner.next()
    line = liner.next()

    // Find content
    while (!line.toString('utf8').startsWith('====')) {
      body.push(line.toString('utf8').trim())
      line = liner.next()
    }

    const content = body.join('\n')
    const id = md5(content)

    // If a similar exist for the same page, location and title
    // remove it and only keep the last one
    const containsSimilar: number = output.findIndex(
      (highlight) =>
        highlight.title === title &&
        highlight.page === page &&
        highlight.location === location
    )

    if (containsSimilar !== -1) {
      output.splice(containsSimilar, 1)
    }

    if (isValidBody({ body, ids, id })) {
      output.push({
        authors,
        id,
        content,
        date,
        series,
        location,
        page,
        title,
        bookId: md5(title),
        issues: findIssues({
          containsSimilar: containsSimilar > -1,
          bodyLength: content.length,
        }),
      })

      ids[id] = true
    }
  }

  await removeFile(fileName)

  res.json(output.slice().sort((a, b) => a.title.localeCompare(b.title)))
}

export default allowCors(handler)
