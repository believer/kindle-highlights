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

  <div className="max-w-6xl mx-auto my-8 md:my-20 px-5 md:px-0">
    <h1 className="text-3xl font-bold"> {React.string("Kindle highlights")} </h1>
    <p className="max-w-3xl mt-4 mb-2 text-gray-600 text-sm">
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
    <p className="max-w-3xl mb-8 text-gray-600 text-sm">
      {React.string(
        "Connect your Kindle to your computer, find it in Explorer/Finder and navigate to the documents folder. Here you'll find a 'My Clippings.txt' which contains all your highlights. Upload this file using the analyze button or drop the file on the page.",
      )}
    </p>
    <div className="flex flex-col md:flex-row justify-between gap-2 md:gap-0">
      <div className="flex flex-col md:flex-row gap-2 md:gap-4">
        <label
          className="bg-indigo-600 text-white shadow-md px-3 py-2 rounded focus:ring-offset-2 focus:ring-indigo-300 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none cursor-pointer hover:ring-2 focus:ring-2"
          tabIndex={0}>
          <input className="hidden" type_="file" onChange={uploadFile} />
          {React.string("Analyze highlights")}
        </label>
        {switch data {
        | Idle
        | NoData
        | Loading => React.null
        | Data(rows) => <>
            <Lib.CopyToClipboard
              text={rows
              ->Belt.Array.keep(filterRows(~query=search))
              ->Belt.Array.map(({body, location}) => {
                let combinedBody = body->Js.Array2.joinWith("\n")

                `## ${combinedBody} (location ${location})`
              })
              ->Js.Array2.joinWith("\n")}>
              <button
                className="bg-white text-gray-700 border border-gray-200 shadow-md rounded px-3 py-2 hover:ring-2 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200">
                {switch search {
                | "" => "Copy rows (Logseq)"
                | _ => "Copy filtered rows (Logseq)"
                }->React.string}
              </button>
            </Lib.CopyToClipboard>
            <Lib.CopyToClipboard
              text={rows
              ->Belt.Array.keep(filterRows(~query=search))
              ->Belt.Array.map(({body, location}) => {
                let combinedBody = body->Js.Array2.joinWith("\n")

                `${combinedBody} (location ${location})`
              })
              ->Js.Array2.joinWith("\n\n")}>
              <button
                className="bg-white text-gray-700 border border-gray-200 shadow-md rounded px-3 py-2 hover:ring-2 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200">
                {switch search {
                | "" => "Copy rows (Roam)"
                | _ => "Copy filtered rows (Roam)"
                }->React.string}
              </button>
            </Lib.CopyToClipboard>
            <Lib.CopyToClipboard
              text={rows
              ->Belt.Array.keep(filterRows(~query=search))
              ->Belt.Array.map(({body, location}) => {
                let combinedBody = body->Js.Array2.joinWith("\n")

                `- ${combinedBody} (location ${location})`
              })
              ->Js.Array2.joinWith("\n")}>
              <button
                className="bg-white text-gray-700 border border-gray-200 shadow-md rounded px-3 py-2 hover:ring-2 hover:ring-offset-2 hover:ring-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200">
                {switch search {
                | "" => "Copy rows (Markdown)"
                | _ => "Copy filtered rows (Markdown)"
                }->React.string}
              </button>
            </Lib.CopyToClipboard>
          </>
        }}
      </div>
      {switch data {
      | Idle
      | NoData
      | Loading => React.null
      | Data(_) =>
        <input
          className="border border-gray-300 px-3 py-2 rounded focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-200"
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
    | Idle =>
      <div className="text-center p-8 text-gray-600 border border-gray-200 mt-12 rounded">
        {React.string("Add a file by clicking above or dropping a file on the page")}
      </div>
    | NoData => React.null
    | Loading =>
      <div className="text-center p-8 text-gray-600 border border-gray-200 mt-12 rounded">
        {React.string("Loading...")}
      </div>
    | Data(rows) => {
        let filteredRows = rows->Belt.Array.keep(filterRows(~query=search))

        switch (filteredRows->Belt.Array.length, search) {
        | (0, q) if q != "" =>
          <div className="text-center p-8"> {React.string("Nothing matched your search")} </div>
        | _ => <>
            <div className="text-sm text-gray-500 mt-2">
              {React.string("For Roam, right click and select 'Paste and match style'")}
            </div>
            <Table rows=filteredRows />
          </>
        }
      }
    }}
    <Dropzone onDrop=uploadFromDrop />
    <footer className="mt-8 text-center text-gray-600 text-sm">
      {React.string("Built by ")}
      <Link href="https://twitter.com/rnattochdag"> "@rnattochdag" </Link>
      {React.string(". ")}
      <Link href="https://twitter.com/rnattochdag"> "Source code" </Link>
      {React.string(" on GitHub")}
    </footer>
  </div>
}
