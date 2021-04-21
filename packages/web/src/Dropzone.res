external toDragEvent: ReactEvent.Mouse.t => Js.t<_> = "%identity"

@react.component
let make = (~onDrop) => {
  let (isDragOver, setIsDragOver) = React.useState(() => false)

  <textarea
    className={Cn.fromList(list{
      "fixed inset-0 bg-white w-full -z-10",
      "bg-indigo-100"->Cn.on(isDragOver),
    })}
    onDragEnter={_ => setIsDragOver(_ => true)}
    onDragLeave={_ => setIsDragOver(_ => false)}
    onDrop={e => {
      ReactEvent.Mouse.preventDefault(e)
      e->toDragEvent->onDrop
      setIsDragOver(_ => false)
    }}
  />
}
