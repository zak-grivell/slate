#import "vault.typ":*
#show: setup
#tag("embedded")

= Floating point
- Numbers are not always integers
- Gives a stable way to represent very small and very big numbers
- Reproducible on different computers
- Represents a number using scientific notation


Three Components
  - Sign (Positive or negative)
  - Exponent
  - Fraction / Mantissa
Where #align(center, $f = (-1)^(s i g n) dot (1+F) dot 10^(e x p o n e n t - 127)$) as this is in binary $10_2$ = $2_10$

== Subnormal Numbers
#flashcard("What fp number repersents 0", "Sign = any as both +0 and -0, but exponent=0, fraction=0")
#flashcard("What fp number repersents infinity", "Sign = any as both + and -, but exponent=all ones, fraction=0")
#flashcard("What fp number repersents Nan", "Sign = any, but exponent=all ones, fraction=anything but 0")

#flashcard("What is a subnormal number", "Very small number which has 0 as exponent and a mantissa not zero")
#flashcard("When is a number subnormal", "Exponent 0, mantissa not zero")
#flashcard("What is the value of the exponent for a subnormal number", "-126")
#flashcard("What is the exception to the leading 1 rule", "Subnormal numbers")

#flashcard("What is the floating point equasion", "$(-1)^(s i g n) dot (1+F) dot 10^(e x p o n e n t - 127)$")

// #flashcard("What are the three components of floating point", "Sign, Exponent, Marissa")

// #flashcard("What does the sign represent in floating point", "Whether number is positive or negative")

// #flashcard("What does the exponent represent in floating point", "The power on the 10")

// #flashcard("What does the mantissa represent in floating point", "The fraction part of the number ")

But how is this stored in memory?

#flashcard("What order do the components of floating point come in", "Sign, Exponent, Mantissa")

Sign:
  - 0 = positive
  - 1 = negative

// #flashcard("What is the memory representation of the sign in floating point", "0 = positive; 1 = negative")

Exponent:
- unsigned integer bias by $-(2^(n-1) + 1)$
- both 0 and $2^n - 1$ are reserved
- range is $1 paren.l -2^(n-1) + 2 paren.r arrow 2^(n-1) - 1$

#flashcard("How does the exponent in floating point represent negatives", "Biasing by $-(2^(n-1) - 1)$")
#flashcard("What is the range of a u8 floating point exponent", "-126 -> 127")
#flashcard("What numbers are reserved for special numbers in floating point exponent", "$0 and 2^(n-1)$")

Mantissa:
The fractional part of the number. Due to the nature of binary the leading digit in scientific notation is always 1 therefore there is an assumed one at the beginning of each floating point number

#flashcard("What digit is chopped off for the mantissa", "First one as always one")

So what do the invalid exponent states represent?

#context table(columns: (auto, auto, auto),
  stroke: (paint: text.fill, thickness: 0.6pt),
table.header(
    [*Mantissa*], [*Exponent*], [*Value*],
  ),
  $0$,
  $0$,
  $0$,
  $0$,
  $2^n - 1$,
  $inf$,
  $overline(0)$,
  $2^n - 1$,
  $N a N$,
)

Mantissa = $0$, Exponent = $0$, Value = $0$
Mantissa = $0$, Exponent = $2^n-1$, Value = $inf$
Mantissa = $overline(0)$, Exponent = $2^n-1$, Value = $N a N$


single:
- 1 bit sign:
- 8 bits exponent
  - biased u8 by -127, meaning 1 mean -126 and so on
  - both 0 and 255 are reseved so range is 1 (-226) -> 254 (127)
- 23 bits fraction

#flashcard("What is the component sizes in a single (f32)", "1 sign, 8 exponent, 23 fraction")

double:
- 1 bit sign:
- 11 bits exponent
- 52 bits fraction

#flashcard("What is the component sizes in a double (f64)", "1 sign, 11 exponent, 52 fraction")