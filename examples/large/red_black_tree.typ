#import "vault.typ": *;
#show: setup
#tag("ads")

= Red Black Trees

== Properties
- Each node is red or black
- Root node is black
- The children of the red nodes are black
- Leaf nodes are black
- There should be the same number of black nodes from every leaf to the root

#flashcard("What color is the root of a red black tree", "black")

#flashcard("What are the two color properties in a red black tree", "red, black")

#flashcard("What color are the leaf null nodes", "black")

#flashcard("What property being true makes a red black tree balanced", "Same number of black nodes from each leaf to the root")

== Insertion
Always insert as red

- if inserting to root simply recolor and return

- if not empty insert using #note("./binary_search_tree.typ") properties if parent is black all good!

- otherwise, check the uncle; if it is black rotate, else recolor and repeat until the tree is valid

#flashcard("What color are inserted nodes initially in a red black tree", "red")

#flashcard("After inserting using BST properties on a red black tree what parent color means no modification", "black")

#flashcard("What insertion condition on a red black tree causes a rotation", "Uncle is black")

#flashcard("What insertion condition on a red black tree causes a recolor row", "Uncle is red")
