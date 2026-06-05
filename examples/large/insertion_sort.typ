#import "vault.typ":*
#show: setup
#tag("ads")

= Insertion Sort
Iteratively sort one element at a time into a sorted section at the start of a list

#link("./time_complexity.typ", "Time Complexity"): $Theta(n^2)$

```python
def insertion_sort(array, sorted_to = 0):
  if sorted_to == len(array) - 1:
    return
    
  element = array[sorted_to+1]
  i = sorted_to
  while i >= 0 and array[i] > element:
    array[i+1] = array[i]
    i -= 1

  array[i + 1] = element

  insertion_sort(array, sorted_to + 1)
```

#flashcard("Describe insertion sort", "Iteratively sort one element at a time into a sorted section at the start of a list")
#flashcard("What algorithm is this
```python
def sort(array, sorted_to = 0):
  if sorted_to == len(array) - 1:
    return
    
  element = array[sorted_to+1]
  i = sorted_to
  while i >= 0 and array[i] > element:
    array[i+1] = array[i]
    i -= 1

  array[i + 1] = element

  sort(array, sorted_to + 1)
```", "Insertion Sort")
#flashcard("What is the time complexity of insertion sort", "$O(n^2)$")
// #flashcard("What kind of algorithm is insertion sort", "Incremental")