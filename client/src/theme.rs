use dioxus::prelude::*;
use slate_api::get_colors;

fn get_colors_css(colors: Vec<String>) -> String {
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
        .map(|v| get_colors_css(v.to_vec()));

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
