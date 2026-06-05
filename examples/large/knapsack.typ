#import "vault.typ":*
#show: setup
#tag("ads")

= Knapsack Problem
Given a list of weights $w$ and values $v$, maximize the value while staying under weight limit $W$.

Brute forcing would be $O(2^n)$, which is very inefficient.

== #note("./dp.typ")
Can use dynamic programming to find the optimal solution.

Have a table of the max value you can get for each capacity $u$. Incrementally go over each `(weight, value)` pair and update the value as the max of the current value and that item's value plus the best value for the remaining capacity. *Note this has to be done in reverse to avoid counting the same item more than once*. Then the max of this array is the answer.

```python
def knapsack(W, V, m):
    U = [0] * (m+1)

    for w, v in zip(W, V):
        for u, cv in reversed(list(enumerate(U))[w:]):
            U[u] = max(cv, v + U[u-w])

    print(U)
        
    return max(U)
```

#flashcard(
"Describe the knapsack problem using dp",
"Have an optimal value with $u$ weight left then for each `(w, v)` pair in reverse the maxima is `v + U[i - w]` then max $U$"
)

== #note("./greedy.typ")
If the knapsack problem is fractional, e.g. you can take some of an item, there is a greedy solution: sort by the ratio of value to weight. This finds the most valuable item per unit of weight. Then take from the start of the list until you cannot take another full item and take the fraction of that last item.

```python
def fractional_knapsack(W, V, m):
  p = sorted(zip(W, V), key=lambda item: item[1] / item[0], reverse=True)

  u = m
  s = 0
  i = 0

  while u - p[i][0] >= 0:
    u -= p[i][0]
    s += p[i][1]
    
    i += 1

  s += (u / p[i][0]) * p[i][1]
```

#flashcard("Describe greedy on fractional knapsack", "The optimal item to take is one with highest value to weight ratio so sort by that and take as many as can")