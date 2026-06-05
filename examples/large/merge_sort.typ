#import "vault.typ":*
#show: setup
#tag("ads")

= Merge Sort
Splits up the elements into two sections until singles then merge back together

#link("./time_complexity.typ", "Time Complexity"): $Theta(n log n)$

The recursion forms a splitting tree and a combination tree which is $O(log n)$ with the merging being $O(n)$ therefore it is $O(n log n)$ overall

```python
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
  if len(A) < 2:
    return A
    
  mid = len(A) // 2

  return merge(merge_sort(A[:mid]), merge_sort(A[mid:]))  
```

#flashcard("What is merge sort", "Split the list until single elements, then merge sorted lists back together")
// #flashcard("What kind of algorithm is merge sort", "Divide and Conquer")
#flashcard("Which algorithm is this
```java

def xxxx(a, b):
  if not a:
    return b

  if not b:
    return a

  if a[0] <= b[0]:
    return [a[0]] + xxxx(a[1:], b)
  else:
    return [b[0]] + xxxx(a, b[1:])
  
def sort(A):
  if len(A) < 2:
    return A
    
  mid = len(A) // 2

  return xxxx(sort(A[:mid]), sort(A[mid:]))  
```
", "Merge Sort")
#flashcard("What is the time complexity of merge sort", "$O(n log n)$")