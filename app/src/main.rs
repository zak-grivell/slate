use slate_client::App;

fn main() {
    #[cfg(feature = "server")]
    dioxus::serve(|| async move {
        let router = dioxus::server::router(App);
        Ok(router)
    });

    #[cfg(not(feature = "server"))]
    dioxus::launch(App);
}
