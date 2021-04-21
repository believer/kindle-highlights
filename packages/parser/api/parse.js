const lineByLine = require('n-readlines')
const { promisify } = require('util')
const path = require('path')
const fs = require('fs')
const { allowCors } = require('../utils/allowCors')

const writeFile = promisify(fs.writeFile)
const removeFile = promisify(fs.unlink)

const metadata = (line) => {
  const meta = line
    .toString('utf8')
    .match(
      /(page (?<page>\d+) \| )?location (?<location>(\d+|\d+-\d+)) \| added on (?<unparsedDate>.+)/i
    )

  const { page, location, unparsedDate } = meta?.groups ?? {}
  const parsedDate = Date.parse(unparsedDate)
  const date = parsedDate ? new Date(parsedDate).toISOString() : null

  return {
    page,
    location: location.includes('-') ? location.split('-')[0] : location,
    date,
  }
}

const titleAndAuthors = (line) => {
  const titleRow = line
    .toString('utf8')
    .match(/^(?<title>.+)\s\((?<author>.+)\)\s?$/)

  const { title, author } = titleRow?.groups ?? {}

  const titleWithSeries = title.match(/\((?<series>.+)\)/i)

  const { series } = titleWithSeries?.groups ?? {}

  return {
    title: series ? title.replace(/ \((.+)\)/, '').trim() : title,
    series,
    authors: author.split(';').map((author) => {
      if (author.includes(',')) {
        const [lastName, firstName] = author.split(', ')

        return `${firstName.trim()} ${lastName.trim()}`
      }

      return author
    }),
  }
}

const handler = async (req, res) => {
  const { data } = JSON.parse(req.body)
  let line
  const output = []
  const fileName = path.join('/tmp', 'temp.txt')
  const ids = {}

  await writeFile(fileName, data)

  const liner = new lineByLine(fileName)

  while ((line = liner.next())) {
    if (line.toString('utf8').startsWith('====')) {
      const body = []

      // Skip block start line
      // Next line, title and author
      line = liner.next()
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

      const id = Buffer.from(body[0]).toString('base64')

      if (body[0] !== '\r' && !ids[id]) {
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
  }

  await removeFile(fileName)

  res.json(output.slice().sort((a, b) => a.title.localeCompare(b.title)))
}

module.exports = allowCors(handler)
