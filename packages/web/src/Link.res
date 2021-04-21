@react.component
let make = (~href, ~children) => {
  <a className="text-indigo-600" href> {React.string(children)} </a>
}
