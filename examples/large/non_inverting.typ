#import "vault.typ":*
#show: setup
#tag("analouge")

= Non Inverting Op Amp
#circuit({
  import zap:*
  opamp("o2", (0, 0), fill: none, variant: "ieee", scale: (y: -1), sign-stroke: white)
  resistor("r1", (2, 0), (rel: (0, -2)), fill:none)
  resistor("r2", (2, -2), (rel: (0, -2)), fill:none)    
  wire("o2.out", "r1.in")

  zwire("r1.out", "o2.minus", ratio: 120%)

  earth("s5", "r2.out")

  wstub("o2.plus", label: $V_(i n)$)
})

$V_o = (1 + frac(R_1, R_2)) dot V_i$

#flashcard("What amplifier inverts and amplifier a signal", "Inverting OpAmp")
#flashcard("Which op amp is this?
#circuit({
  import zap:*

  opamp(\"o2\", (0, 0), fill: none, variant: \"ieee\", scale: (y: -1), sign-stroke: white)
  resistor(\"r1\", (2, 0), (rel: (0, -2)), fill:none)
  resistor(\"r2\", (2, -2), (rel: (0, -2)), fill:none)    
  wire(\"o2.out\", \"r1.in\")

  zwire(\"r1.out\", \"o2.minus\", ratio: 120%)

  earth(\"s5\", \"r2.out\")

  wstub(\"o2.plus\", label: $V_(i n)$)
})
", "Inverting op amp")
#flashcard("What is the the eq for a non invering op amp", "$frac(V_i, V_o) = 1 + frac(R_f, R_i)$")