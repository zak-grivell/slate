#import "vault.typ":*
#show: setup
#tag("ads")

= Selection Sort
Finds the min element over and over until the list is sorted

#link("./time_complexity.typ", "Time Complexity"): $Theta(n^2)$

```python
def selection_sort(array, i=0):
  if i >= len(array):
    return

  min_index = min(range(i, len(array)), key=lambda j: array[j])

  array[i], array[min_index] = array[min_index], array[i]
  
  selection_sort(array, i + 1)
```

#flashcard("Describe selection sort", "Repeatedly find the min of the list until sorted")

#flashcard("Which sorting algorithm is this
```python
def sort(array, i=0):
  if i >= len(array):
    return

  min_index = min(range(i, len(array)), key=lambda j: array[j])

  array[i], array[min_index] = array[min_index], array[i]
  
  sort(array, i + 1)
```
", "Selection Sort")
#flashcard("What is the time complexity of selection sort", "$O(n^2)$")
// #flashcard("What kind of algorithm is selection sort", "Incremental")