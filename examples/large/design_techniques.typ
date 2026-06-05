#import "vault.typ":*
#show: setup
#tag("ads")

= Design Techniques

== Incremental
Take each element one at a time, solve the problem for that element and the others already processed, and repeat.
- #link("./insertion_sort.typ", "Insertion Sort")
- #link("./selection_sort.typ", "Selection Sort")
- #link("./heap_sort.typ", "Heap Sort")

== Divide and Conquer
Split up the input and process in small batches then recombine
- #link("./merge_sort.typ", "Merge Sort")
- #link("./quick_sort.typ", "Quick Sort")

== Randomization
Use random values to improve average time
- #link("./quick_sort.typ", "Randomized Quicksort")
- #link("./hash_table.typ", "Universal Hashing")

== Distribution
Categorize elements to speed up operations
- #link("./hash_table.typ", "Hash Tables")
- #link("./counting_sort.typ", "Counting Sort")
- #link("./radix_sort.typ", "Radix Sort")

== Combination
Use multiple algorithms depending on the dataset
- #link("./tim_sort.typ", "Tim Sort")
- #link("./intro_sort.typ", "Intro Sort")

== Dynamic Programming
todo!()


#flashcard("What is an incremental algorithm", "Solve the problem one step at a time")
#flashcard("What is divide and conquer", "Split up and solve sub-problems then recombine")