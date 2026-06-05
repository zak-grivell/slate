#import "vault.typ": *;
#show: setup
#tag("oose")

= Adapter Pattern
Used to allow two systems to interface with each other despite different interfaces.

#diagram(
  spacing: (50mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  node((0, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
  node((1, 0), [*Target*], name: <t>, height: 2cm, width: 2cm),
  node((2, 1), [*Adaptee*], name: <ae>, height: 2cm, width: 2cm),
  node((1, 1), [*Adapter*], name: <ar>, height: 2cm, width: 2cm),

  edge(<c>, "-|>", <t>, label: [method()]),
  edge(<ar>, "--|>", <t>, label: [implements]),
  edge(<ar>, "-|>", <ae>, label: [wrapper()], left),
  // edge(<o>, "-|>", <s>, label: [observers: Observer[]], left),
  // edge(<cs>, "--|>", <co>, label: [notifyObservers], left),
)

```java
interface Target {
  T method(U u);
}

class Adapter implements Target {
  Adaptee adaptee

  T method(U u) {
    return transform(adaptee.wrapper(transform(u)));
  }
}

class Adaptee {
  V wrapper(W w) { ... }
}
```

#flashcard("What design pattern is for connecting two systems that need different formats", "Adapter")
#flashcard("Describe the UML diagram of the adapter pattern", "
#diagram(
  spacing: (50mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  node((0, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
  node((1, 0), [*Target*], name: <t>, height: 2cm, width: 2cm),
  node((2, 1), [*Adaptee*], name: <ae>, height: 2cm, width: 2cm),
  node((1, 1), [*Adapter*], name: <ar>, height: 2cm, width: 2cm),

  edge(<c>, \"-|>\", <t>, label: [method()]),
  edge(<ar>, \"--|>\", <t>, label: [implements]),
  edge(<ar>, \"-|>\", <ae>, label: [wrapper()], left),
  // edge(<o>, \"-|>\", <s>, label: [observers: Observer[]], left),
  // edge(<cs>, \"--|>\", <co>, label: [notifyObservers], left),
)")
#flashcard("What dp is this
```java
interface Target {
  T method(U u);
}

class X implements Target {
  Y y

  T method(U u) {
    return transform(y.wrapper(transform(u)));
  }
}

class Y {
  V wrapper(W w) { ... }
}
```
", "Adapter")
