#import "vault.typ":*
#show: setup

#title("hello")

#tag("doccument")

#metadata("UR MOM") <target>

= Hello world

i am live adding stuff



This is a _test_ *doccument* 


#note("./note.typ")

#emph("hello") 
#strong("strong")

#quote([Hello there])

#math.equation($x$)


$x=x^2$

```py
def is_present(A, k):
    m = len(A) // 2

    if A[m] < k:
        return is_present(A[:m], k)
    elif A[m] > k:
        return is_present(A[m:], k)
    else:
        return True
```

