module CopyToClipboard = {
  @react.component @module("react-copy-to-clipboard")
  external make: (
    ~text: string,
    ~children: React.element,
    ~onCopy: unit => unit=?,
  ) => React.element = "CopyToClipboard"
}

module HotToast = {
  module Toaster = {
    @react.component @module("react-hot-toast")
    external make: unit => React.element = "Toaster"
  }

  @module("react-hot-toast") @scope("toast") external success: string => unit = "success"
}
