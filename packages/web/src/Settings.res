open GlobalState

@react.component
let make = () => {
  let {
    copyType,
    includeIssues,
    includeLocation,
    setCopyType,
    setIncludeIssues,
    setIncludeLocation,
  } = use()

  <div className="mt-8 border-gray-200 dark:border-gray-800 border p-5 grid grid-cols-2">
    <Form.RadioButtonGroup
      label="Preferred format to copy highlights"
      name="copy-type"
      onChange={value => {setCopyType(CopyTypeConfig.fromString(value))}}>
      <Form.RadioButton
        checked={switch copyType {
        | Markdown => true
        | Roam
        | Logseq => false
        }}
        id={CopyTypeConfig.toString(Markdown)}
        label="Markdown"
        name="copy-type"
        value={CopyTypeConfig.toString(Markdown)}
      />
      <Form.RadioButton
        checked={switch copyType {
        | Roam => true
        | Markdown
        | Logseq => false
        }}
        id={CopyTypeConfig.toString(Roam)}
        label="Roam Research"
        name="copy-type"
        value={CopyTypeConfig.toString(Roam)}
      />
      <Form.RadioButton
        checked={switch copyType {
        | Logseq => true
        | Roam
        | Markdown => false
        }}
        id={CopyTypeConfig.toString(Logseq)}
        label="Logseq"
        name="copy-type"
        value={CopyTypeConfig.toString(Logseq)}
      />
    </Form.RadioButtonGroup>
    <div className="space-y-4">
      <div className="text-sm font-semibold"> {React.string("Other settings")} </div>
      <Form.Checkbox
        checked={includeLocation}
        id="include-location"
        name="include-location"
        label="Include location"
        onChange={e => {
          let checked = (e->ReactEvent.Form.target)["checked"]
          setIncludeLocation(checked)
        }}
      />
      <Form.Checkbox
        checked={includeIssues}
        id="include-issues"
        name="include-issues"
        label="Include notes with potential issues"
        onChange={e => {
          let checked = (e->ReactEvent.Form.target)["checked"]
          setIncludeIssues(checked)
        }}
      />
    </div>
  </div>
}
