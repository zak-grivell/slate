use dioxus::prelude::*;

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub struct Message<T> {
    pub id: u64,
    pub value: T,
}

#[derive(Clone, Copy)]
pub struct Messenger<T: Clone + 'static> {
    next_id: Signal<u64>,
    message: Signal<Option<Message<T>>>,
}

impl<T: Clone + 'static> Messenger<T> {
    pub fn send(&mut self, value: T) {
        let id = self.next_id + 1;

        self.next_id.set(id);
        self.message.set(Some(Message { id, value }));
    }

    pub fn latest(&self) -> Option<Message<T>> {
        self.message.read().clone()
    }

    pub fn new() -> Messenger<T> {
        Messenger {
            next_id: Signal::new(0),
            message: Signal::new(None),
        }
    }
}

pub fn use_messenger<T: Clone + 'static>() -> Messenger<T> {
    try_consume_context::<Messenger<T>>()
        .unwrap_or_else(|| use_context_provider(|| Messenger::<T>::new()))
}

pub fn use_receiver<T, F>(mut handler: F)
where
    T: Clone + 'static,
    F: FnMut(T) + 'static,
{
    let messenger = use_context::<Messenger<T>>();
    let mut last_seen = use_signal(|| 0u64);

    use_effect(move || {
        let Some(message) = messenger.latest() else {
            return;
        };

        if message.id <= last_seen() {
            return;
        }

        last_seen.set(message.id);
        handler(message.value);
    });
}
