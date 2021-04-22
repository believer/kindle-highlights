# Kindle Highlights

[![](https://github.com/believer/kindle-highlights/workflows/Release/badge.svg)](https://github.com/believer/kindle-highlights/actions?workflow=Release)

This is a perfect application if you read a lot on a Kindle and want to create
notes from your highlights.

It parses the Kindle highlights file (called `My Clippings.txt` on
the Kindle). After processing you are able to filter by title and copy the
highlights in three different formats:

- [Logseq](http://logseq.com/)
- [Roam Research](https://roamresearch.com/)
- Markdown

![Screenshot of the application](/screenshots/screenshot.png)

## Parser

The parser takes the Kindle highlights file, `My Clippings.txt`, and returns an array with parsed data that is presented in the web interface.
This code lives in [`parser`](/packages/parser) and is written in JavaScript.

## Web

The web interface which is available at [https://kindle.willcodefor.beer](https://kindle.willcodefor.beer).
This code lives in [`web`](/packages/web) and is written in [ReScript](http://rescript-lang.org/).

### Step-by-step

- Connect your Kindle to your computer
- Find it in File explorer / Finder
- Navigate to the `documents` folder
- Either use the button or drop your `My Clippings.txt` file on the page to parse the highlights
- Filter by book title
- Click copy (configure in the settings which format you want)
