
#import "themes.typ": apply_theme, get_theme

#let vault(body, font, theme) = {

  set text(font: font)

  show math.equation: it => context {
    // only wrap in frame on html export
    if target() == "html" {
      // wrap frames of inline equations in a box
      // so they don't interrupt the paragraph
      show: if it.block { it => it } else { box }
      html.frame(it)
    } else {
      it
    }
  }

  show quote: it => context {
    // only wrap in frame on html export
    if target() == "html" {
      html.elem("q")[it]
    } else {
      it
    }
  }
  
  apply_theme(body, get_theme(theme), font)
}

