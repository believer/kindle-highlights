module CopyToClipboard = {
  @react.component @module("react-copy-to-clipboard")
  external make: (
    ~text: string,
    ~children: React.element,
    ~onCopy: unit => unit=?,
  ) => React.element = "CopyToClipboard"
}
