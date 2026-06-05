#import "vault.typ":*
#show: setup
#tag("ads")

= Shell Sort
Optimization of #note("./insertion_sort.typ"). It has a `gap` property, initially `len(A) // 2`, and performs insertion sort on elements that are `gap` positions apart. It then halves the gap again; this repeats until the gap is one.

This means the array is already partially sorted, which is useful for insertion sort because it reduces long swap sequences.

#link("./time_complexity.typ", "Time Complexity"): $Theta(n^2)$

```python
def shell_sort(A, gap=len(A)//2):
  if gap == 1:
    return insertion_sort(A)
  
  for x in range(0, len(A), gap+1):
    if A[x + gap] < A[gap]:
      A[x+gap], A[x] = A[x], A[x+gap]

  return shell_sort(A, gap//2)
```

#flashcard("What is the gap in shell sort", "the interval that items are compared and swapped")

#flashcard("What gap does shell sort stop at", "1")

#flashcard("What does shell sort do when the gap is 1", "Use insertion sort")

#flashcard("Why is shell sort faster", "Reduces long swap sequences in insertion sort")

#flashcard("At what rate does the gap in shell sort decrease", "division by two")