#import "vault.typ":*
#show: setup
#tag("analouge")

= Inverting Op Amp
#circuit({
  import zap:*

  opamp("o2", (0, 0), variant: "ieee", sign-stroke: white)
  resistor("r1", (1.5, 2), (rel: (-3, 0)))
  resistor("r2", "o2.minus", (rel: (-3, 0)), position: 70%)    

  
  swire("o2.out", "r1.in", ratio: 100%)
  zwire("r1.out", "o2.minus", ratio: 0%)

  
  earth("s5", (-1.5,-1))
  swire("o2.plus", "s5")

  wstub("r2.out", label: $V_(i n)$)
  estub("o2.out", label: $V_(o u t)$)
})
#align(center, $V_o = - frac(R_2, R_1) dot V_i $)

#flashcard("Which op amp configuration just amplifies", "Non inverting op amp")
#flashcard("What op amp is this?
#circuit({
  import zap:*

  opamp(\"o2\", (0, 0), variant: \"ieee\", sign-stroke: white)
  resistor(\"r1\", (1.5, 2), (rel: (-3, 0)))
  resistor(\"r2\", \"o2.minus\", (rel: (-3, 0)), position: 70%)    

  
  swire(\"o2.out\", \"r1.in\", ratio: 100%)
  zwire(\"r1.out\", \"o2.minus\", ratio: 0%)

  
  earth(\"s5\", (-1.5,-1))
  swire(\"o2.plus\", \"s5\")

  wstub(\"r2.out\", label: $V_(i n)$)
  estub(\"o2.out\", label: $V_(o u t)$)
})", "Non Inverting Op AMp")
#flashcard("What is the the eq for a non invering op amp", "$frac(V_i, V_o) = 1 + frac(R_f, R_i)$")