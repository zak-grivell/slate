#import "vault.typ":*
#show: setup
#tag("embedded")

= Arithmetic and Logic Unit

== Logical Function
Most basic operations `bitwise` logic is very useful and is made by simply chaining logic gates between inputs `A` and `B` these can be `and`, `or`, `xor` or any operation deemed useful


== Adding
Numbers are added in a computer in base two. Each sum starts with a carry of zero then simply adds bitwise up the chain like in base 10.
  
#context table(
  columns: 5,
  stroke: text.fill,
  [#strong[$A_n$]], [#strong[$B_n$]], [#strong[$C$]], [#strong[$S$]], [#strong[$C_"out"$]],
  [0], [0], [0], [0], [0],
  [0], [0], [1], [1], [0],
  [0], [1], [0], [1], [0],
  [0], [1], [1], [0], [1],
  [1], [0], [0], [1], [0],
  [1], [0], [1], [0], [1],
  [1], [1], [0], [0], [1],
  [1], [1], [1], [1], [1],
)

$n$ of these chained together gives $n$ bit number addition.

For subtraction use the #note("./integer_repersentation.typ") of two's compliment, simply convert the number to negative then add. But how to get this representation? Flip the bits and add one. So if put a not gate in front of the `B` inputs and set the initial carry to one. Subtraction with little overhead.

We don't want an additional adding unit simply with negation in front what if use the same one - have a control signal connected to the carry. ~ero = add, one = subtract then add XOR to all the inputs and there free selection between both.

But what if we want more features? Separate out the carry line to $K$, the xor can be $L$ and add and `and` gate before the `xor`

#context table(
  columns: (1fr, 1fr, 1fr, 3fr, 2fr),
  stroke: (paint: text.fill, thickness: 0.6pt),

  [#strong[K]], [#strong[L]], [#strong[M]], [#strong[S]], [#strong[Useful]],

  [0], [0], [0], [A], [],
  [0], [0], [1], [A plus B], [Yes],
  [0], [1], [0], [A minus 1], [Yes],
  [0], [1], [1], [A minus B minus 1], [],
  [1], [0], [0], [A plus 1], [Yes],
  [1], [0], [1], [A plus B plus 1], [],
  [1], [1], [0], [A], [],
  [1], [1], [1], [A minus B], [Yes],
)

Now some of these operations are useless but some are very useful could simply have a table to reduce the number of control bits and only select the useful ones.

Why is only `B` being modified why not `A`, exactly both can be combined to form loads of useful combinations - not shown as very long table but simply a Cartesian product of the table above

== Circuit around ALU
The ALU has two #note("./registers.typ") at its input for both $A$ & $B$ as well as for the operation bits $H$ this is so the data line doesnt have to constantly send both bits while the ALU is working they just send once and it is stored at the base of the ALU

#flashcard("What is the accumulator register", "Regiser on input A of the ALU that can be written to during an instruction like multiplication to keep values")
#flashcard("Why is there registers at the base of the ALU", "Remeber the current values ALU is working on")
#flashcard("What is the temp resiter", "Register at input B of ALU to rememeber the B value")
#flashcard("What is the H register", "Stores the operation on the ALU as well as output memory address")

But what if we want to do more complex operations like multiplication? Have the output of the ALU also write to the $A$ register so that multiple shifting and adding operations can be combined to make multiplication

The $B$ resister is simply called the temp register and finally the $H$ resigster is the instruction register

The Von Neuman Scheme has the ALU output the adress it is writing to in memory so it's final action after each operation will be to write to memoery by sending the adress and putting the data onto the data bus

This gives the diagram

#flashcard("Describe the basic ALU, memory circuit", "#image(\"assets/Screenshot 2026-05-10 at 16.01.03.png\")")

