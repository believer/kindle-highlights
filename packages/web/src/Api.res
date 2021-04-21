let baseUrl = "http://localhost:3001"

type t<'a> = Loading | Data('a) | NoData

module Response = {
  type t<'data>
  @send external json: t<'data> => Promise.t<'data> = "json"
}

type response = {"token": Js.Nullable.t<string>, "error": Js.Nullable.t<string>}

module Highlight = {
  type t = {
    authors: array<string>,
    body: array<string>,
    date: option<string>,
    id: string,
    title: string,
    page: string,
    location: string,
  }
}

module Locations = {
  @val @scope("globalThis")
  external post: (string, Js.t<_>) => Promise.t<Response.t<array<Highlight.t>>> = "fetch"

  let parse = (data: string) => {
    post(
      `${baseUrl}/api/parse`,
      {
        "method": "POST",
        "body": Js.Json.stringifyAny({
          "data": data,
        }),
      },
    )->Promise.then(res => Response.json(res))
  }
}
