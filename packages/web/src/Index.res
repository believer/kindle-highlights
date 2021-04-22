%%raw("import './index.css'")

let client = ReactQuery.QueryClient.make({
  "defaultOptions": {
    "queries": {
      "refetchOnWindowFocus": false,
    },
  },
})

switch ReactDOM.querySelector("#root") {
| Some(root) =>
  ReactDOM.render(
    <ReactQuery.QueryClientProvider client> <App /> </ReactQuery.QueryClientProvider>,
    root,
  )
| None => () // do nothing
}
