@react.component
let make = (~href, ~children) => {
  <a className="text-indigo-600 dark:text-indigo-400" href> {React.string(children)} </a>
}
