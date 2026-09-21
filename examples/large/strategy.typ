#import "vault.typ":*
#show: setup
#tag("oose")

= Strategy Pattern
Pattern where a client class holds on to a `Behaviour` interface which it can call methods on. Multiple concrete strategies implement `Behaviour`, and the client can swap between them at runtime.

#diagram(
    spacing: (18mm, 10mm),
    node-stroke: luma(80%),
    edge-stroke: luma(80%),
    fletcher.node((-1, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
    fletcher.node((2, 0), [*Behaviour*], name: <b>, height: 2cm, width: 2cm),
    fletcher.node((2, 1), [*Concrete Behaviour*], name: <cb>, height: 2cm, width: 2cm),

    fletcher.edge(<c>, "-|>", <b>, label: [Behaviour behaviour]),
    fletcher.edge(<cb>, "--|>", <b>, label: [implements]),
)

```java
class Client {
  Behaviour behaviour;
}

interface Behaviour {
  T method(U u);
}

class BehaviourA implements Behaviour {
 T method(U u) {}
}
```

Strategy Pattern is useful when you have interchangeable behaviour within an object and want to choose that behaviour externally rather than letting the object transition internally like in the `State` pattern.

#flashcard("Why use the strategy pattern", "Reduce switch statements by allowing a class to split into multiple options")

#flashcard("Describe the UML diagram of the Strategy Pattern", "#diagram(
    spacing: (18mm, 10mm),
    node-stroke: luma(80%),
    edge-stroke: luma(80%),
    node((-1, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
    node((2, 0), [*Behaviour*], name: <b>, height: 2cm, width: 2cm),
    node((2, 1), [*Concrete Behaviour*], name: <cb>, height: 2cm, width: 2cm),

    edge(<c>, \"-|>\", <b>, label: [Behaviour behaviour]),
    edge(<cb>, \"--|>\", <b>, label: [implements]),
)")

#flashcard("

```java
class Client {
  Behaviour behaviour;
}

interface Behaviour {
  T method(U u);
}

class BehaviourA implements Behaviour {
 T method(U u) {}
}
```
", "Strategy")

#flashcard("Why would you use the strategy pattern", "When you want to swap an algorithm or behaviour at runtime")

#flashcard("Examples of Strategy pattern", "A save system can choose local, cloud, or database saving without changing the client")
