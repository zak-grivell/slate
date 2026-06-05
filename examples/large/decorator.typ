#import "vault.typ":*
#show: setup
#tag("oose")

= Decorator
Pattern that allows dynamic layering of objects to add responsibilities without modifying the original component.


#diagram(
  spacing: (40mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  node((0, 0), [*Component*], name: <c>, height: 3cm, width: 3cm),
  node((-0.5, 1), [*Concrete Component*], name: <cc>, height: 3cm, width: 3cm),
  node((0.5, 1), [*Decorator*], name: <d>, height: 3cm, width: 3cm),
  node((0.5, 2), [*Concrete Decorator*], name: <cd>, height: 3cm, width: 3cm),

  edge(<cd>, "-|>", <d>, label: [extends]),
  edge(<cc>, "--|>", <c>, label: [implements]),
  edge(<c>, "-|>", <d>, label: [implements], right),
  edge(<d>, "--|>", <c>, label: [Component component], shift: 5pt, right),
)

A component implements the Component interface with the methods available, whereas a decorator wraps another component which can be either a concrete component or another decorator.

#flashcard("What is the component in the decorator pattern", "Interface all nodes implement with the methods the client wants to call")
#flashcard("What is the decorator class in the decorator pattern", "One that holds a reference to another component")
#flashcard("What does the UML of decorator look like?", "

#diagram(
  spacing: (40mm, 20mm),
  node-stroke: luma(80%),
  edge-stroke: luma(80%),
  node((0, 0), [*Component*], name: <c>, height: 3cm, width: 3cm),
  node((-0.5, 1), [*Concrete Component*], name: <cc>, height: 3cm, width: 3cm),
  node((0.5, 1), [*Decorator*], name: <d>, height: 3cm, width: 3cm),
  node((0.5, 2), [*Concrete Decorator*], name: <cd>, height: 3cm, width: 3cm),

  edge(<cd>, \"-|>\", <d>, label: [extends]),
  edge(<cc>, \"--|>\", <c>, label: [implements]),
  edge(<c>, \"-|>\", <d>, label: [implements], right),
  edge(<d>, \"--|>\", <c>, label: [Component component], shift: 5pt, right),
)

")

= Inheritance vs Composition
But does decorator break the prefer composition over inheritance principle?
No, because the decorator is using composition to hold a reference to the component it is decorating, rather than inheriting from it. The decorator can be seen as a wrapper around the component, allowing for additional functionality to be added without modifying the original component.

#flashcard("Which should be used inheritance or composition", "Composition")
#flashcard("Why should composition be used over inheritance", "Reduce coupling and increase flexibility")
#flashcard(
  "Why does the decorator not break the composition over inheritance principle",
  "It uses inheritance for the shared interface but composition to add behaviour",
)