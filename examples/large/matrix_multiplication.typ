#import "vault.typ":*
#show: setup
#tag("ads")

= Matrix Multiplication

== Simple
How you would do it on paper
```python
def mat_mult_square(A, B):
  n = len(A)
  C = [[0] * n for _ in range(n)]
  
  for x in range(n):
    for y in range(n):
      C[x][y] = sum(A[x][o] * B[o][y] for o in range(n))

  return C
```

This is $O(n^3)$ not very speedy

#flashcard("What is simple matrix multiplication", "Way do it on paper - column wise ")

== Divide and Conquer
Split into submatrix until trivial 2x2 then build back up

#flashcard("What is the divide and conquer matrix multiplication algorithm", "Split into 2x2 sub matrices and then recombine")

== Strassen Algorithm
Lots of intermediate values are calculated again and again, so Strassen's algorithm can prune recursion by defining 10 $n/2$ sum matrices and 7 $n/2$ product matrices, which combine into the 4 submatrices of the result.

#flashcard("What is the idea behind Strassen Matrix Multiplication", "Intermediary values can be reused so calculate a bunch of n/2 sub matrices and combine")

#flashcard("What are the three steps for Strassen matrix multiplication", "Sum 10, product 7, sum 4 which gives sub matrices of result")

#flashcard("Time Complexity of traditional matrix multiplication", "$O(n^3)$")

#flashcard("Time Complexity of Strassen matrix multiplication", "$O(n^2.807)$")