#import "vault.typ":*
#show: setup
#tag("oose")

#import fletcher:*

= Iterator
Used to loop over elements in a collection without caring about its internal structure.

#diagram(
  spacing: (40mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  
  node((0, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
  node((2, 0), [*Iterator*], name: <i>, height: 2cm, width: 2cm),
  node((2, 1), [*Concrete Iterator*], name: <ci>, height: 2cm, width: 2cm),

  edge(<c>, "-|>", <i>, label: [Iterator iterator]),
  edge(<i>, "-|>", <ci>, label: [hasNext()], left),
  edge(<i>, "-|>", <ci>, label: [next()], right),
)

```java
interface Iterator {
  boolean hasNext();
  Item next();
}

class ConcreteIterator implements Iterator {
  boolean hasNext() { ... }
  Item next() {}
}
```

#flashcard("Why use the iterator pattern", "Loop over items in a collection without caring the internal structure")

#flashcard("
```java
interface XXXXXXXX {
  boolean hasNext();
  Item next();
}
```
", "Iterator")

#flashcard("Examples of iterator pattern", "For-each loops")
