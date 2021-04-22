module Settings = {
  type t = Markdown | Roam | Logseq

  let key = "copy-type"

  let fromString = value =>
    switch value {
    | Some("markdown") => Markdown
    | Some("roam") => Roam
    | Some("logseq") => Logseq
    | Some(_)
    | None =>
      Markdown
    }

  let toString = value =>
    switch value {
    | Markdown => "markdown"
    | Roam => "roam"
    | Logseq => "logseq"
    }
}

module BoolValue = {
  type t = bool

  let key = "include-location"

  let fromString = value =>
    switch value {
    | Some("false") => false
    | Some("true") => true
    | Some(_)
    | None => false
    }

  let toString = value =>
    switch value {
    | true => "true"
    | false => "false"
    }
}

module Context = {
  type t = {
    copyType: Settings.t,
    setCopyType: Settings.t => unit,
    includeLocation: BoolValue.t,
    setIncludeLocation: BoolValue.t => unit,
  }

  include ReactContext.Make({
    type context = t

    let defaultValue = {
      copyType: Markdown,
      setCopyType: _ => (),
      includeLocation: false,
      setIncludeLocation: _ => (),
    }
  })
}

module CopyType = Storage.Make(Settings)
module Location = Storage.Make(BoolValue)

module Provider = {
  @react.component
  let make = (~children) => {
    let (copyType, setCopyType) = CopyType.useLocalStorage()
    let (includeLocation, setIncludeLocation) = Location.useLocalStorage()

    <Context.Provider
      value={{
        copyType: copyType,
        setCopyType: setCopyType,
        includeLocation: includeLocation,
        setIncludeLocation: setIncludeLocation,
      }}>
      children
    </Context.Provider>
  }
}

let use = Context.use
