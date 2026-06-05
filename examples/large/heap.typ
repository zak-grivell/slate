#import "vault.typ": *;
#show: setup
#tag("ads")

= Heaps
Heaps are a form of #note("./trees.typ"), specifically a binary tree. There are two forms: maximum and minimum. They guarantee less order than a #note("./binary_search_tree.typ"): they only say that a node's children are larger than it in the minimum case and smaller in the maximum case.

#flashcard("What are the two types of heap", "Minimum, Maximum")
#flashcard("What does a minimum heap guarantee", "Each parent is smaller than their children")
#flashcard("What does a maximum heap guarantee", "Each parent is larger than their children")

== Operations
Insert as a leaf of the tree, then swap upward until the heap property is restored.

Replace the element to be deleted with the last element in the heap then `heapify` downwards to ensure valid properties

Heapify is simply taking an element comparing it to the children then swapping where necessary

#flashcard("How to insert into a heap", "Insert as leaf then swap until does not break properties")
#flashcard("How to remove from a heap", "Replace element with leaf then heapify downwards")
