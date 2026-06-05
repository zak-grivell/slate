#import "vault.typ":*
#show: setup
#tag("ads")

= Recursion
When a function calls itself. It can be used to represent algorithms in a simpler way: define a base case and a step to make the input simpler.

A recursion trace is a diagram of how recursion flows, this is useful as it can sometimes be hard to reason about the flow of data for example factorial

// #diagram(
//   spacing: (40mm, 5mm),
//   node-stroke: luma(80%),
//   edge-stroke: luma(80%),
//   node((0,0), [FACT(4)], name: <4>),
//   node((0,1), [FACT(3)], name: <3>),
//   node((0,2), [FACT(2)], name: <2>),
//   node((0,3), [FACT(1)], name: <1>),
//   edge((0,-1), <4>, marks: "->"),
//   edge(<4>, "->", <3>),
//   edge(<3>, "->", <2>),
//   edge(<2>, "->", <1>),

//   edge(<1>, "r,u,l", marks: "->", label: "return 1"),
//   edge(<2>, "r,u,l", marks: "->", label: "return 2"),
//   edge(<3>, "r,u,l", marks: "->", label: "return 6"),
//   edge(<4>, "r,u", marks: "->", label: "return 24", left),
// )

Tail call recursion is when the last thing the function does is call itself with no extra operation after. In languages with tail-call optimization, the memory used by that iteration can be freed.

Recursion can flow many ways but the two main ways are:
- Linear where one call makes one recursive call, forming a #link("Linked List", "./linked_list.typ")-like structure
- Binary where one call makes two recursive calls, forming a #link("Binary Tree", "./trees.typ")-like structure

= Time Complexity
== Iteratively
One way to do this is iteratively: continually substitute the recurrence relation back into itself until you can spot a pattern, e.g.

#align(center, $T(1)=a$)
#align(center, $T(n)=T(n-1)+b$)
#align(center, $T(n)=T(n-2)+2b$)
#align(center, $T(n)=T(n-3)+3b$)

In general

#align(center, $T(n)=T(n-k)+k b$)

Then use the base case will happen when $n-k=1$, $k=n-1$

#align(center, $T(n)=T(1) + (n-1)b$)
#align(center, $T(n)=a + (n-1)b$)
#align(center, $therefore O(n)$)

#flashcard("What is the iterative method for solving recursive time complexity", "Substitute formula back in until a pattern is visible")

== Tree Method
Draw the recursion tree with the running times, calculate total running time at each level and sum all the levels

#flashcard("What is the tree method for recursive time complexity", "Draw tree and annotate running time, calculate total complexity at each level then sum")

== Master Theorem

Direct way to get running time of recurrence relation with form
#align(center, $
T(n) = a T(n/b) + f(n) {a>1, b>1}
$)

#align(center, $
  T(n) = cases(
    Theta(n^(log_b(a))) "if" f(n) = O(n^(log_b(a)-epsilon)) "for some" epsilon > 0,
    Theta(n^(log_b(a)) log n) "if" f(n) = O(n^(log_b(a)-epsilon)),
    Theta(n^(log_b(a))) "if" f(n) = O(n^(log_b(a)+epsilon)) "for some" epsilon < 0,
  )
$)

This is given on formula sheet so no big deal