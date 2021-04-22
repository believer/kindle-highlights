@val @scope("localStorage") external setItem: (string, string) => unit = "setItem"
@val @scope("localStorage") external getItem: string => Js.Nullable.t<string> = "getItem"
@val @scope("window")
external addEventListener: (string, Js.t<_> => unit) => unit = "addEventListener"
@val @scope("window")
external removeEventListener: (string, Js.t<_> => unit) => unit = "removeEventListener"

module type Config = {
  type t

  let key: string
  let fromString: option<string> => t
  let toString: t => string
}

module Make = (Config: Config) => {
  let useLocalStorage = () => {
    let key = `kindle-highlights-${Config.key}`
    let (state, setState) = React.useState(() => getItem(key))

    let setValue = value => {
      setItem(key, value->Config.toString)
      setState(_ => getItem(key))
    }

    React.useEffect0(() => {
      let onStorage = data => {
        Js.log(data)
      }

      addEventListener("storage", onStorage)

      Some(() => removeEventListener("storage", onStorage))
    })

    (state->Js.Nullable.toOption->Config.fromString, setValue)
  }
}
