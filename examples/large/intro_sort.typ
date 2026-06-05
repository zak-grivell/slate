#import "vault.typ":*
#show: setup
#tag("ads")

= Intro Sort
A combination algorithm that starts with #note("./quick_sort.typ") and switches to #note("./heap_sort.typ") if recursion gets too deep, preventing quick sort's $O(n^2)$ worst case.

```py
def intro_sort(A):
  if recursion_depth > LIMIT:
    return heap_sort(A)

  k = get_partition()

  return quick_sort([x for x in A if x < k]) + [x for x in A if x == k] + quick_sort([x for x in A if x > k])
```

#flashcard("What is intro sort", "Combination of Quick Sort and Heap Sort that switches to Heap Sort if recursion gets too deep")
#flashcard("What is the time complexity of intro sort", "$O(n log n)$")