module RadioButtonGroup = {
  @react.component
  let make = (~children, ~label, ~name, ~onChange) => {
    <fieldset
      className="space-y-4"
      name
      onChange={e => {
        let value = (e->ReactEvent.Form.target)["value"]
        onChange(value)
      }}>
      <legend className="text-sm font-semibold"> {React.string(label)} </legend> children
    </fieldset>
  }
}

module RadioButton = {
  @react.component
  let make = (~value, ~id, ~name, ~label, ~checked) => {
    <label className="flex gap-x-2 items-center text-sm cursor-pointer group">
      <input
        className="absolute -left-96 sibling-focus"
        checked
        readOnly={true}
        type_="radio"
        name={name}
        id
        value={value}
      />
      <div
        className={Cn.fromList(list{
          "border-2 rounded-full p-1 w-6 h-6 group-hover:ring-2 group-hover:ring-offset-2 group-hover:ring-pink-300",
          switch checked {
          | true => "bg-pink-300 border-pink-400"
          | false => "border-gray-300"
          },
        })}
      />
      {React.string(label)}
    </label>
  }
}

module Checkbox = {
  @react.component
  let make = (~value, ~id, ~name, ~label, ~checked) => {
    <label className="flex gap-x-2 items-center text-sm cursor-pointer group">
      <input
        className="absolute -left-96 sibling-focus"
        checked
        readOnly={true}
        type_="checkbox"
        name={name}
        id
        value={value}
      />
      <div
        className={Cn.fromList(list{
          "border-2 rounded-full p-1 w-6 h-6 group-hover:ring-2 group-hover:ring-offset-2 group-hover:ring-pink-300",
          switch checked {
          | true => "bg-pink-300 border-pink-400"
          | false => "border-gray-300"
          },
        })}
      />
      {React.string(label)}
    </label>
  }
}
