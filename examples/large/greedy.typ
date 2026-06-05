#import "vault.typ":*
#show: setup
#tag("ads")

= Greedy Algorithms 
An approach for problems where there is an optimal item to pick at each step. For example, if you want to take the five largest items of a sorted array, the first item will always be largest, so take that.

In general it often uses sorting to reduce problems to $n log n$ from $n^2$ or higher.

#flashcard("What is a greedy algorithm", "An algorithm with an always optimal item to pick at each step")
// #flashcard("What is faster greedy or dp", "greedy")