module QueryClient = {
  type t

  @new @module("react-query") external make: Js.t<_> => t = "QueryClient"
}

module QueryClientProvider = {
  @react.component @module("react-query")
  external make: (~client: QueryClient.t, ~children: React.element) => React.element =
    "QueryClientProvider"
}

type queryResponse<'a> = {
  isLoading: bool,
  data: Js.Undefined.t<'a>,
}

@module("react-query")
external useArrayQuery: (array<string>, unit => Promise.t<'a>) => queryResponse<'a> = "useQuery"

@module("react-query")
external useQuery: (string, unit => Promise.t<'a>) => queryResponse<'a> = "useQuery"
