let baseUrl = "https://kindle-api.willcodefor.beer"

type t<'a> = Loading | Data('a) | NoData | Idle

module Response = {
  type t<'data>
  @send external json: t<'data> => Promise.t<'data> = "json"
}

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

module Highlights = {
  open Promise

  @val @scope("globalThis")
  external post: (string, Js.t<_>) => Promise.t<Response.t<array<Highlight.t>>> = "fetch"

  let sendData = data => {
    post(
      `${baseUrl}/api/parse`,
      {
        "method": "POST",
        "body": Js.Json.stringifyAny({
          "data": data,
        }),
      },
    )
    ->then(res => Response.json(res))
    ->then(data => resolve(data))
  }

  let useUpload = () => {
    let (highlights, setHighlights) = React.useState(() => "")
    let {data, isLoading, isIdle, mutate} = ReactQuery.useMutation(data => sendData(data))

    React.useEffect1(() => {
      if highlights != "" {
        mutate(. highlights)
      }

      None
    }, [highlights])

    let handleUpload = file => {
      file["text"]()
      ->then(data => {
        setHighlights(_ => data)
        resolve()
      })
      ->ignore
    }

    let uploadFromFile = e => (e->ReactEvent.Form.target)["files"][0]->handleUpload

    let uploadFromDrop = e => {
      let item = e["dataTransfer"]["items"][0]
      switch item["kind"] {
      | "file" => item["getAsFile"]()->handleUpload
      | _ => ()
      }
    }

    (
      switch (isLoading, isIdle, Js.Undefined.toOption(data)) {
      | (false, false, Some(data)) => Data(data)
      | (false, true, _) => Idle
      | (true, false, _) => Loading
      | (true, true, _)
      | (false, false, _) =>
        NoData
      },
      uploadFromFile,
      uploadFromDrop,
    )
  }
}
