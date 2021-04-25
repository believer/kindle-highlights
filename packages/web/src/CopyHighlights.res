type note = {
  page: string,
  location: string,
  text: string,
}

type bookNotes = {
  authors: array<string>,
  bookId: string,
  date: option<string>,
  id: string,
  title: string,
  issues: array<Api.Issue.t>,
  notes: array<note>,
}

@react.component
let make = (~rows: array<Api.Highlight.t>, ~search, ~toggleSettings, ~showSettings) => {
  let {copyType, customTemplate, includeIssues, includeLocation} = GlobalState.use()

  let copyTypeToApp = switch copyType {
  | Markdown => "Markdown"
  | Roam => "Roam"
  | Logseq => "Logseq"
  | Obsidian => "Obsidian"
  }

  let copyJoinRowsBy = switch copyType {
  | Logseq
  | Markdown => "\n"
  | Obsidian
  | Roam => "\n\n"
  }

  let allBooks =
    rows
    ->Belt.Array.keep(({issues}) => {
      switch (issues->Belt.Array.length, includeIssues) {
      | (_, true) => true
      | (0, false) => true
      | (_, false) => false
      }
    })
    ->Belt.Array.reduce(list{}, (books: list<(string, bookNotes)>, book) => {
      switch books->Belt.List.getAssoc(book.bookId, (a, b) => a == b) {
      | Some(current) =>
        books->Belt.List.setAssoc(
          book.bookId,
          {
            ...current,
            notes: current.notes->Belt.Array.concat([
              {page: book.page, location: book.location, text: book.content},
            ]),
          },
          (a, b) => a == b,
        )
      | None =>
        books->Belt.List.setAssoc(
          book.bookId,
          {
            authors: book.authors,
            bookId: book.bookId,
            date: book.date,
            id: book.id,
            title: book.title,
            issues: book.issues,
            notes: [{page: book.page, location: book.location, text: book.content}],
          },
          (a, b) => a == b,
        )
      }
    })
    ->Belt.List.map(((_id, book)) => book)
    ->Belt.List.toArray

  let createHighlights = notes => {
    notes
    ->Belt.Array.map(({text, location}) => {
      switch (copyType, includeLocation) {
      | (Markdown, true) => `- ${text} (location ${location})`
      | (Markdown, false) => `- ${text}`
      | (Roam, true) => `${text} (location ${location})`
      | (Roam, false) => text
      | (Logseq, true) => `## ${text} (location ${location})`
      | (Logseq, false) => `## ${text}`
      | (Obsidian, true) => `${text} (location ${location})`
      | (Obsidian, false) => text
      }
    })
    ->Js.Array2.joinWith(copyJoinRowsBy)
  }

  let copyTemplate = switch customTemplate {
  | "" => allBooks->Belt.Array.map(({notes}) => createHighlights(notes))->Js.Array2.joinWith("\n")
  | template =>
    allBooks
    ->Belt.Array.map(({authors, title, notes}) => {
      let highlights = createHighlights(notes)
      let author = authors->Belt.Array.map(author => `[[${author}]]`)->Js.Array2.joinWith(", ")

      template
      ->Js.String2.replace("{{author}}", author)
      ->Js.String2.replace("{{highlights}}", highlights)
      ->Js.String2.replace("{{title}}", title)
    })
    ->Js.Array2.joinWith(copyJoinRowsBy)
  }

  Js.log(copyTemplate)

  <>
    <Lib.CopyToClipboard
      text={copyTemplate}
      onCopy={_ => {
        let numberOfHighlights = rows->Belt.Array.length->Belt.Int.toString
        Lib.HotToast.make->Lib.HotToast.success(`${numberOfHighlights} highlights copied!`)
      }}>
      <button
        className="bg-white text-gray-700 border border-gray-200 shadow-md rounded px-3 py-2 hover:ring-2 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200 active:ring-indigo-400 dark:bg-gray-800 dark:text-white dark:border-gray-700 dark:ring-offset-gray-900 dark:focus:ring-indigo-800 dark:hover:ring-indigo-800 dark:active:ring-pink-600">
        {switch search {
        | "" => `Copy all (${copyTypeToApp})`
        | _ => `Copy filtered (${copyTypeToApp})`
        }->React.string}
      </button>
    </Lib.CopyToClipboard>
    <button
      className={Cn.fromList(list{
        "border shadow-md rounded p-2 hover:ring-2 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200 active:ring-pink-300 dark:ring-offset-gray-900 dark:focus:ring-indigo-800 dark:hover:ring-indigo-800 dark:active:ring-pink-600",
        switch showSettings {
        | true => "bg-pink-300 text-pink-700 border-pink-400"
        | false => "bg-white text-gray-700 border-gray-200 dark:bg-gray-800 dark:text-white dark:border-gray-700"
        },
      })}
      onClick={toggleSettings}>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        className="h-6 w-6"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor">
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth="2"
          d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
        />
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth="2"
          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
        />
      </svg>
    </button>
  </>
}
