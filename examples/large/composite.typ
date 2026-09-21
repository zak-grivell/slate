#import "vault.typ":*
#show: setup
#tag("oose")

#import fletcher:*

= Composite Pattern
Used to represent a tree like structure in code

#diagram(
  spacing: (50mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  node((-1, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
  node((0, 0), [*Node*], name: <n>, height: 2cm, width: 2cm),
  node((0.5, 1), [*Concrete Node A*], name: <a>, height: 2cm, width: 2cm),
  node((-0.5, 1), [*Concrete Node Leaf*], name: <l>, height: 2cm, width: 2cm),

  edge(<c>, "-|>", <n>, label: [Node node]),
  edge(<a>, "--|>", <n>, label: [implements]),
  
  edge(<a>, "--|>", <n>, label: [Node[] children], bend: -90deg), 
  edge(<l>, "--|>", <n>, label: [implements]), 
)

```java
interface Node {
  T method();
  Node[] children();
}

class ConcreteNode implements Node {
  Node[] children;

  T method() { ... }
  Node[] children() { return children }
}

class ConcreteNodeLeaf implements Node {
  T method() { ... }
  Node[] children() { return new []; }
}
```
#flashcard("What pattern is for tree like structures", "Composite")
#flashcard("Describe composite class diagram", "
#diagram(
  spacing: (50mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  node((-1, 0), [*Client*], name: <c>, height: 2cm, width: 2cm),
  node((0, 0), [*Node*], name: <n>, height: 2cm, width: 2cm),
  node((0.5, 1), [*Concrete Node A*], name: <a>, height: 2cm, width: 2cm),
  node((-0.5, 1), [*Concrete Node Leaf*], name: <l>, height: 2cm, width: 2cm),

  edge(<c>, \"-|>\", <n>, label: [Node node]),
  edge(<a>, \"--|>\", <n>, label: [implements]),
  
  edge(<a>, \"--|>\", <n>, label: [Node[] children], bend: -90deg), 
  edge(<l>, \"--|>\", <n>, label: [implements]), 
) 
")


#flashcard("What design pattern is this? ```java
interface Node {
  T method();
  Node[] children();
}
```", "Composite")
