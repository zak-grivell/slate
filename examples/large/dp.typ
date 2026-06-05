#import "vault.typ": *;
#show: setup
#tag("ads")

= DP
A way of dividing input by splitting it into sub-problems and memoizing or tabulating those sub-problems to form a whole solution.

Focuses on using *overlapping sub-problems* and *optimal substructure*.

== Top down
Uses memoization and caches the results of reused function calls to speed up repeated work. ```python
cache = {}
def fib(n):
  if n <= 1:
    return 1

  if n not in cache:
    cache[n] = fib(n-1) + fib(n-2)

  return cache[n]
```
So it starts at the top but remembers sub-problems.

#flashcard("What is top down memoization", "When structure is a tree memoize function arguments to remove subtrees")


== Bottom Up
Uses tabulation to start with the small sub-problems and work up.
```python
def fib(n):
  table = [0] * (n + 1)
  table[0] = 1
  table[1] = 1

  for i in range(2, n+1):
    table[i] = table[i-1] + table[i-2]

  return table[n]
```

#flashcard("What is bottom up tabulation", "Start by solving the smallest problems then work upwards")
