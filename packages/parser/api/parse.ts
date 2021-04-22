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
  const titleRow = line
    .toString('utf8')
    .match(/^(?<title>.+)\s\((?<author>.+)\)\s?$/)

  const { title, author } = titleRow?.groups ?? {}

  const titleWithSeries = title.match(/\((?<series>.+)\)/i)

  const { series } = titleWithSeries?.groups ?? {}

  const titleWithoutSubtitle = title.includes(':')
    ? title.replace(/:.+/, '')
    : title

  return {
    title: series
      ? titleWithoutSubtitle.replace(/ \((.+)\)/, '').trim()
      : titleWithoutSubtitle.trim(),
    series: series ?? null,
    authors: author.split(';').map((author: string) => {
      if (author.includes(',')) {
        const [lastName, firstName] = author.split(', ')

        return `${firstName.trim()} ${lastName.trim()}`
      }

      return author
    }),
  }
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
    const { title, authors } = titleAndAuthors(line)

    // Next line, meta data
    line = liner.next()
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

    const id = md5(body[0])

    // If a similar exist for the same page, location and title
    // remove it and only keep the last one
    const containsSimilar = output.findIndex(
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
        body,
        date,
        location,
        page,
        title,
      })

      ids[id] = true
    }
  }

  await removeFile(fileName)

  res.json(output.slice().sort((a, b) => a.title.localeCompare(b.title)))
}

export default allowCors(handler)
