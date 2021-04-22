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

module Context = {
  type t = {
    copyType: Settings.t,
    setCopyType: Settings.t => unit,
    includeLocation: bool,
    setIncludeLocation: (bool => bool) => unit,
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

module SettingsStorage = Storage.Make(Settings)

module Provider = {
  @react.component
  let make = (~children) => {
    let (copyType, setCopyType) = SettingsStorage.useLocalStorage()
    let (includeLocation, setIncludeLocation) = React.useState(() => false)

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
