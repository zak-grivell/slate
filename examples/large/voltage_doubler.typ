#import "vault.typ":*
#show: setup
#tag("analouge")

= Voltage Doubler
It works on the principle that a capacitor with a diode before it will cause the capacitor to hold its charge for longer as it cannot discharge

#circuit({
  import zap:*

  acvsource("s1", (-2, 1), (rel: (0, -2)), sign-stroke: white)

  capacitor("c1", "s1.in", (rel: (2, 0)), label: $C_1$)
  diode("d1", (rel: (0, -1)), "c1.out", label: $D_1$)

  wire("d1.in", "s1.out")

  diode("d2", "c1.out", (rel: (2,0)), label: $D_2$)

  capacitor("c2", "d2.out", (rel: (0, -2)), label: $C_2$)
  wire("d1.in", "c2.out")
})

The first half actually does the doubling, on the bottom half of the wave $C_1$ will charge up to $V_(p e a k)$ then on the top half the charged capacitor combines with the positive half of the signal. This creates an offset wave where the voltage going into $D_2$ is the wave centered at $V_(p e a k)$ going from $0 arrow 2 V_(p e a k)$

The capacitance on $C_1$ should be large enough such that it does not discharge significantly before the next negative cycle of the input signal

The next stage charges $C_2$ in only one direction, this means rather than following the wave it will charge up to the peak of the offset signal being $2 V_(p e a k)$. Just like $C_1$ the capacitance of $C_2$ should be large enough it should not be able to dissipate too much in the time - this is effected by load resistance as it will affect the time constant as well.

#flashcard("What does a voltage doubler look like", "
#circuit({
  import zap:*
  acvsource(\"s1\", (-2, 1), (rel: (0, -2)), sign-stroke: white)

  capacitor(\"c1\", \"s1.in\", (rel: (2, 0)), label: $C_1$)
  diode(\"d1\", (rel: (0, -1)), \"c1.out\", label: $D_1$)

  wire(\"d1.in\", \"s1.out\")

  diode(\"d2\", \"c1.out\", (rel: (2,0)), label: $D_2$)

  capacitor(\"c2\", \"d2.out\", (rel: (0, -2)), label: $C_2$)
  wire(\"d1.in\", \"c2.out\")
})
")

#flashcard("Describe the first half of a voltage doubler", "
The first half actually does the doubling, on the bottom half of the wave $C_1$ will charge up to $V_(p e a k)$ then on the top half the charged capacitor combines with the positive half of the signal. This creates an offset wave where the voltage going into $D_2$ is the wave centered at $V_(p e a k)$ going from $0 arrow 2 V_(p e a k)$
")

#flashcard("How big should the capacitor in the first stage of a voltage doubler", "
The capacitance on $C_1$ should be large enough such that it does not discharge significantly before the next negative cycle of the input signal
")

#flashcard("Describe the second half of a voltage doubler", "
The next stage charges $C_2$ in only one direction, this means rather than following the wave it will charge up to the peak of the offset signal being $2 V_(p e a k)$. 
")

#flashcard("How big should the capacitor in the first stage of a voltage doubler", "
Just like $C_1$ the capacitance of $C_2$ should be large enough it should not be able to dissipate too much in the time - this is effected by load resistance as it will affect the time constant as well.
")