// https://github.com/tinted-theming/schemes

#let xml_escape(value) = {
  str(value)
    .replace("&", "&amp;")
    .replace("<", "&lt;")
    .replace(">", "&gt;")
    .replace("\"", "&quot;")
    .replace("'", "&apos;")
}

#let hex(theme, key) = {
  let value = str(theme.at(key))
  if value.starts-with("#") {
    value
  } else {
    "#" + value
  }
}

#let plist_string(key, value) = {
  return "<key>" + key + "</key>" + "<string>" + xml_escape(value) + "</string>"
}

#let plist_dict(entries) = {
  "<dict>\n" + entries.join("\n") + "\n</dict>"
}

#let scope_rule(name, scope, foreground, background: none, font-style: none) = {
  let settings = (
    plist_string("foreground", foreground),
  )

  if background != none {
    settings.push(plist_string("background", background))
  }

  if font-style != none {
    settings.push(plist_string("fontStyle", font-style))
  }

  plist_dict((
    plist_string("name", name),
    plist_string("scope", scope),
    "<key>settings</key>",
    plist_dict(settings),
  ))
}

#let base16_tmtheme(
  theme,
  name: "Base16 Theme",
  uuid: "00000000-0000-0000-0000-000000000000",
) = {
  let b00 = hex(theme, "base00")
  let b01 = hex(theme, "base01")
  let b02 = hex(theme, "base02")
  let b03 = hex(theme, "base03")
  let b04 = hex(theme, "base04")
  let b05 = hex(theme, "base05")
  let b06 = hex(theme, "base06")
  let b07 = hex(theme, "base07")
  let b08 = hex(theme, "base08")
  let b09 = hex(theme, "base09")
  let b0a = hex(theme, "base0A")
  let b0b = hex(theme, "base0B")
  let b0c = hex(theme, "base0C")
  let b0d = hex(theme, "base0D")
  let b0e = hex(theme, "base0E")
  let b0f = hex(theme, "base0F")

  let rules = (
    // Global defaults.
    plist_dict((
      plist_string("name", "Global"),
      "<key>settings</key>",
      plist_dict((
        plist_string("background", b00),
        plist_string("foreground", b05),
        plist_string("caret", b05),
        plist_string("lineHighlight", b01),
        plist_string("selection", b02),
        plist_string("inactiveSelection", b01),
      )),
    )),
    // Syntax scopes.
    scope_rule(
      "Comments",
      "comment, punctuation.definition.comment",
      b03,
      font-style: "italic",
    ),
    scope_rule(
      "Strings",
      "string, punctuation.definition.string",
      b0b,
    ),
    scope_rule(
      "Numbers and constants",
      "constant.numeric, constant.language, constant.character, variable.other.constant",
      b09,
    ),
    scope_rule(
      "Builtins and support",
      "support, support.function, support.class, support.type",
      b0c,
    ),
    scope_rule(
      "Keywords",
      "keyword, storage, storage.type, storage.modifier",
      b0e,
    ),
    scope_rule(
      "Operators and punctuation",
      "keyword.operator, punctuation, meta.brace, meta.delimiter",
      b05,
    ),
    scope_rule(
      "Functions",
      "entity.name.function, meta.function-call, support.function",
      b0d,
    ),
    scope_rule(
      "Types and classes",
      "entity.name.type, entity.name.class, support.type, support.class",
      b0a,
    ),
    scope_rule(
      "Variables",
      "variable, variable.other, variable.parameter",
      b08,
    ),
    scope_rule(
      "Properties and fields",
      "variable.other.property, variable.other.member, support.variable.property",
      b0d,
    ),
    scope_rule(
      "Tags",
      "entity.name.tag, punctuation.definition.tag",
      b08,
    ),
    scope_rule(
      "Attributes",
      "entity.other.attribute-name",
      b09,
    ),
    scope_rule(
      "Headings and markup",
      "markup.heading, entity.name.section",
      b0d,
      font-style: "bold",
    ),
    scope_rule(
      "Bold markup",
      "markup.bold",
      b0a,
      font-style: "bold",
    ),
    scope_rule(
      "Italic markup",
      "markup.italic",
      b0e,
      font-style: "italic",
    ),
    scope_rule(
      "Inserted",
      "markup.inserted, meta.diff.header.to-file",
      b0b,
    ),
    scope_rule(
      "Deleted",
      "markup.deleted, meta.diff.header.from-file",
      b08,
    ),
    scope_rule(
      "Changed",
      "markup.changed",
      b0a,
    ),
    scope_rule(
      "Invalid",
      "invalid, invalid.illegal",
      b00,
      background: b08,
    ),
  )

  let settings-array = rules.map(rule => "    " + rule.replace("\n", "\n    ")).join("\n")

  let s = ""

  s += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
  s += "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" "
  s += "\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
  s += "<plist version=\"1.0\">\n"
  s += "<dict>\n"
  s += "  <key>name</key>\n"
  s += "  <string>" + xml_escape(name) + "</string>\n"
  s += "  <key>uuid</key>\n"
  s += "  <string>" + xml_escape(uuid) + "</string>\n"
  s += "  <key>settings</key>\n"
  s += "  <array>\n"
  s += settings-array + "\n"
  s += "  </array>\n"
  s += "</dict>\n"
  s += "</plist>\n"

  return s
}
#let get_theme(name) = {
  yaml("../themes/" + name + ".yaml").at("palette")
}

#let apply_theme(body, theme, font) = {
  set page(fill: rgb(theme.base00))
  set text(fill: rgb(theme.base05))

  // Headings
  show heading.where(level: 1): set text(fill: rgb(theme.base0A))
  show heading.where(level: 2): set text(fill: rgb(theme.base0B))
  show heading.where(level: 3): set text(fill: rgb(theme.base0C))
  show heading.where(level: 4): set text(fill: rgb(theme.base0D))
  show heading.where(level: 5): set text(fill: rgb(theme.base0E))
  show heading: set text(fill: rgb(theme.base0E))

  show emph: set text(fill: rgb(theme.base0D))
  show strong: set text(fill: rgb(theme.base09))
  show quote: set text(fill: rgb(theme.base0C))

  set raw(theme: bytes(base16_tmtheme(theme)))

  show link: set text(fill: rgb(theme.base0C))

  [#metadata(theme.base00) <theme>]
  [#metadata(theme.base01) <theme>]
  [#metadata(theme.base02) <theme>]
  [#metadata(theme.base03) <theme>]
  [#metadata(theme.base04) <theme>]
  [#metadata(theme.base05) <theme>]
  [#metadata(theme.base06) <theme>]
  [#metadata(theme.base07) <theme>]
  [#metadata(theme.base08) <theme>]
  [#metadata(theme.base09) <theme>]
  [#metadata(theme.base0A) <theme>]
  [#metadata(theme.base0B) <theme>]
  [#metadata(theme.base0C) <theme>]
  [#metadata(theme.base0D) <theme>]
  [#metadata(theme.base0E) <theme>]
  [#metadata(theme.base0F) <theme>]

  body
}
