@react.component
let make = (~rows: array<Api.Highlight.t>, ~search, ~toggleSettings, ~showSettings) => {
  let {copyType, includeLocation} = GlobalState.use()

  let copyTypeToApp = switch copyType {
  | Markdown => "Markdown"
  | Roam => "Roam"
  | Logseq => "Logseq"
  }

  let copyJoinRowsBy = switch copyType {
  | Logseq
  | Markdown => "\n"
  | Roam => "\n\n"
  }

  let copyData = rows->Belt.Array.map(({body, location}) => {
    let combinedBody = body->Js.Array2.joinWith("\n")

    switch (copyType, includeLocation) {
    | (Markdown, true) => `- ${combinedBody} (location ${location})`
    | (Markdown, false) => `- ${combinedBody}`
    | (Roam, true) => `${combinedBody} (location ${location})`
    | (Roam, false) => combinedBody
    | (Logseq, true) => `## ${combinedBody} (location ${location})`
    | (Logseq, false) => `## ${combinedBody}`
    }
  })

  <>
    <Lib.CopyToClipboard
      text={copyData->Js.Array2.joinWith(copyJoinRowsBy)}
      onCopy={_ => {
        let numberOfHighlights = rows->Belt.Array.length->Belt.Int.toString
        Lib.HotToast.make->Lib.HotToast.success(`${numberOfHighlights} highlights copied!`)
      }}>
      <button
        className="bg-white text-gray-700 border border-gray-200 shadow-md rounded px-3 py-2 hover:ring-2 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200 active:ring-indigo-400 dark:bg-gray-800 dark:text-white dark:border-gray-700 dark:ring-offset-gray-900 dark:focus:ring-indigo-800 dark:hover:ring-indigo-800">
        {switch search {
        | "" => `Copy all (${copyTypeToApp})`
        | _ => `Copy filtered (${copyTypeToApp})`
        }->React.string}
      </button>
    </Lib.CopyToClipboard>
    <button
      className={Cn.fromList(list{
        "border shadow-md rounded p-2 hover:ring-2 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200 active:ring-pink-300 dark:ring-offset-gray-900 dark:focus:ring-indigo-800 dark:hover:ring-indigo-800",
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
