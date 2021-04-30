module CopyTypeConfig = {
  type t = Markdown | Roam | Logseq | Obsidian

  let key = "copy-type"

  let fromString = value =>
    switch value {
    | Some("markdown") => Markdown
    | Some("obsidian") => Obsidian
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
    | Obsidian => "obsidian"
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

type t =
  | UpdateCopyType(option<string>)
  | UpdateIncludeLocation(IncludeLocationConfig.t)
  | UpdateIncludeIssues(IncludeIssuesConfig.t)
  | UpdateCustomTemplate(CustomTemplateConfig.t)

module Context = {
  type t = {
    copyType: CopyTypeConfig.t,
    customTemplate: CustomTemplateConfig.t,
    includeIssues: IncludeIssuesConfig.t,
    includeLocation: IncludeLocationConfig.t,
    update: t => unit,
  }

  include ReactContext.Make({
    type context = t

    let defaultValue = {
      copyType: Markdown,
      customTemplate: "",
      includeIssues: true,
      includeLocation: false,
      update: _ => (),
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

    let update = updateType =>
      switch updateType {
      | UpdateCopyType(value) => value->CopyTypeConfig.fromString->setCopyType
      | UpdateCustomTemplate(value) => value->setCustomTemplate
      | UpdateIncludeIssues(value) => value->setIncludeIssues
      | UpdateIncludeLocation(value) => value->setIncludeLocation
      }

    <Context.Provider
      value={{
        copyType: copyType,
        customTemplate: customTemplate,
        includeIssues: includeIssues,
        includeLocation: includeLocation,
        update: update,
      }}>
      children
    </Context.Provider>
  }
}

let use = Context.use
