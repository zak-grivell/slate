#import "vault.typ": *;
#show: setup
#tag("ads")

= BTree
B-trees are #note("./trees.typ") with more than two children and multiple keys in each node.

The tree as a whole has the properties:
- a root
- a minimum degree: controls the minimum number of keys and children a non-root node must have
- a maximum degree: the number at which a node splits
- all leaves have the same depth
A node is full when it has $2t-1$ keys. If another key must be inserted, the node splits.

#flashcard("What is the degree of a node in a btree", "Number of children")

Each node has the attributes
- n: the number of keys in a node
- key[t-1...2t-1]: the keys stored in ascending order
- leaf: whether the node is a leaf
- c[t...2t]: pointers to the children of the btree


#flashcard("What requirement does a btree put on the height", "Same height everywhere")

#flashcard("What is the minimum number of keys for a non root node in a btree", "$t-1$")

#flashcard("What is the maximum number of keys node", "$2t-1$")

#flashcard("When is a btree node full", "When it has $2t-1$ keys")

#flashcard("When does a node split in a btree", "When an insertion would exceed $2t-1$ keys")

== Search
Search works like a binary tree but rather than comparing to just one key, you find where in the node's sorted keys your key should go.

```python
def search(node, k):
  i = next((i for i,x in enumerate(node.keys) if x >= k), len(node.keys))

  if i < len(node.keys) and node.keys[i] == k:
    return node

  if node.leaf:
    return None

  return search(node.children[i], k)
```

#flashcard("describe the search procedure on a btree", "For each node, find where the key should be. If it is in the node return it, otherwise search the matching child")

== Insert
First, the leaf node the key should be inserted into is found, then the key is added to the node. If it overflows, extract the middle item into the parent. The values left of the middle stay in the original child and the values right of the middle move into a new child. Recursively check the parent for overflow.


```python
def insert(node, k):
  i = next((i for i,x in enumerate(node.keys) if x > k), len(node.keys))

  if node.leaf:
    node.keys.insert(i, k)
    handle_overflow(node)
    return

  insert(node.children[i], k)

def handle_overflow(node):
    if len(node.keys) <= 2*t - 1:
      return

    mid = len(node.keys) // 2
    middle = node.keys[mid]

    right = Node(node.keys[mid+1:])
    node.keys = node.keys[:mid]
      
    if node is root:
      node.parent = Node([])
    
    node.parent.insert(middle)
    node.parent.children.insert(mid + 1, right)

    handle_overflow(node.parent)
```

#flashcard("describe the insertion procedure on a btree", "Insert into the correct leaf, then if that node overflows recursively extract the middle element into the parent, keeping the left side in place and moving the right side into a new child")
