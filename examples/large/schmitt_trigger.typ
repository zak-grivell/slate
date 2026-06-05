#import "vault.typ":*
#show: setup
#tag("analouge")

= Schmitt Trigger
Locks the voltage to one side or another until it passes a switching threshold in which it very quickly jumps to the other rail

#circuit({
  import zap:*

  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  opamp("o1", (0,0), variant: "ieee", fill:none, sign-stroke: white)

  wstub("o1.minus", label: $V_(i n)$)

  resistor("r1", (1.5, 0), (rel: (0, -2)), label:$R_1$)
  wire("r1.in", "o1.out")

  resistor("r2", "r1.out", (rel: (0, -2)), label:$R_2$)

  zwire("r1.out", "o1.plus", ratio: 130%)

  earth("end","r2.out")
})

Its input/output graph is shown bellow

#let xs = (0, 1, 2, 3, 4)

#canvas({
  import cetz.draw: *

  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  line((-1, 0), (1, 0))
  line((0, -1), (0, 1))
 
  for x in (-1, -0.5, 0.5, 1) {
    line((x, 3pt), (x, -3pt))
  }

  for y in (-1, -0.5, 0.5, 1) {
    line((3pt, y), (-3pt, y))
  }

  line((-1, 0.7),  (0.5, 0.7), stroke: red)
  content((), anchor: "west", padding: 0.1, $V_s$)

  line((1, -0.7), (-0.5, -0.7), stroke: red)
  content((), anchor: "east", padding: 0.1, $-V_s$)

  line((-0.5, -0.7),  (-0.5, 0.7), stroke: red, mark: (end: "stealth"))
  content((), anchor: "south", padding: 0.1, $- beta V_s$)
  
  line((0.5, 0.7),  (0.5, -0.7), stroke: red, mark: (end: "stealth"))
  content((), anchor: "north", padding: 0.1, $beta V_s$)
})

Where $beta = frac(R_2, R_1 + R_2)$

The transition points are there as $minus.plus V_s beta$ is the value at $V_+$ therefore to flip it $V_i$ must go over $plus.minus V_s beta$

#flashcard("Describe the function of a schmitt trigger", "A latch that will lock to $plus.minus V_s$ until a big enough voltage flips")
#flashcard("What is the quanity $beta$ in a schmitt trigger", "The fraction of V_s at the positive terminal and required to flip the output")
#flashcard("What does the circuit look like for a schmitt trigger", "#circuit({
  import zap:*

  opamp(\"o1\", (0,0), variant: \"ieee\", fill:none, sign-stroke: white)
  wstub(\"o1.minus\", label: $V_(i n)$)
  resistor(\"r1\", (1.5, 0), (rel: (0, -2)), label:$R_1$)
  wire(\"r1.in\", \"o1.out\")
  resistor(\"r2\", \"r1.out\", (rel: (0, -2)), label:$R_2$)
  zwire(\"r1.out\", \"o1.plus\", ratio: 130%)
  earth(\"end\",\"r2.out\")
})")

#flashcard("What does the $V_i$, $V_o$ look like on a schmitt trigger", "
#canvas({
  import cetz.draw: *
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  line((-1, 0), (1, 0))
  line((0, -1), (0, 1))
 
  for x in (-1, -0.5, 0.5, 1) {
    line((x, 3pt), (x, -3pt))
  }

  for y in (-1, -0.5, 0.5, 1) {
    line((3pt, y), (-3pt, y))
  }

  line((-1, 0.7),  (0.5, 0.7), stroke: red)
  content((), anchor: \"west\", padding: 0.1, $V_s$)

  line((1, -0.7), (-0.5, -0.7), stroke: red)
  content((), anchor: \"east\", padding: 0.1, $-V_s$)

  line((-0.5, -0.7),  (-0.5, 0.7), stroke: red, mark: (end: \"stealth\"))
  content((), anchor: \"south\", padding: 0.1, $- beta V_s$)
  
  line((0.5, 0.7),  (0.5, -0.7), stroke: red, mark: (end: \"stealth\"))
  content((), anchor: \"north\", padding: 0.1, $beta V_s$)
})
")