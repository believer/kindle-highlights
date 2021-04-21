type t = array<Api.Highlight.t>

@react.component
let make = (~rows: t, ~search) => {
  <div className="text-sm border border-gray-200 mt-12 rounded">
    {switch (rows->Belt.Array.length, search) {
    | (0, "") =>
      <div className="text-center p-8">
        {React.string("Add a file by clicking above or dropping a file on the window")}
      </div>
    | (0, _) =>
      <div className="text-center p-8"> {React.string("Nothing matched your search")} </div>
    | _ => <>
        <div className="grid md:grid-table gap-2 md:gap-4 font-bold p-2 bg-gray-200">
          <div> {React.string("Book")} </div>
          <div> {React.string("Authors")} </div>
          <div className="md:text-right"> {React.string("Page")} </div>
          <div className="md:text-right"> {React.string("Location")} </div>
          <div> {React.string("Highlight")} </div>
        </div>
        {rows
        ->Belt.Array.mapWithIndex((i, {body, authors, title, id, location, page}) => {
          <div
            className={Cn.fromList(list{
              "grid md:grid-table gap-2 md:gap-4 bg-white p-2",
              "bg-gray-50"->Cn.on(mod(i, 2) == 0),
            })}
            key=id>
            <div className="font-bold truncate"> {React.string(title)} </div>
            <div> {authors->Js.Array2.joinWith(", ")->React.string} </div>
            <div className="md:text-right"> {React.string(page)} </div>
            <div className="md:text-right"> {React.string(location)} </div>
            <div> {body->Js.Array2.joinWith("\n")->React.string} </div>
          </div>
        })
        ->React.array}
      </>
    }}
  </div>
}
