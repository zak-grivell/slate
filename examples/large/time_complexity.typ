#import "vault.typ":*
#show: setup
#tag("ads")

= Time Complexity
Quantifying average-case time complexity is often difficult, and best-case is usually not very informative. Therefore, look at worst-case time complexity.

Asymptotic analysis is when you analyze an algorithm with numbers so big that the constants and the lower order terms are essentially negligible and can therefore be dropped e.g.

#align(center, $g(n) = 3n^2 + 2n + 1 = Theta (n^2)$)

#flashcard("What is asymptotic time complexity", "Analysis when numbers are so big that the constant and lower order terms become insignificant")

#flashcard("Asymptotic complexity of $g(n)=n^3 + n log n + n + 1$", "$O(n^3)$")

== Big $O$
Big $O$ notation gives an upper bound of the function $f(n)$, meaning asymptotically it will never grow faster than $O(g(n))$.

Formally where $f(n) = O(g(n))$ there are constants $c$ and $n_o$ such that $f(n) <= c g(n)$ for $n >= n_o$. In words, there is a constant that will cause $g(n)$ to be larger than $f(n)$ from $n_o$ onward.

#flashcard("What is big $O$ notation", "Upper bound of the complexity of the function")
#flashcard("What is the formal definition of $f(n) = O(g(n))$", "constants exist $c$, $n_o$, such that after $n_o$ $f(n) <= c g(n)$")

== Big $Omega$
Big $Omega$ gives a lower bound of the function $f(n)$, meaning asymptotically it will never grow slower than $Omega(g(n))$.

Formally where $f(n) = Omega(g(n))$ there are constants $c$ and $n_o$ such that $f(n) >= c g(n)$ for $n >= n_o$. In words, there is a constant that will cause $g(n)$ to be smaller than $f(n)$ from $n_o$ onwards.

#flashcard("What is big $Omega$ notation", "Lower bound of the complexity of the function")
#flashcard("What is the formal definition $f(n) = Omega(g(n))$", "constants exist $c$, $n_o$ such that after $n_o$ $f(n) >= c g(n)$")

== Big $Theta$
Big $Theta$ occurs when $f(n)=O(g(n))$ and $f(n)=Omega(g(n))$. This means there is a tight bound on the function. A tight bound $Theta$ will always exist but may be difficult to find, therefore it may be left as a range between $Omega$ and $O$.

#flashcard("What is big $Theta$ notation", "The full bound of the function when $O(g(n))$ and $Omega(g(n))$ are known precisely therefore equal")