#import "vault.typ": *;
#show: setup
#tag("ads")

= Binary Search Tree
An ordered #note("./trees.typ") where the left nodes are less than the key and the right nodes are greater.

= Finding Operations

Search returns the node that has the key and has a time complexity of $O(h)$ where $h$ is the tree height.
```py
def search(n, t):
  if n is None:
    return None
  
  if n.k < t.k:
    return search(n.r, t)

  if n.k > t.k:
    return search(n.l, t)

  return n
```

#flashcard("Describe a BST search", "If x smaller than node check left child, if x larger check right child")

Minimum returns the smallest value in the tree - this will be the leftmost node, time complexity of $O(h)$ ```py
def min(n):
  if n.l is None:
    return n

  return min(n.l)
```

#flashcard("Describe BST min", "Left node until end")

Maximum returns the maximum value in the tree - this will be the rightmost node, time complexity of $O(h)$ ```py
def max(n):
  if n.r is None:
    return n

  return max(n.r)
```

#flashcard("Describe BST max", "Right node until end")

Successor returns the next largest value in the tree is $O(h)$ ```py
def successor(n):
  if n.r:
    return min(n.r)

  def nextInOrder(n, p):
    if p is None or p.l == n:
      return p

    return nextInOrder(p, p.p)

  return nextInOrder(n, n.p)
```

#flashcard("Describe BST successor", "If has a right child minimum of right child, otherwise first parent coming from the left")

Predecessor returns the next smaller value in the tree and is $O(h)$ ```py
def predecessor(n):
  if n.l:
    return max(n.l)

  def prevInOrder(n, p):
    if p is None or p.r == n:
      return p

    return prevInOrder(p, p.p)

  return prevInOrder(n, n.p)
```

#flashcard("Describe BST predecessor ", "If has a left child maximum of left child, otherwise first parent coming from the right")

== Tree Parameters
Size returns the number of items in the tree $O(n)$ ```py
def size(n):
  if n is None:
    return 0

  return 1 + size(n.l) + size(n.r)
```
This can be reduced by storing the count at the start of the tree and incrementing and decrementing with insertion and deletion

#flashcard("Describe BST size", "1 + size(left) + size(right)")

Height returns the height of the tree $O(n)$ ```py
def height(n):
  if n is None:
    return -1

  return 1 + max(height(n.l), height(n.r))
```

#flashcard("Describe BST height", "1 + max(height(left), height(right))")

== Modification of basic BST

Insertion inserts into the tree as a leaf node while maintaining BST properties ```py
def insert(n, k):
  if k < n.k:
    if n.l is None:
      n.l = Node(k, n, None, None)
    else:
      insert(n.l, k)
  elif k > n.k:
    if n.r is None:
      n.r = Node(k, n, None, None)
    else:
      insert(n.r, k)
```
runs in $O(h)$

#flashcard("Describe BST insertion", "Follow BST properties until leaf and insert")

Deletion uses a transplant, which removes node $u$ from the tree by replacing it with node $v$, and reparenting, which moves a left or right child to another node's left or right. ```py
def transplant(u, v, d):
  if u.p is None: # root
    T.root = v

  u.p[d] = v # skips out n

  if v is not None:
    v.p = u.p

def reparent(u, v, d):
  u[d] = v[d]
  u[d].p = v
```

#flashcard("Describe BST transplant", "Swaps a node $v$ into a tree by replacing the parents reference to the old node $u$")

Delete works by transplanting the left or right child if there is only one child. Otherwise, the successor is found, removed from its old position, and moved into the deleted node's position. The deleted node's left and right children are then attached to the successor.
```py
def delete(k):
  n = search(root, k)

  if n is None:
    return

  d = "l" if n.p.l.k == k else "r"

  if n.r == None:
    transplant(n, n.l, d)
  elif n.l == None:
    transplant(n, n.r, d)
  else:
    s = min(n.r)

    if s.p != n:
      transplant(s, s.r, "r")
      reparent(n, s, "r")

    transplant(n, s, "l")
    reparent(n, s, "l")
```

#flashcard("Describe BST delete for no children", "Just delete - no side effects")

#flashcard("Describe BST delete for one child", "Just transplant with child")

#flashcard("Describe BST delete with two children", "Replace with in Order successor (minimum of right subtree), transplanting nodes as necessary to ensure no disconnections")

The problem with this is that the tree can become unbalanced, meaning the height will become closer to $n$, slowing down operations on the tree. This requires a self-balancing tree such as an #note("./avl_tree.typ") or #note("./red_black_tree.typ").

== Rotations
These algorithms bring up nodes while still maintaining the BST properties.

Left rotate brings the node on the right upward while the original node goes downward to the left. Right rotate does the symmetric operation. They are both constant time operations.
```py
def move(child, *slot, parent):
  *slot = child

  if child is not None:
    child.p = parent

def left_rotate(a):
  b = a.r
  if b is None:
    return a

  move(b.l, *a.r, a)
  move(a,   *b.l, b)

  return b


def right_rotate(a):
  b = a.l
  if b is None:
    return a

  move(b.r, *a.l, a)
  move(a,   *b.r, b)

  return b
```

#flashcard("Describe left rotate", "Bring right child up, putting its left subtree on the old node's right")
#flashcard("Describe right rotate", "Bring left child up, putting its right subtree on the old node's left")
