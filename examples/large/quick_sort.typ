#import "vault.typ":*
#show: setup
#tag("ads")

= Quick Sort
Using a partitioning scheme, chooses an element and puts all smaller items before it and larger items after it. This repeats until the list is sorted.

```python
def quick_sort(A):
  if len(A) <= 1:
    return A 

  k = get_partition()

  return quick_sort([x for x in A if x < k]) + [x for x in A if x == k] + quick_sort([x for x in A if x > k])
```

There are multiple partitioning schemes:
- First
- Last
- Random,
- Median of three

For all of them, the average #link("./time_complexity.typ", "Time Complexity") is $O(n log n)$, but the worst case with bad luck or a killer dataset will degrade to $O(n^2)$. To stop killer inputs, some systems use multiple schemes or choose a random pivot.

#flashcard("What is quick sort", "Repeatedly partition and split into less than, equal to, and greater than")

#flashcard("What is partitioning scheme", "A way to pick at what value quick sort chooses to split the list")

#flashcard("What are the common partitioning schemes", "First value, last value, random, median of three")

#flashcard("Describe the characteristics of quick sort time complexity", "Average $n log n$ but can degrade to $O(n^2)$")

#flashcard("What is a killer input for quick sort", "Values picked to degrade quick sort to $n^2$")

#flashcard("What sorting algorithm is this ```python
def sort(A):
  if len(A) <= 1:
    return A 

  k = get_partition()

  return sort([x for x in A if x < k]) + [x for x in A if x == k] + sort([x for x in A if x > k])
```", "Quick Sort")