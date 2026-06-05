#import "vault.typ":*
#show: setup
#tag("analouge")

= Instrumentation Amplifier
Combination of two #note("./follower.typ") amplifiers and #note("./differential.typ") to create the ultimate circuit for sensors

#circuit({
  import zap:*

  set-style(stroke: white)
  set-style(fill: none)

  opamp("o1", (-6, 2), variant: "ieee", sign-stroke: white, scale: (y: -1),)
  opamp("o3", (-6, -2), variant: "ieee", sign-stroke: white)

  opamp("o2", (0, 0), variant: "ieee", sign-stroke: white)
  resistor("r1", (1.5, 2), (rel: (-3, 0)))
  resistor("r2", "o2.minus", (rel: (-3, 0)), position: 60%)    
  resistor("r4", "o2.plus", (rel: (-3, 0)), position: 60%)

  swire("o1.out", "r2.out")
  swire("o3.out", "r4.out")

  resistor("r7", (-8, -0.5), (-8, 0.5), scale: 0.5)    
  resistor("r5", "r2.out", "r7.out")    
  resistor("r6", "r4.out",  "r7.in")

  zwire("r7.out", "o1.minus", ratio: 0%)
  zwire("r7.in", "o3.minus", ratio: 0%)


  
  swire("o2.out", "r1.in", ratio: 100%)

  zwire("r1.out", "o2.minus", ratio: 0%)

  
  earth("s5", (-1.5,-3.5))
  resistor("r3", (-1.5, -1), "s5")
  swire("o2.plus", "r3.in")

  estub("o2.out", label: $V_(o u t)$)

  wstub("o1.plus", label: $V_(a)$)
  wstub("o3.plus", label: $V_(b)$)
})

#flashcard("What is a instrumental amplifier made up of", "Two followers and one differential amplifier with a gain resistor between the followers")
#flashcard("What configuration of op amp is this?
#circuit({
  import zap:*

  opamp(\"o1\", (-6, 2), variant: \"ieee\", sign-stroke: white, scale: (y: -1),)
  opamp(\"o3\", (-6, -2), variant: \"ieee\", sign-stroke: white)

  opamp(\"o2\", (0, 0), variant: \"ieee\", sign-stroke: white)
  resistor(\"r1\", (1.5, 2), (rel: (-3, 0)))
  resistor(\"r2\", \"o2.minus\", (rel: (-3, 0)), position: 60%)    
  resistor(\"r4\", \"o2.plus\", (rel: (-3, 0)), position: 60%)

  swire(\"o1.out\", \"r2.out\")
  swire(\"o3.out\", \"r4.out\")

  resistor(\"r7\", (-8, -0.5), (-8, 0.5), scale: 0.5)    
  resistor(\"r5\", \"r2.out\", \"r7.out\")    
  resistor(\"r6\", \"r4.out\",  \"r7.in\")

  zwire(\"r7.out\", \"o1.minus\", ratio: 0%)
  zwire(\"r7.in\", \"o3.minus\", ratio: 0%)


  
  swire(\"o2.out\", \"r1.in\", ratio: 100%)

  zwire(\"r1.out\", \"o2.minus\", ratio: 0%)

  
  earth(\"s5\", (-1.5,-3.5))
  resistor(\"r3\", (-1.5, -1), \"s5\")
  swire(\"o2.plus\", \"r3.in\")

  estub(\"o2.out\", label: $V_(o u t)$)

  wstub(\"o1.plus\", label: $V_(a)$)
  wstub(\"o3.plus\", label: $V_(b)$)
})", "Instrumental Amplifier")

#flashcard("Why is a instrumental amplifier used?", "For sensors as will draw minimal current can cancel interference")
#flashcard("What resistor controls gain", "Small one between the followers")

#flashcard("What are the four resistors in a instrumental amplifier and thier names", "R_f - feedback resistors, R_fo = follower resistors, R_g = resistor between followers controling gain, R_i = Input to differential resistors")

#flashcard("What is the gain ($frac(V_o, V_a-V_b)$) in an instrumental amplfier", "$G_v = (1 + frac(2R_(f o), R_g)) frac(R_f, R_i)$")