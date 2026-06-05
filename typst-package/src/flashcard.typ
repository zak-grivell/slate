#import "@preview/digestify:0.1.0"

#let flashcard(question, answer) = {
  let id = bytes-to-hex(sha256(bytes(repr(q) + repr(a))))
  
  [#metadata((kind: "flashcard", id: id, q: q, a: a)) <flashcard>]

  if (sys.inputs.get("card") == id) {
    question;
    answer;
  }
}
