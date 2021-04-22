@react.component
let make = () => {
  let {copyType, setCopyType} = GlobalState.use()

  <div className="mt-8 border-gray-200 border p-5">
    <Form.RadioButtonGroup
      label="Format to copy highlights"
      name="copy-type"
      onChange={value => {setCopyType(GlobalState.Settings.fromString(value))}}>
      <Form.RadioButton
        checked={switch copyType {
        | Markdown => true
        | Roam
        | Logseq => false
        }}
        id={GlobalState.Settings.toString(Markdown)}
        label="Markdown"
        name="copy-type"
        value={GlobalState.Settings.toString(Markdown)}
      />
      <Form.RadioButton
        checked={switch copyType {
        | Roam => true
        | Markdown
        | Logseq => false
        }}
        id={GlobalState.Settings.toString(Roam)}
        label="Roam Research"
        name="copy-type"
        value={GlobalState.Settings.toString(Roam)}
      />
      <Form.RadioButton
        checked={switch copyType {
        | Logseq => true
        | Roam
        | Markdown => false
        }}
        id={GlobalState.Settings.toString(Logseq)}
        label="Logseq"
        name="copy-type"
        value={GlobalState.Settings.toString(Logseq)}
      />
    </Form.RadioButtonGroup>
  </div>
}
