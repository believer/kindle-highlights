open Promise

let use = () => {
  let (state, setState) = React.useState(() => "")

  let handleUpload = file => {
    file["text"]()
    ->then(data => {
      setState(_ => data)
      resolve()
    })
    ->ignore
  }

  let uploadFromFile = e => (e->ReactEvent.Form.target)["files"][0]->handleUpload

  let uploadFromDrop = e => {
    let item = e["dataTransfer"]["items"][0]
    switch item["kind"] {
    | "file" => item["getAsFile"]()->handleUpload
    | _ => ()
    }
  }

  (state, uploadFromFile, uploadFromDrop)
}
