#import "vault.typ":*
#show: setup
#tag("analouge")

= Mosfet
Voltage controlled amplifier / switch, gain is between voltage in and drain current

== AC Small Circuit
#circuit({
  import zap:*

  mosfet("t1", (-4, -1))

  wstub("t1.g", label: "Gate")
  sstub("t1.s", label:"Source")
  nstub("t1.d", label:"Drain")

  // resistor("rb", (0,0), (rel: (0, -2)), label: $r_b$)
  wire((0, -2), (rel: (2, 0)))
  transformer("g", (2,-2), (2, 0), label: (content: $g_m v_(g s)$, anchor: "west"))
  resistor("rg", (4, -2), (4, 0), label: $1/g_m$)

  wire("g.in", "rg.in")
  wire("g.out", "rg.out")

  wstub((0, 0), label: "Gate")
  wstub((0, -2), label:"Source")
  estub("rg.out", label:"Drain")
})
Note $g_m$ is different from $g_o$. As high impedance at input, the input is an open circuit

$g_o = frac(i_d, v_(g s))$


== AC small circuit 

#flashcard("Mosfet output current equasion in ac small circuit", "$g_m v_(g s)$")

#flashcard("What is a mosfet's $g_m$ equivilant to in a bjt", "$beta$")

The input impedance is infinite
#flashcard("Mosfet input impedance", "Infinite")

#flashcard("What are the terminals on a mosphet and thier directions", "
#circuit({
  import zap:*

  mosfet(\"t1\", (-4, -1))

  wstub(\"t1.g\", label: \"Gate\")
  sstub(\"t1.s\", label:\"Source\")
  nstub(\"t1.d\", label:\"Drain\")
})
")

#flashcard("What is the AC small circuit of a MOSFET", "
#circuit({
  import zap:*

  wire((0, -2), (rel: (2, 0)))
  transformer(\"g\", (2,-2), (2, 0), label: (content: $g_m v_(g s)$, anchor: \"west\"))
  resistor(\"rg\", (4, -2), (4, 0), label: $1/g_m$)

  wire(\"g.in\", \"rg.in\")
  wire(\"g.out\", \"rg.out\")

  wstub((0, 0), label: \"Gate\")
  wstub((0, -2), label:\"Source\")
  estub(\"rg.out\", label:\"Drain\")
})
")