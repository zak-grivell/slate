#import "vault.typ":*
#show: setup
#tag("ads")

= Abstract Data Types
A way to define the set of operations you can do without knowing the internals of a data structure.

== Stack
Stores arbitrary elements; add to the top and remove from the top.
- Primary: push, pop
- Secondary: peek, size, empty

Can be implemented via:
- array can just add and remove from end and panic if overflow
- vector can add or remove from end and extend if overflow
- linked list can add and remove from the head in constant time

// #flashcard("What is a stack", "An ADT that you can add to the top and remove from the top")
// #flashcard("Describe primary stack Operations", "
- Push: add to top
- Pop: remove from top
")
// #flashcard("Describe the secondary Stack Operations", "
- Peek: get top element without removing it,
- Size: number of elements in stack
- Empty: does the stack have any elements
")
// #flashcard("How can an array be used for a stack", "Add and remove from end and panic if overflow")
// #flashcard("How can a vector be used for a stack", "Add and remove from end and extend if overflow")
// #flashcard("How can a linked list be used for a stack", "Add and remove from head")

== Queue
Stores arbitrary elements; add to the back and remove from the front.
- Primary: push, pop
- Secondary: peek, size, empty
Can be implemented via:
- array: Start and end pointer which wrap around
- vector: Start and end pointer wrapping around and extending if required
- linked list: Add at the tail and remove from the head

// #flashcard("What is a queue", "An ADT where you add to the back and remove from the front")
// #flashcard("Describe primary queue Operations", "
- Push: add to back
- Pop: remove from front
")
// #flashcard("Describe the secondary Queue Operations", "
- Peek: get front element without removing it,
- Size: number of elements in queue
- Empty: does the queue have any elements
")

// #flashcard("How can an array be used for a queue", "Start and end pointer which wrap around")
// #flashcard("How can a vector be used for a queue", "Start and end pointer wrapping around and extending if required")
// #flashcard("How can a linked list be used for a queue", "With head and tail pointers")


== Double Ended Queue
Stores arbitrary elements; add to both sides and remove from both sides.
- Primary: push_front, push_back, pop_front, pop_back
Can be implemented via an array, vector or linked list

// #flashcard("What is a deque", "An ADT that you can add and remove from both sides")
// #flashcard("Describe primary deque Operations", "push_front, push_back, pop_front, pop_back")

// #flashcard("How can an array be used for a double ended queue", "Start and end pointer which wrap around")
// #flashcard("How can a vector be used for a double ended queue", "Start and end pointer wrapping around and extending if required")
// #flashcard("How can a linked list be used for a double ended queue", "With head and tail pointers")

== List
An arbitrary sequence of elements
- Primary: get, set, add, remove

// #flashcard("What is a list", "An ADT that can add and remove elements as well as get and set arbitrary indexes")
// #flashcard("Describe primary list Operations", "get, set, add, remove")