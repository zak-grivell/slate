#import "vault.typ":*
#show: setup
#tag("ads")

= Radix Sort
Sort integers by applying multiple bucket sorts to them, starting with the least significant digits first. This works because bucket sort is stable, so equal-ranked items keep the order created by earlier digit passes. This gets around some of the problems in #note("./counting_sort.typ")


#note("./time_complexity.typ"): $Theta(d(n + k))$, where $d$ is the number of digit passes and $k$ is the base or bucket count. For a fixed word size and fixed base, this is linear in $n$.

Note: Any stable sort can be used not just bucket sort

```python
# for 64 bit but can be for any
def radix_sort(arr):
  for s in range(0, 64, 8):
    buckets = [[] for x in range(256)]
    
    for a in A:
      buckets[(a >> s) & 0xFF].append(a)

    arr = [a for bucket in buckets for a in bucket]

  return arr
```

#flashcard("What does it mean for a sort to be stable", "Same ranked items stay in same order when sorted")

#flashcard("How does radix sort work", "Sort based on 'digits' least significant digit first")

#flashcard("What kind of sort does radix sort need", "Stable")