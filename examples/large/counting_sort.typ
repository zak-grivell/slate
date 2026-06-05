#import "vault.typ":*
#show: setup
#tag("ads")

= Counting Sort
For small integers, count the number of occurrences and then reconstruct the array.

#link("./time_complexity.typ", "Time Complexity"): $Theta(n + k)$ where $k$ is the size of the value range. Counting the occurrences and reconstructing the array are linear in the input size plus the range.

Not very space efficient - becomes unusable above like 8 bits

```python
def counting_sort(arr):
  occurrences = [0]*256

  for x in arr:
    occurrences[x] += 1

  i = 0
  for j, n in enumerate(occurrences):
    for _ in range(n):
      arr[i] = j
      i += 1
```

#flashcard("Describe counting sort", "Count the number of occurrences then turn back into list")

#flashcard("What is the time complexity of counting sort", "$O(n + k)$")

Has a more advanced version where you count occurrences, compute the position each element should end at then go backward over the list inserting them

#flashcard("What is advanced counting sort", "Where ending positions of each group are calculated by a cumulative sum, and go backwards over the array inserting them and decrementing position")

// #flashcard("What kind of algorithm is counting sort", "Distribution")

// #flashcard("What is the problem with counting sort", "Big numbers create very large arrays"