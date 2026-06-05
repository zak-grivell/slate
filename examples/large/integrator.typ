#import "vault.typ":*
#show: setup
#tag("analouge")

= Integrator
#circuit({
  import zap:*

  set-style(stroke: white)
  set-style(fill: none)

  opamp("o2", (0, 0), variant: "ieee", sign-stroke: white)
  capacitor("r1", (1.5, 2), (rel: (-3, 0)))
  resistor("r2", "o2.minus", (rel: (-3, 0)), position: 70%)    

  
  swire("o2.out", "r1.in", ratio: 100%)
  zwire("r1.out", "o2.minus", ratio: 0%)

  
  earth("s5", (-1.5,-1))
  swire("o2.plus", "s5")

  wstub("r2.out", label: $V_(i n)$)
  estub("o2.out", label: $V_(o u t)$)
})

#align(center, $V_o = - frac(1, R C) integral_0^t V_i d t$)

#flashcard("What op amp has the eq $V_o = - frac(1, R C) integral_0^t V_i d t$", "Integrator")
#flashcard("What does an integrator look like", "
#circuit({
import zap: *

opamp(\"o2\", (0, 0), variant: \"ieee\", sign-stroke: white)
capacitor(\"r1\", (1.5, 2), (rel: (-3, 0)))
resistor(\"r2\", \"o2.minus\", (rel: (-3, 0)), position: 70%)    


swire(\"o2.out\", \"r1.in\", ratio: 100%)
zwire(\"r1.out\", \"o2.minus\", ratio: 0%)


earth(\"s5\", (-1.5,-1))
swire(\"o2.plus\", \"s5\")

wstub(\"r2.out\", label: $V_(i n)$)
estub(\"o2.out\", label: $V_(o u t)$)
})
")