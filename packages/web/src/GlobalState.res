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

module CustomTemplateConfig = {
  type t = string

  let key = "include-template"

  let fromString = value =>
    switch value {
    | Some(value) => value
    | None => ""
    }

  let toString = value => value
}

module Context = {
  type t = {
    copyType: CopyTypeConfig.t,
    customTemplate: CustomTemplateConfig.t,
    includeIssues: IncludeIssuesConfig.t,
    includeLocation: IncludeLocationConfig.t,
    setCopyType: CopyTypeConfig.t => unit,
    setCustomTemplate: CustomTemplateConfig.t => unit,
    setIncludeIssues: IncludeIssuesConfig.t => unit,
    setIncludeLocation: IncludeLocationConfig.t => unit,
  }

  include ReactContext.Make({
    type context = t

    let defaultValue = {
      copyType: Markdown,
      customTemplate: "",
      includeIssues: true,
      includeLocation: false,
      setCopyType: _ => (),
      setCustomTemplate: _ => (),
      setIncludeIssues: _ => (),
      setIncludeLocation: _ => (),
    }
  })
}

module CopyType = Storage.Make(CopyTypeConfig)
module IncludeLocation = Storage.Make(IncludeLocationConfig)
module IncludeIssues = Storage.Make(IncludeIssuesConfig)
module CustomTemplate = Storage.Make(CustomTemplateConfig)

module Provider = {
  @react.component
  let make = (~children) => {
    let (copyType, setCopyType) = CopyType.useLocalStorage()
    let (includeLocation, setIncludeLocation) = IncludeLocation.useLocalStorage()
    let (includeIssues, setIncludeIssues) = IncludeIssues.useLocalStorage()
    let (customTemplate, setCustomTemplate) = CustomTemplate.useLocalStorage()

    <Context.Provider
      value={{
        copyType: copyType,
        customTemplate: customTemplate,
        includeIssues: includeIssues,
        includeLocation: includeLocation,
        setCopyType: setCopyType,
        setCustomTemplate: setCustomTemplate,
        setIncludeIssues: setIncludeIssues,
        setIncludeLocation: setIncludeLocation,
      }}>
      children
    </Context.Provider>
  }
}

let use = Context.use
