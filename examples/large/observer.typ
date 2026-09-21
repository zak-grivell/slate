#import "vault.typ":*
#import fletcher:node, edge
#show: setup
#tag("oose")

= Observer Pattern
Used to send updates from a subject to dependent observers, such as signals in web frameworks.

#diagram(
  spacing: (50mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
node((1, 0), [*Observer*], name: <o>, height: 2cm, width: 2cm),
node((-1, 0), [*Subject*], name: <s>, height: 2cm, width: 2cm),
node((-1, 1), [*Concrete Subject*], name: <cs>, height: 2cm, width: 2cm),
node((1, 1), [*Concrete Observer*], name: <co>, height: 2cm, width: 2cm),
edge(<co>, "-|>", <o>, label: [implements]),
edge(<cs>, "-|>", <s>, label: [implements]),
edge(<s>, "-|>", <o>, label: [notifyObservers], left, shift: 0.5cm),
edge(<cs>, "-|>", <o>, label: [observers: Observer[]], left),
)

```java
interface Observer {
  void notify(T t);
}

interface Subject {
  void notifyObservers(T t);
  void addObserver(Observer observer);
  void removeObserver(Observer observer);
}

class ConcreteObserver implements Observer {
  void notify(T t) { ... }
}

class ConcreteSubject implements Subject {
  List<Observer> observers;

  void notifyObservers(T t) {
    for (Observer observer: observers) { observer.notify(t); }
  }

  void addObserver(Observer observer) {
    observers.add(observer);
  }

  void removeObserver(Observer observer) {
    observers.remove(observer);
  }
};
```

#flashcard("Why use the observer pattern", "Notify many dependent objects when one subject changes")

#flashcard(
"
What is this design pattern
#diagram(
  spacing: (50mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  node((1, 0), [*XXXXX*], name: <o>, height: 2cm, width: 2cm),
  node((-1, 0), [*XXXXX*], name: <s>, height: 2cm, width: 2cm),
  node((-1, 1), [*XXXXX XXXXX*], name: <cs>, height: 2cm, width: 2cm),
  node((1, 1), [*XXXXX XXXXX*], name: <co>, height: 2cm, width: 2cm),

  edge(<co>, \"-|>\", <o>, label: [implements]),
  edge(<cs>, \"-|>\", <s>, label: [implements]),
  edge(<s>, \"-|>\", <o>, label: [XXXXXXXX], left, shift: 0.5cm),
  edge(<cs>, \"-|>\", <o>, label: [XXXXXXXXX: XXXXXXXX[]], left),
)
", "Observer"
)

#flashcard("Describe the implementation of the observer design pattern", "
```java
interface Observer {
  void notify(T t);
}

interface Subject {
  void notifyObservers(T t);
  void addObserver(Observer observer);
  void removeObserver(Observer observer);
}

class ConcreteObserver implements Observer {
  void notify(T t) { ... }
}

class ConcreteSubject implements Subject {
  List<Observer> observers;

  void notifyObservers(T t) {
    for (Observer observer: observers) { observer.notify(t); }
  }

  void addObserver(Observer observer) {
    observers.add(observer);
  }

  void removeObserver(Observer observer) {
    observers.remove(observer);
  }
};
```
")

#flashcard("Example of Observer Pattern", "Signals, Weather and Event Listeners")
