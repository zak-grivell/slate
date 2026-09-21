#import "@preview/digestify:0.1.0": *

#let flashcard(question, answer) = {
  let id = bytes-to-hex(sha256(bytes(repr(question) + repr(answer))))
  
  [#metadata((kind: "flashcard", id: id, q: question, a: answer)) <flashcard>]

  if (sys.inputs.at("card", default: none) == id) {
    question;
    answer;
  }
}
