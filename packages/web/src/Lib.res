module CopyToClipboard = {
  @react.component @module("react-copy-to-clipboard")
  external make: (
    ~text: string,
    ~children: React.element,
    ~onCopy: unit => unit=?,
  ) => React.element = "CopyToClipboard"
}

module HotToast = {
  type t

  module Toaster = {
    @react.component @module("react-hot-toast")
    external make: unit => React.element = "Toaster"
  }

  @module("react-hot-toast")
  external make: t = "default"

  @send external success: (t, string) => unit = "success"
}
