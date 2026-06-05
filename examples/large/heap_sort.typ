#import "vault.typ":*
#show: setup
#tag("ads")

= Heap Sort
Construct a heap with the max at the top, take the top and put it at the end, then only consider the heap before that to be valid. Repair the heap and repeat until the heap is empty.

#link("./time_complexity.typ", "Time Complexity"): $Theta(n log n)$. It takes $O(n)$ to initially build the heap and $O(log n)$ for each of the $n$ removals, so overall it is $O(n log n)$.

```python
import math

def left(i):
  return (2*i)+1

def right(i):
  return (2*i)+2

# assumes the heap under the nodes is correct
def heap_node(heap, node, n):
    swap = max(left(node), right(node), node, key=lambda x: heap[x] if x < n else 0)

    if swap != node:
      heap[node], heap[swap] = heap[swap], heap[node]
      heap_node(heap, swap, n)

def heap_tree(heap):
  for i in range(math.floor(len(heap) / 2) -1, -1, -1):    
    heap_node(heap, i, len(heap))
      
# heap is sorted as an array based binary tree
def heap_sort(heap):
    heap_tree(heap)
    
    for x in range(len(heap) - 1, 0, -1):
      heap[0], heap[x] = heap[x], heap[0]
      
      heap_node(heap, 0, x)
```

#flashcard("Describe heap sort", "Turn the list into a max heap and then keep taking the root")
#flashcard("What is the time complexity of heap sort", "$O(n log n)$")
// #flashcard("What kind of algorithm is heap sort", "Incremental")