open GlobalState

@react.component
let make = () => {
  let {
    copyType,
    customTemplate,
    includeIssues,
    includeLocation,
    setCopyType,
    setCustomTemplate,
    setIncludeIssues,
    setIncludeLocation,
  } = use()

  <div className="mt-8 border-gray-200 dark:border-gray-800 border p-5 grid grid-cols-2">
    <div>
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
      <div className="mt-8 space-y-4">
        <div className="text-sm font-semibold"> {React.string("Other settings")} </div>
        <Form.Checkbox
          checked={includeLocation}
          id="include-location"
          name="include-location"
          label="Include location"
          onChange={setIncludeLocation}
        />
        <Form.Checkbox
          checked={includeIssues}
          id="include-issues"
          name="include-issues"
          label="Include notes with potential issues"
          onChange={setIncludeIssues}
        />
      </div>
    </div>
    <div>
      <Form.Textarea label="Custom template" onChange={setCustomTemplate} value={customTemplate} />
      <div className="text-sm dark:text-gray-400 mt-2">
        {React.string("Available variables: ")}
        <div className="inline-block px-1 rounded dark:bg-gray-800 dark:text-pink-400">
          {React.string("{{author}}")}
        </div>
        {React.string(", ")}
        <div className="inline-block px-1 rounded dark:bg-gray-800 dark:text-pink-400">
          {React.string("{{highlights}}")}
        </div>
        {React.string(", ")}
        <div className="inline-block px-1 rounded dark:bg-gray-800 dark:text-pink-400">
          {React.string("{{title}}")}
        </div>
      </div>
    </div>
  </div>
}
