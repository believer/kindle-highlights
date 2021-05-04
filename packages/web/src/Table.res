type t = array<Api.Highlight.t>

@react.component
let make = (~rows: t) => {
  let totalIssues =
    rows->Belt.Array.keep(({issues}) => issues->Belt.Array.length > 0)->Belt.Array.length

  <div className="mt-12">
    <div className="mb-2 flex justify-end text-sm text-right text-gray-500 space-x-4">
      <div>
        {rows->Belt.Array.length->Belt.Int.toString->React.string} {React.string(" highlights")}
      </div>
      <div className="flex">
        <span className="text-green-400 mr-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            className="h-5 w-5"
            viewBox="0 0 20 20"
            fill="currentColor">
            <path
              fillRule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
              clipRule="evenodd"
            />
          </svg>
        </span>
        {(rows->Belt.Array.length - totalIssues)->Belt.Int.toString->React.string}
        {React.string(" look good")}
      </div>
      {switch totalIssues {
      | 0 => React.null
      | _ =>
        <div className="flex">
          <span className="text-yellow-400 mr-2">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              viewBox="0 0 20 20"
              fill="currentColor">
              <path
                fillRule="evenodd"
                d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                clipRule="evenodd"
              />
            </svg>
          </span>
          {totalIssues->Belt.Int.toString->React.string}
          {React.string(" with potential issues")}
        </div>
      }}
    </div>
    <div className="text-sm border border-gray-200 rounded dark:border-gray-800">
      <div className="grid md:grid-table gap-2 md:gap-4 font-bold p-2 bg-gray-200 dark:bg-gray-700">
        <div />
        <div> {React.string("Book")} </div>
        <div> {React.string("Authors")} </div>
        <div className="md:text-right"> {React.string("Page")} </div>
        <div className="md:text-right"> {React.string("Location")} </div>
        <div> {React.string("Highlight")} </div>
      </div>
      {rows
      ->Belt.Array.mapWithIndex((i, {content, issues, authors, title, id, location, page}) => {
        <div
          className={cx([
            "grid md:grid-table gap-2 md:gap-4 p-2",
            switch mod(i, 2) {
            | 0 => "bg-gray-50 dark:bg-gray-800"
            | _ => "bg-white dark:bg-gray-900"
            },
          ])}
          key=id>
          <div className="font-bold truncate">
            {switch issues {
            | [] =>
              <span className="text-green-400" title="No issues found">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-5 w-5"
                  viewBox="0 0 20 20"
                  fill="currentColor">
                  <path
                    fillRule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clipRule="evenodd"
                  />
                </svg>
              </span>
            | issues =>
              <span
                className="text-yellow-400"
                title={issues
                ->Belt.Array.map(issue => {
                  switch issue {
                  | #similar => "This has one or more similar entries"
                  | #short => "This entry is short"
                  }
                })
                ->Js.Array2.joinWith(". ")}>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-5 w-5"
                  viewBox="0 0 20 20"
                  fill="currentColor">
                  <path
                    fillRule="evenodd"
                    d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                    clipRule="evenodd"
                  />
                </svg>
              </span>
            }}
          </div>
          <div className="font-bold truncate"> {React.string(title)} </div>
          <div> {authors->Js.Array2.joinWith(", ")->React.string} </div>
          <div className="md:text-right"> {React.string(page)} </div>
          <div className="md:text-right"> {React.string(location)} </div>
          <div> {React.string(content)} </div>
        </div>
      })
      ->React.array}
    </div>
  </div>
}
