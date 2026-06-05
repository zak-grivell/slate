#let note(path) = {
  // let name = name.at(0)
  let file = path.split("/").last()

  [#metadata(path) <note>]

  let base = file.replace(regex("\.[^.]+$"), "")

  let words = base.replace("_", " ").replace("-", " ")

  let generated_name = words
    .split(" ")
    .map(word => {
      if word.len() == 0 {
        ""
      } else {
        upper(word.at(0)) + word.slice(1)
      }
    })
    .join(" ")
    
  link(path, generated_name)
}
