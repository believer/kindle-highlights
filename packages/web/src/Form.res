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
  let make = (~value, ~id, ~name, ~label, ~checked, ~hint=?) => {
    <div>
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
            "border-2 rounded-full p-1 w-6 h-6 group-hover:ring-2 group-hover:ring-offset-2 group-hover:ring-pink-300 dark:group-hover:ring-offset-gray-900 dark:group-hover:ring-pink-600",
            switch checked {
            | true => "bg-pink-300 border-pink-400"
            | false => "border-gray-300"
            },
          })}
        />
        {React.string(label)}
      </label>
      {switch hint {
      | Some(hint) =>
        <div className="text-xs mt-2 text-gray-500 dark:text-gray-400"> {hint->React.string} </div>
      | None => React.null
      }}
    </div>
  }
}

module Checkbox = {
  @react.component
  let make = (~id, ~name, ~label, ~checked, ~onChange) => {
    <label className="flex gap-x-2 items-center text-sm cursor-pointer group">
      <input
        className="absolute -left-96 sibling-focus"
        checked
        onChange={e => {
          let checked = (e->ReactEvent.Form.target)["checked"]
          onChange(checked)
        }}
        type_="checkbox"
        name={name}
        id
      />
      <div
        className={Cn.fromList(list{
          "border-2 w-6 h-6 group-hover:ring-2 group-hover:ring-offset-2 group-hover:ring-pink-300 flex items-center justify-center dark:group-hover:ring-offset-gray-900 dark:group-hover:ring-pink-600 rounded-sm",
          switch checked {
          | true => "bg-pink-300 border-pink-400 text-pink-600"
          | false => "border-gray-300"
          },
        })}>
        {switch checked {
        | false => React.null
        | true =>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            className="h-5 w-5"
            viewBox="0 0 20 20"
            fill="currentColor">
            <path
              fillRule="evenodd"
              d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
              clipRule="evenodd"
            />
          </svg>
        }}
      </div>
      {React.string(label)}
    </label>
  }
}

module Textarea = {
  @react.component
  let make = (~label, ~onChange, ~value) => {
    <label className="block text-sm">
      <div className="font-bold mb-4"> {React.string(label)} </div>
      <textarea
        className="border-gray-300 border dark:bg-gray-800 dark:border-gray-700 w-full h-48 rounded resize-none focus:outline-none dark:focus:ring-2 focus:ring-offset-2 dark:focus:ring-offset-gray-900 dark:focus:ring-pink-600 p-5"
        onChange={e => {
          let value = (e->ReactEvent.Form.target)["value"]
          onChange(value)
        }}
        value
      />
    </label>
  }
}
