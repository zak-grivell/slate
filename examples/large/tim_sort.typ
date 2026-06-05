#import "vault.typ":*
#show: setup
#tag("ads")

= Tim Sort
Just because an algorithm's #note("./time_complexity.typ") is better does not mean it is better in the real world. Although merge sort has better asymptotic time complexity than insertion sort, it is slower for smaller data sizes. One way to improve performance is to combine algorithms to take advantage of their strengths. Tim Sort combines merge sort and insertion sort.

For the #note("./time_complexity.typ") it is still $O(n log n)$ as the small insertion sort portions are overshadowed by the main algorithm


```py
def merge(a, b):
  if not a:
    return b

  if not b:
    return a

  if a[0] <= b[0]:
    return [a[0]] + merge(a[1:], b)
  else:
    return [b[0]] + merge(a, b[1:])
  
def merge_sort(A):
  if len(A) < CONSTANT:
    return insertion_sort(A)
    
  mid = len(A) // 2

  return merge(merge_sort(A[:mid]), merge_sort(A[mid:]))
```

#flashcard("What is tim sort", "Combination of Insertion Sort and Merge Sort")
#flashcard("What is the time complexity of tim sort", "$O(n log n)$")