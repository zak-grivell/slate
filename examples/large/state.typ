#import "vault.typ":*
#show: setup
#import fletcher:*
#tag("oose")

= State Pattern
Pattern where a client class holds onto a `State` interface which it can call methods on. Multiple `ConcreteState`s will then inherit from `State` in which the `Concrete` itself controls what the next state is.

 #diagram(
    spacing: (18mm, 10mm),
    node-stroke: luma(80%),
    edge-stroke: luma(80%),
    
    node((0, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
    node((2, 0), [*State*], name: <s>, height: 2cm, width: 2cm),
    node((2, 1), [*Concrete State*], name: <cs>, height: 2cm, width: 2cm),

    edge(<c>, "-|>", <s>, label: [State state]),
    edge(<cs>, "-|>", <s>, label: [implements]),
    edge(<cs>, "-|>", <s>, label: [nextState()], bend: 45deg),
  )

```java
class Client {
  State state;

  void next() {
    state.next(this);
  }

  void set(State state) {
    this.state = state;
  }
}

interface State {
  T method(U u);

  void next(Client client);
}

class ConcreteState implements State {
  T method(U u) { ... }

  void next(Client client) { ... }
}

```
#flashcard("Describe the UML class diagram of the State Pattern", "#diagram(
    spacing: (18mm, 10mm),
    node-stroke: luma(80%),
    edge-stroke: luma(80%),
    
    node((0, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
    node((2, 0), [*State*], name: <s>, height: 2cm, width: 2cm),
    node((2, 1), [*Concrete State*], name: <cs>, height: 2cm, width: 2cm),

    edge(<c>, \"-|>\", <s>, label: [State state]),
    edge(<cs>, \"-|>\", <s>, label: [implements]),
    edge(<cs>, \"-|>\", <s>, label: [nextState()], bend: 45deg),
  )
")

#flashcard("Why use the state pattern", "Reduce switch statements by allowing a class to split into multiple states")

#flashcard(
  "Difference between state and strategy pattern",
  "Strategy the external source controls next behaviour whereas State the next is internal."
)

#flashcard(
  "What design pattern is this

  ```java
class Client {
  Pattern pattern;

  void next() {
    pattern.next(this);
  }

  void set(Pattern pattern) {
    this.pattern = pattern;
  }
}

interface Pattern {
  T method(U u);

  void next(Client client);
}

class ConcretePattern implements Pattern {
  T method(U u) { ... }

  void next(Client client) { ... }
}
   ```",
  "State Pattern"
)

#flashcard("Examples of State pattern", "Traffic Lights")
