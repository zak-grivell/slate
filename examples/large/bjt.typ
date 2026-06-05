#import "vault.typ":*
#show: setup
#tag("analouge")

= Bipolar Junction Transistors
Sandwich of doped semiconductors types being - PNP, NPN

Current controlled amplification based $I_c = beta I_b$

== Biasing Rules
- 10x current through R1 & R2 than base
#flashcard("How much more current though R1 & R2 than the base in a bjt transistor", "10x")

- In 4 resistor setup V_B = 1
#flashcard("In four resistor setup what should the resistance be about $V_e$ be about", "1V")

- Collector voltage should be half V_cc
#flashcard("What is the ideal collector voltage", "$frac(V_(c c), 2)$")

== AC Small Circuit
#circuit({
  import zap:*

  bjt("t1", (-4, -1))
  wstub("t1.base", label: "B")
  sstub("t1.e", label:"E")
  nstub("t1.c", label:"C")
  resistor("rb", (0,0), (rel: (0, -2)), label: $r_b$)
  wire("rb.out", (rel: (2, 0)))
  transformer("g", (2,-2), (2, 0), label: (content: $beta i_b$, anchor: "west"))
  resistor("rg", (4, -2), (4, 0), label: $1/g_m$)
  wire("g.in", "rg.in")
  wire("g.out", "rg.out")
  wstub("rb.in", label: "B")
  wstub("rb.out", label:"E")
  estub("rg.out", label:"C")
})

But what are the values of $r_b$ and $g_o$?

$r_b$ is the equivalent resistance of the voltage dropped over the transistor

#align(center, $r_b = (delta v_(b e)) / (delta i_(b))$)

where $delta v_(b e)$ and $delta i_b$ is the small signal equivalent of $v_(b e)$ and $i_b$

As this is small signal analysis the 0.7V voltage drop is constant therefore the only voltage drop over $r_b$ is based on the thermal temperature and therefore $v_T$ and $i_b$ is already small signal so is left.

#align(center, $r_b = (delta v_(T)) / (delta i_(b))$)

The Transconductance is ratio between current out and voltage in

#align(center, $g_m = frac(i_(o u t), v_(i n)) = frac(I_c, V_T) = frac(beta, r_b)$)

At room temperature a typical $V_t$ is $25 m V$

== EQ's
#flashcard("BJT current gain eq", "$beta = frac(I_c, I_b)$")
#flashcard("What is a typical value for $V_T$", "$25 m V$")
#flashcard("What is the transconductance of a bjt in ac small signal", "$g_m = frac(I_c, V_T)$")
#flashcard("Equasion for bjt ac small circuit input resistance", "$r_b = frac(V_T, I_b)$")

#flashcard("What is the value of the output resistance in a bjt ac small circuit", "$1/g_o$")

#flashcard("How do you find the input resistance of a bjt", "Apply test voltage, find the resultant current and ratio")

#flashcard("How do you find the output resistance of a bjt", "Short input, Apply voltage to out terminals and calculate current")

#flashcard("What is the small circuit equivilant of a bjt", "
#circuit({
  import zap:*
  resistor(\"rb\", (0,0), (rel: (0, -2)), label: $r_b$)
  wire(\"rb.out\", (rel: (2, 0)))
  transformer(\"g\", (2,-2), (2, 0), label: (content: $beta i_b$, anchor: \"west\"))
  resistor(\"rg\", (4, -2), (4, 0), label: $1/g_m$)

  wire(\"g.in\", \"rg.in\")
  wire(\"g.out\", \"rg.out\")

  wstub(\"rb.in\", label: \"B\")
  wstub(\"rb.out\", label:\"E\")
  estub(\"rg.out\", label:\"C\")
})
")



#flashcard("What is the output current of a bjt in ac small circuit", "$beta i_b$")

