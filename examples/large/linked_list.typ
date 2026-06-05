#import "vault.typ":*
#show: setup
#tag("ads")

= Linked Lists
A data structure where each node has a key (value) and a `next` link to the next item in a list.

== Variations

Head pointer
- so the first pointer can be switched out easier
- have a pointer to a box storing the head not the actual location of the first node

Doubly linked list
- if you want to traverse backward
- have a previous and a next pointer on each node

Circular linked list with a sentinel
- Head and tail operations can be annoying
- have a null node between head and tail and point head to the null node
- means you do not have to special-case the head


== Operations
All done on circular doubly linked list with a sentinel

```py
def insert_after(node, new):
  node.next.prev = new
  node.next = new

def delete(node):
  node.prev.next = node.next
  node.next.prev = node.prev

def search(node, value):
  if not node:
    return None

  if node.key == value:
    return node

  return search(node.next)

```

#flashcard("What is a linked list", "List where each node has a value and a next node")

#flashcard("What is a doubly linked list", "List where each node has a value and a next node and a prev node")

#flashcard("What is a head node", "A dummy node used so can remove from head without changing the head pointer")

#flashcard("What is a circularly linked list with a sentinel", "A dummy null node which the head points to and which goes between the first and last elements to reduce complexity of operations")