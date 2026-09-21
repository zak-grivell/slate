use dioxus::prelude::*;
use slate_api::get_colors;

const DEFAULT_COLORS: [&str; 16] = [
    "#303446", "#292c3c", "#414559", "#51576d", "#626880", "#c6d0f5", "#f2d5cf", "#babbf1",
    "#e78284", "#ef9f76", "#e5c890", "#a6d189", "#81c8be", "#8caaee", "#ca9ee6", "#eebebe",
];

fn get_colors_css(colors: &[String]) -> String {
    let colors: Vec<&str> = if colors.len() >= 16 {
        colors.iter().take(16).map(String::as_str).collect()
    } else {
        DEFAULT_COLORS.to_vec()
    };

    format!(
        "
    html, body {{
        margin: 0;
        padding: 0;
    }}        :root {{
      --base00: {};
      --base01: {};
      --base02: {};
      --base03: {};
      --base04: {};
      --base05: {};
      --base06: {};
      --base07: {};
      --base08: {};
      --base09: {};
      --base0A: {};
      --base0B: {};
      --base0C: {};
      --base0D: {};
      --base0E: {};
      --base0F: {};

      font-family: \"JetBrainsMono NF\", serif ;
    }}",
        colors[0],
        colors[1],
        colors[2],
        colors[3],
        colors[4],
        colors[5],
        colors[6],
        colors[7],
        colors[8],
        colors[9],
        colors[10],
        colors[11],
        colors[12],
        colors[13],
        colors[14],
        colors[15],
    )
}

#[component]
pub fn Base16Theme() -> Element {
    let colors = use_server_future(get_colors)?;

    let css = colors
        .read()
        .as_ref()
        .and_then(|res| res.as_ref().ok())
        .map(|v| get_colors_css(v));

    rsx! {
        document::Stylesheet { href: "/assets/tailwind.css" }

        document::Style {
            {
                match css {
                    Some(value) => value,
                    None => {
                        println!("error getting css");
                        String::new()
                    }
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn empty_theme_metadata_uses_default_colors() {
        let css = get_colors_css(&[]);

        assert!(css.contains("--base00: #303446"));
        assert!(css.contains("--base0F: #eebebe"));
    }
}
