#import "vault.typ":*
#show: setup
#tag("embedded")

= Integer Representation
Numbers in computers are stored in base 2, in bytes


For positive integers the range that can be stored is $0 arrow 2^n - 1)$
// #flashcard("What is the range formula for integers", "$0 arrow 2^n - 1 $")

== Twos Complement
To store negative values a wrap around system is used it counts normally from $0 arrow 2^(n-1) - 1$ then it will count up from $-2^(n-1) arrow -1$ due to this wrap around addition with a negative number causes subtraction

#flashcard("What are the ranges in two's complement", "0 -> 2^(n-1) -1, -2^(n-1) -> -1")

To convert between them you take the binary value of the positive integer, flip the bits then add one

// #flashcard("How to convert a negative decimal to binary two's compliment", "Get positive value, flip bits, add one")

== Endian
In memory which byte goes first, most significant, or least? The bytes are in order internally but you can ether use big endian - most significant byte first or little endian - least significant byte first.

#flashcard("What is endian-ness", "The order bytes are stored in memory")
#flashcard("Difference between little endian and big endian", "Little - least significant bit first, Big - most significant byte first")