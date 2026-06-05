#import "vault.typ":*
#show: setup
#tag("analouge")

= Differential Amplifier
#circuit({
  import zap: *
  opamp("o2", (0, 0), variant: "ieee", sign-stroke: white)
  resistor("r1", (1.5, 2), (rel: (-3, 0)), label: $R_3$)
  resistor("r2", "o2.minus", (rel: (-3, 0)), position: 70%, label: (content: $R_1$, anchor: "south"))    
  resistor("r4", "o2.plus", (rel: (-3, 0)), position: 70%, label: $R_2$)    

  
  swire("o2.out", "r1.in", ratio: 100%)

  zwire("r1.out", "o2.minus", ratio: 0%)

  
  earth("s5", (-1.5,-3.5))
  resistor("r3", (-1.5, -1), "s5", label: $R_4$)
  swire("o2.plus", "r3.in")

  wstub("r2.out", label: $V_(a)$)
  wstub("r4.out", label: $V_(b)$)
  estub("o2.out", label: $V_(o u t)$)
})

Typically $R_1 = R_2$ & $R_3 = R_4$

#align(center, $V_o = frac(R_3,R_1) dot (V_1 - V_2)$)

#flashcard("What op amp is used to find the difference between two signals", "differential amplifier")
#flashcard("What two resistors are typically the same in a differential amplifier", "Feedback and ground, Two input resistors")

#flashcard("What op amp is this?
#circuit({
  import zap: *
  opamp(\"o2\", (0, 0), variant: \"ieee\", sign-stroke: white)
  resistor(\"r1\", (1.5, 2), (rel: (-3, 0)), label: $R_3$)
  resistor(\"r2\", \"o2.minus\", (rel: (-3, 0)), position: 70%, label: (content: $R_1$, anchor: \"south\"))    
  resistor(\"r4\", \"o2.plus\", (rel: (-3, 0)), position: 70%, label: $R_2$)    

  
  swire(\"o2.out\", \"r1.in\", ratio: 100%)

  zwire(\"r1.out\", \"o2.minus\", ratio: 0%)

  
  earth(\"s5\", (-1.5,-3.5))
  resistor(\"r3\", (-1.5, -1), \"s5\", label: $R_4$)
  swire(\"o2.plus\", \"r3.in\")

  wstub(\"r2.out\", label: $V_(a)$)
  wstub(\"r4.out\", label: $V_(b)$)
  estub(\"o2.out\", label: $V_(o u t)$)
})", "Differential op amp")

#flashcard("What is the equasion for a standard differential op amp", "$V_o = frac(R_f,R_i) dot (V_1 - V_2)$")
#flashcard("What are the uses of the differential op amp", "Two wires to subtract interference can diff on them")