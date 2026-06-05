#import "vault.typ":*
#show: setup
#tag("ads")

= Hash table
Implementation of the Map #note("./abstract_data_types.typ")

// #flashcard("What is the map ADT", "KV pair data structure")

The ideas from #note("./counting_sort.typ") can be used to create fast data structures. There is $O(1)$ lookup time because you can just check the "index" of the item, $O(1)$ insert because you add to an array position, and $O(1)$ delete as well. This is essentially a hash table where values are stored at locations derived from their keys.

#flashcard("How does the hash table store data", "An array with a hashing function which dictates the position the value goes into")

== Hash Function
But what if the key is not an integer, such as a string? Or what if you want to compress the hash table? Use a hashing function to turn a data type into an int.

=== Integer Cast
Some data types like `char` can just be cast to int without losing data, so use that.

#flashcard("What is an integer cast hash function", "Simply cast to int like with char")
#flashcard("Problems with integer cast hash function", "Can only handle small value sets")

=== Component Sum
Let's say the hash table is 16 bit but you want to hash a 64 bit int - split it into 16 bit sections and add them while ignoring overflow. This could also work with small char arrays.

#flashcard("What is a component sum hashing function", "Split up data hash it then add with overflow")

=== Polynomial Accumulation
$h a s h = a_o + a_1 x + a_2 x^2$ where $a$ is the data and $x$ is a prime number.

To do this efficiently use Horner's rule.
$h(n+1) = x(a_n + h(n))$

#flashcard("What is a polynomial accumulation hashing function", "Take each component of the data and add it to a polynomial")
#flashcard("What is Horner's rule", "Most efficient way to do polynomial accumulation: $h(n+1) = x(a_n + h(n))$")

=== Truncation
Take the first or last few digits and use them.

#flashcard("What is a truncation hash function", "Only use the first or last few digits")

=== Division
Take the remainder of a number modulo a prime.

#flashcard("What is a division hash function", "Takes the remainder of a number")

=== Multiplication
Multiply by a value between $0$ and $1$, extract the fractional part, multiply that by an int and floor.

#flashcard("How does a multiplication hash function work", "Multiply it by a fraction and floor")

=== Universal Hashing
To prevent intentional hash collisions, pick a random hash function from a set of mappers following the form $h(k) = ((a k + b) mod p) mod m$ where $p$ is large enough to cover all inputs.

#flashcard("What is universal hashing", "A set of hashing functions where one is randomly picked")

#flashcard("What makes a set of hashing functions universal", "For any two keys, the fraction of hash functions where they collide is at most 1 over the number of slots")

#flashcard("What is the form of a universal hasing function", "$h_(a b)(k) = ((a k + b) mod p) mod m$")

== Collision Resolutions
As seen in the previous section, multiple values can hash to the same location. There are multiple strategies for resolving this.

#flashcard("What is a hash table collision", "When multiple values hash to the same value")

=== Chaining
Each slot stores a linked list of values that have hashed to that slot.

#flashcard("What is chaining in a hash table", "Collision resolution strategy of using an LL at each hash table location")
#flashcard("Describe the linked list for a hash table chaining", "Doubly linked list with most recent value at head")

=== Open Addressing
Try to insert at one location; if it is full, try another. This means that search logic is more complex.

#flashcard("What is open addressing", "Have multiple locations that a value can hash to, so if a collision is found use another one")

Linear - $h(k,i) = (h'(k) + i) mod m$ where $h'$ is the real hash function. This increments by a fixed amount, which can create full blocks and make search slow.

#flashcard("What is linear open addressing", "Add an offset and mod to find the next location")

Quadratic - $h(k,i) = (h'(k) + c_1i + c_2i^2) mod m$. Jump around at a quadratic level to reduce full blocks.

#flashcard("What is quadratic open addressing", "Rather than constant offset use quadratic to stop long full chains")

Double Hashing - $h(k,i) = (h_1(k) + i h_2(k)) mod m$. If full, add a multiple of your hashed value with a different hashing function.

#flashcard("What is double hashing open addressing", "Use another hash function to do the offset in open addressing")

=== Perfect Hashing
When there is a small fixed set of keys, pre-hash them into the table with hash tables at each key, and choose another hashing function $h_2$ that will never give collisions for values that land in the same $h_1$ group. These are generally used with universal hashing.

#flashcard("What is perfect hashing", "Have multilevel hash-tables in which the hashing function for the sub table will never have collisions within the group")