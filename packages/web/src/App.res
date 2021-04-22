let filterRows = ({title}: Api.Highlight.t, ~query) => {
  open Js.String2

  switch query {
  | "" => true
  | q => title->toLowerCase->includes(q->toLowerCase)
  }
}

@react.component
let make = () => {
  let (data, uploadFile, uploadFromDrop) = Api.Highlights.useUpload()
  let (search, setSearch) = React.useState(() => "")
  let (showSettings, setShowSettings) = React.useState(() => false)

  <GlobalState.Provider>
    <Lib.HotToast.Toaster />
    <div className="max-w-6xl mx-auto py-8 md:py-20 px-5 md:px-0">
      <h1 className="text-3xl font-bold"> {React.string("Kindle highlights")} </h1>
      <p className="max-w-3xl mt-4 mb-2 text-gray-600 dark:text-gray-400 text-sm">
        {React.string(
          "This page parses all your Kindle highlights and provides options to filter by book and copy to ",
        )}
        <Link href="http://logseq.com/"> "Logseq" </Link>
        {React.string(" and ")}
        <Link href="https://roamresearch.com/"> "Roam Research" </Link>
        <strong> {React.string(". No data is saved.")} </strong>
        {React.string(
          " The highlights are saved temporarily for parsing and destroyed before returning the parsed result.",
        )}
      </p>
      <p className="max-w-3xl mb-8 text-gray-600 dark:text-gray-400 text-sm">
        {React.string(
          "Connect your Kindle to your computer, find it in Explorer/Finder and navigate to the documents folder. Here you'll find a 'My Clippings.txt' which contains all your highlights. Upload this file using the analyze button or drop the file on the page.",
        )}
      </p>
      <div className="flex flex-col md:flex-row justify-between gap-2 md:gap-0">
        <div className="flex flex-col md:flex-row gap-2 md:gap-4">
          <label
            className="bg-indigo-600 text-white shadow-md px-3 py-2 rounded focus:ring-offset-2 focus:ring-indigo-300 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none cursor-pointer hover:ring-2 focus:ring-2 dark:ring-offset-gray-900 dark:focus:ring-indigo-800 dark:hover:ring-indigo-800"
            tabIndex={0}>
            <input className="hidden" type_="file" onChange={uploadFile} />
            {React.string("Analyze highlights")}
          </label>
          {switch data {
          | Idle
          | NoData
          | Loading => React.null
          | Data(rows) =>
            <CopyHighlights
              rows={rows->Belt.Array.keep(filterRows(~query=search))}
              search
              showSettings
              toggleSettings={_ => {
                setShowSettings(settings => !settings)
              }}
            />
          }}
        </div>
        {switch data {
        | Idle
        | NoData
        | Loading => React.null
        | Data(_) =>
          <input
            className="border border-gray-300 px-3 py-2 rounded focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200 dark:bg-gray-800 dark:border-gray-700 dark:focus:ring-offset-gray-800 dark:focus:ring-indigo-800"
            type_="text"
            onChange={e => {
              let value = (e->ReactEvent.Form.target)["value"]
              setSearch(_ => value)
            }}
            placeholder="Filter highlights"
            value={search}
          />
        }}
      </div>
      {switch data {
      | Idle
      | NoData
      | Loading => React.null
      | Data(_) =>
        <div className="text-sm text-gray-500 mt-2">
          {React.string("For Roam, right click and select 'Paste and match style'")}
        </div>
      }}
      {switch showSettings {
      | true => <Settings />
      | false => React.null
      }}
      {switch data {
      | Idle =>
        <div
          className="text-center p-8 text-gray-600 border border-gray-200 mt-12 rounded dark:border-gray-800">
          {React.string("Add a file by clicking above or dropping a file on the page")}
        </div>
      | NoData => React.null
      | Loading =>
        <div
          className="text-center p-8 text-gray-600 border border-gray-200 mt-12 rounded dark:border-gray-800">
          {React.string("Loading...")}
        </div>
      | Data(rows) => {
          let filteredRows = rows->Belt.Array.keep(filterRows(~query=search))

          switch (filteredRows->Belt.Array.length, search) {
          | (0, q) if q != "" =>
            <div className="text-center p-8"> {React.string("Nothing matched your search")} </div>
          | _ => <Table rows=filteredRows />
          }
        }
      }}
      <footer className="mt-8 text-center text-gray-600 text-xs">
        {React.string("Built by ")}
        <Link href="https://twitter.com/rnattochdag"> "@rnattochdag" </Link>
        {React.string(". ")}
        <Link href="https://github.com/believer/kindle-highlights"> "Source code" </Link>
        {React.string(" on GitHub")}
      </footer>
    </div>
    <Dropzone onDrop=uploadFromDrop />
  </GlobalState.Provider>
}
