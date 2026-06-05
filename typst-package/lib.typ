#import "src/vault.typ": vault
#import "src/flashcard.typ": flashcard
#import "src/note.typ": note
#import "src/tag.typ": tag

= This is the vault root
- Configure your settings
- Import librarys for global use
- Shadow library functions for styling

```typst
#let canvas = #cetz.canvas({
  import cetz.draw: *

  // Change the design for all elements after it
  set-style(
    // Design of arrow tips at the end of lines
    mark: (fill: black, scale: 2),
    // Design of lines
    stroke: (thickness: 0.4pt, cap: "round"),
    // Design of angles
    angle: (
      radius: 0.3,
      label-radius: .22,
      fill: green.lighten(80%),
      stroke: (paint: green.darken(50%))
    ),
    // Design of all text elements with an anchor
    content: (padding: 1pt)
  )
})
```
