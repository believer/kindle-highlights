@react.component
let make = () => {
  let (rows, uploadFile, uploadFromDrop) = FileUpload.use()
  let (search, setSearch) = React.useState(() => "")

  let filteredRows = rows->Belt.Array.keep(({title}) => {
    switch search {
    | "" => true
    | q => title->Js.String.toLowerCase->Js.String2.includes(q->Js.String2.toLowerCase)
    }
  })

  <div className="max-w-6xl mx-auto my-8 md:my-20 px-5 md:px-0">
    <h1 className="text-3xl font-bold"> {React.string("Kindle highlights")} </h1>
    <p className="max-w-3xl mt-4 mb-2 text-gray-600 text-sm">
      {React.string(
        "This page parses all your Kindle highlights and provides options to filter by book and copy to Logseq and Roam. ",
      )}
      <strong> {React.string("No data is saved.")} </strong>
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
        <label className="bg-indigo-600 text-white shadow-md px-3 py-2 rounded">
          <input className="hidden" type_="file" onChange={uploadFile} />
          {React.string("Analyze highlights")}
        </label>
        {switch rows->Belt.Array.length {
        | 0 => React.null
        | _ => <>
            <Lib.CopyToClipboard
              text={filteredRows
              ->Belt.Array.map(({body, location}) => {
                let combinedBody = body->Js.Array2.joinWith("\n")

                `## ${combinedBody} (location ${location})`
              })
              ->Js.Array2.joinWith("\n")}>
              <button
                className="bg-white text-gray-700 border border-gray-200 shadow-md rounded px-3 py-2">
                {switch search {
                | "" => "Copy rows (Logseq)"
                | _ => "Copy filtered rows (Logseq)"
                }->React.string}
              </button>
            </Lib.CopyToClipboard>
            <Lib.CopyToClipboard
              text={filteredRows
              ->Belt.Array.map(({body, location}) => {
                let combinedBody = body->Js.Array2.joinWith("\n")

                `${combinedBody} (location ${location})`
              })
              ->Js.Array2.joinWith("\n\n")}>
              <button
                className="bg-white text-gray-700 shadow-md border border-gray-200 rounded px-3 py-2">
                {switch search {
                | "" => "Copy rows (Roam)"
                | _ => "Copy filtered rows (Roam)"
                }->React.string}
              </button>
            </Lib.CopyToClipboard>
          </>
        }}
      </div>
      {switch rows->Belt.Array.length {
      | 0 => React.null
      | _ =>
        <input
          className="border border-gray-200 px-3 py-2 rounded"
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
    {switch rows->Belt.Array.length {
    | 0 => React.null
    | _ =>
      <div className="text-sm text-gray-500 mt-2">
        {React.string("For Roam, right click and select 'Paste and match style'")}
      </div>
    }}
    <Table rows=filteredRows search />
    <Dropzone onDrop=uploadFromDrop />
  </div>
}
