#import "vault.typ":*
#show: setup
#tag("analouge")

= Astable multivibrator
Combination of an RC charging circuit and a #note("./schmitt_trigger.typ")

#circuit({
  import zap:*

  opamp("o1", (0,0), variant: "ieee", fill:none, sign-stroke: white)
  resistor("r1", (1.5, 0), (rel: (0, -2)), label:$R_1$)
  wire("r1.in", "o1.out")
  resistor("r2", "r1.out", (rel: (0, -2)), label:$R_2$)
  zwire("r1.out", "o1.plus", ratio: 130%)
  earth("end","r2.out")
  resistor("r3", (-3, 2), (1.5, 2), label:$R_3$)
  zwire("r3.out", "o1.out", ratio: 0%)
  zwire("r3.in", "o1.minus", ratio: 0%)
  capacitor("c1", "r3.in", (rel: (0, -6)), label: $C_1$)
  earth("end","c1.out")
})

The RC charging circuit cause a delay to the switching states of the #note("./schmitt_trigger.typ") meaning it creates a square wave. The point in which it switches is when the voltage over the capacitor is $beta V_s$

#cetz.canvas(length: 3cm, {
  import cetz.draw: *

  line((0, 0), (5, 0), mark: (end: "stealth"))
  line((0, -1), (0, 1), mark: (end: "stealth"))

  let p = (0.1,0)
  for i in range(20, 1000) {
    let x = i / 200
  
    if (calc.rem(x, 1) < 0.5) {
      cetz.draw.line(p, (x, 1), stroke: blue)
      p = (x, 1)
    } else {
      cetz.draw.line(p, (x, -1), stroke: blue)
      p = (x, -1)
    }
  }

  let p = (0.1, 0)
  for i in range(20, 1000) {
    let x = i / 200
    let y = -0.75 * (1.25 - 2 * calc.exp(-3 * calc.rem(x, 0.5)))
  
    if (calc.rem(x, 1) < 0.5) {
      cetz.draw.line(p, (x, y), stroke: red)
      p = (x, y)
    } else {
      cetz.draw.line(p, (x, -y), stroke: red)
      p = (x, -y)
    }
  }
})

In red is the $V_-$, the voltage over the capacitor and blue is the output

The equation for the capacitor is
#align(center, $V_c = (V_f + (V_i - V_f)e^(-frac(t, R C)))$)

Rearanging
#align(center, $T = R C ln (frac(V_i - V_f, v_c(t) - V_f))$)

The switch occurs when $V_c$ = $beta V_s$, $V_f = -V_s$, $V_i = beta V_s$

#align(center, $T = R C ln (frac(beta V_s + V_s, - beta V_s + V_s))$)

#align(center, $T = 2 R C ln (frac(1 + beta, 1 - beta))$)

#flashcard("What is an astable multivibrator", "Combination of an RC circuit & a schmitt trigger to create a square wave")

#flashcard("What does an astable multivibrator look like", "
#circuit({
  import zap:*
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  opamp(\"o1\", (0,0), variant: \"ieee\", fill:none, sign-stroke: white)

  resistor(\"r1\", (1.5, 0), (rel: (0, -2)), label:$R_1$)
  wire(\"r1.in\", \"o1.out\")

  resistor(\"r2\", \"r1.out\", (rel: (0, -2)), label:$R_2$)

  zwire(\"r1.out\", \"o1.plus\", ratio: 130%)

  earth(\"end\",\"r2.out\")


  resistor(\"r3\", (-3, 2), (1.5, 2), label:$R_3$)
  zwire(\"r3.out\", \"o1.out\", ratio: 0%)

  zwire(\"r3.in\", \"o1.minus\", ratio: 0%)

  capacitor(\"c1\", \"r3.in\", (rel: (0, -6)), label: $C_1$)

  earth(\"end\",\"c1.out\")
  // zwire(\"r3.out\", \"o1.out\", ratio)
})
",)

#flashcard("What is $V_+$ and $V_o$ look like in a astable multivibrator over time", "
#import \"@preview/cetz:0.5.0\"
  
#align(center, cetz.canvas(length: 3cm, {
  import cetz.draw: *
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  line((0, 0), (5, 0), mark: (end: \"stealth\"))
  line((0, -1), (0, 1), mark: (end: \"stealth\"))
 
  // for x in (-1, -0.5, 0.5, 1) {
  //   line((x, 3pt), (x, -3pt))
  // }

  // for y in (0.5, 1) {
  //   line((3pt, y), (-3pt, y))
  // }

  let p = (0.1,0)

  for i in range(20, 1000) {
    let x = i / 200
  
    if (calc.rem(x, 1) < 0.5) {
      cetz.draw.line(p, (x, 1), stroke: blue)
      p = (x, 1)
    } else {
      cetz.draw.line(p, (x, -1), stroke: blue)
      p = (x, -1)
    }
  }

  let p = (0.1, 0)

  for i in range(20, 1000) {
    let x = i / 200

    let y = -0.75 * (1.25 - 2 * calc.exp(-3 * calc.rem(x, 0.5)))
  
    if (calc.rem(x, 1) < 0.5) {
      cetz.draw.line(p, (x, y), stroke: red)
      p = (x, y)
    } else {
      cetz.draw.line(p, (x, -y), stroke: red)
      p = (x, -y)
    }
  }

}))
")

#flashcard("What is the period of an astable multivibrator", "$T = 2 R C ln (frac(1 + beta, 1 - beta))$")