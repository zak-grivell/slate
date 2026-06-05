#import "vault.typ": *;
#show: setup
#tag("ads")

= AVL Trees
An AVL tree uses a more restrictive balancing scheme than #note("./red_black_tree.typ"). They are slower for insertion and deletion but have faster lookup because they are more strictly balanced.


== Properties
- Each node stores the difference in height between the right and left subtree
- If $abs(x) > 1$ then perform rotations

#flashcard("What is an AVL tree", "Tree which stores the difference in height between the left and right tree and must not be over 1")

#flashcard("If an AVL balancing tree has a value of 1 what does that mean about the left and right subtrees", "Right has one more level than left")

#flashcard("What is the balance factor in an AVL Tree", "Difference between the height of left and right subtrees")

== Insertion
- Insert as normal #note("./binary_search_tree.typ")
- Retrace from insertion updating the balance factor and rotating if needed
  - If zero stop retracing
  - If +1 or -1 continue up
  - If +2 or -2 rotate and recompute
- Rotation conditions - in short if double opposite else the second
  - LL was inserted on the left subtree of the left child - right rotate
  - RR was inserted on the right subtree of the right child - left rotate
  - LR was inserted on the right subtree of the left child - left rotate the left child, then right rotate
  - RL was inserted on the left subtree of the right child - right rotate the right child, then left rotate
