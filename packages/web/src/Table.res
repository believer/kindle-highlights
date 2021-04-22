type t = array<Api.Highlight.t>

@react.component
let make = (~rows: t) => {
  <div className="mt-12">
    <div className="mb-2 text-sm text-right text-gray-500">
      {rows->Belt.Array.length->Belt.Int.toString->React.string} {React.string(" highlights")}
    </div>
    <div className="text-sm border border-gray-200 rounded">
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
    </div>
  </div>
}
