#import "vault.typ": *;
#show: setup
#tag("ads")

= Trees
Trees are a special type of graph where each node is directed downward starting from a root, with each node having some number of children. They have the same type of relationships that family trees follow, e.g. parent, grandparent and uncle.

#flashcard("What is a tree", "Directed graph data structure starting from a root going downwards")


== Binary Tree
The most common variation is a `Binary Tree` where each node has at most two children.

#flashcard("What is a binary tree", "A tree where each node has two children")


A tree is balanced if the variation in height is at most one.

#flashcard("What is a balanced tree", "A tree with variation in height less than or equal to one")

There are three ways to traverse a binary tree:
- in Order - left child, node value, right child ```py
def inOrder(node):
  return inOrder(node.l) + [node.key] + inOrder(node.r)
```
- pre Order - node value, left, right ```py
def preOrder(node):
  return [node.key] + preOrder(node.l) + preOrder(node.r)
```
- post Order - left, right, node ```py
def postOrder(node):
  return postOrder(node.l) + postOrder(node.r) + [node.key] 
```
#flashcard("What is in Order traversal", "Left, self, Right")
#flashcard("What is post Order traversal", "Left, Right, Self")
#flashcard("What is pre Order traversal", "Self, Left, Right")

In an unordered binary tree there are many methods of where to insert a new element
- Naive - always insert to left
  - This causes many problems as it is never balanced and turns essentially into a linked list meaning the height is $O(n)$
- Random - on average should produce a height of $O(log n)$ and should be roughly balanced
- Queue based - add nodes to queue when inserted and remove when have both children
  - is balanced so height is $O(log n)$
Limitation is that they are unordered meaning search takes $O(n)$ but ordered variants do exist like the #note("./binary_search_tree.typ") which reduce to the tree height instead.

#flashcard("What is naive insertion into a binary tree", "Always left or right")

#flashcard("What is random insertion into a binary tree", "Randomly left or right until null node")

#flashcard("What is queue insertion into a binary tree", "Store a queue of nodes without both children and remove it when both children filled")

One way to represent a binary tree is with an array where the root is the first element, then both the root's children, then the root's children's children and so on. With zero-based indexing, the children of node $i$ are $2i + 1$ for the left child and $2i + 2$ for the right child, and the parent is $floor(frac(i - 1, 2))$.
