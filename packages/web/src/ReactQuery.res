module QueryClient = {
  type t

  @new @module("react-query") external make: Js.t<_> => t = "QueryClient"
}

module QueryClientProvider = {
  @react.component @module("react-query")
  external make: (~client: QueryClient.t, ~children: React.element) => React.element =
    "QueryClientProvider"
}

type query<'a> = {
  isLoading: bool,
  isIdle: bool,
  data: Js.Undefined.t<'a>,
}

type mutation<'a> = {
  isLoading: bool,
  isIdle: bool,
  data: Js.Undefined.t<'a>,
  mutate: (. string) => unit,
}

@module("react-query")
external useArrayQuery: (array<string>, unit => Promise.t<'a>) => query<'a> = "useQuery"

@module("react-query")
external useQuery: (string, unit => Promise.t<'a>) => query<'a> = "useQuery"

@module("react-query")
external useMutation: (string => Promise.t<'a>) => mutation<'a> = "useMutation"
