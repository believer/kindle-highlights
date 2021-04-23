module CopyTypeConfig = {
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

module IncludeLocationConfig = {
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

module IncludeIssuesConfig = {
  type t = bool

  let key = "include-issues"

  let fromString = value =>
    switch value {
    | Some("false") => false
    | Some("true") => true
    | Some(_)
    | None => true
    }

  let toString = value =>
    switch value {
    | true => "true"
    | false => "false"
    }
}

module Context = {
  type t = {
    copyType: CopyTypeConfig.t,
    includeIssues: IncludeIssuesConfig.t,
    includeLocation: IncludeLocationConfig.t,
    setCopyType: CopyTypeConfig.t => unit,
    setIncludeIssues: IncludeIssuesConfig.t => unit,
    setIncludeLocation: IncludeLocationConfig.t => unit,
  }

  include ReactContext.Make({
    type context = t

    let defaultValue = {
      copyType: Markdown,
      includeIssues: true,
      includeLocation: false,
      setCopyType: _ => (),
      setIncludeIssues: _ => (),
      setIncludeLocation: _ => (),
    }
  })
}

module CopyType = Storage.Make(CopyTypeConfig)
module IncludeLocation = Storage.Make(IncludeLocationConfig)
module IncludeIssues = Storage.Make(IncludeIssuesConfig)

module Provider = {
  @react.component
  let make = (~children) => {
    let (copyType, setCopyType) = CopyType.useLocalStorage()
    let (includeLocation, setIncludeLocation) = IncludeLocation.useLocalStorage()
    let (includeIssues, setIncludeIssues) = IncludeIssues.useLocalStorage()

    <Context.Provider
      value={{
        copyType: copyType,
        includeIssues: includeIssues,
        includeLocation: includeLocation,
        setCopyType: setCopyType,
        setIncludeIssues: setIncludeIssues,
        setIncludeLocation: setIncludeLocation,
      }}>
      children
    </Context.Provider>
  }
}

let use = Context.use
