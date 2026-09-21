#import "vault.typ":*
#show: setup
#tag("analouge")

= Diodes
Diodes are nonlinear IV components. The idea diode has an IV graph of $0A$ when $v<0$ but a vertical asymptote when $v>0$. They are used in many areas like #note("./rectifiers.typ") and #note("./voltage_doubler.typ")

#canvas(length: 3cm, {
  import cetz.draw: *
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  line((-1, 0), (1, 0), mark: (end: "stealth"))
  content((), anchor: "west", padding: 0.1, $v$)

  line((0, -1), (0, 1), mark: (end: "stealth"))
  content((), anchor: "south", padding: 0.1, $i$)

  for x in (-1, -0.5, 0.5) {
    line((x, 3pt), (x, -3pt))
  }

  for y in (-1, -0.5, 0.5) {
    line((3pt, y), (-3pt, y))
  }

  line((-1, 0), (0, 0), stroke: red)

  line((0, 0), (0, 1), stroke: red)
})

In one direction it acts like a short circuit whereas in the other it acts like an open loop.

#flashcard(
  "Describe the function of a diode and it's iv graph",
  "One direction short circuit - vertical, Other direction open loop - flatline",
)

A real diode is not like this. It has leakage current on its negative side, and does not perfectly conduct on the positive side and forms an exponential curve


#canvas(length: 3cm, {
  import cetz.draw: *
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  line((-1, 0), (1, 0), mark: (end: "stealth"))
  content((), anchor: "west", padding: 0.1, $v$)

  line((0, -1), (0, 1), mark: (end: "stealth"))
  content((), anchor: "south", padding: 0.1, $i$)

  for x in (-1, -0.5, 0.5) {
    line((x, 3pt), (x, -3pt))
  }

  for y in (-1, -0.5, 0.5) {
    line((3pt, y), (-3pt, y))
  }

  let p = none

  for i in range(100) {
    let x = (i - 50) / 50

    let y = if (x < 0) {
      x * calc.exp(20 * -x - 20)
    } else {
      x * calc.exp(2 * x - 2)
    }

    if (p != none) {
      line(p, (x, y), stroke: red)
    }

    p = (x, y)
  }
})


A load line is a method of solving problems by overlaying the IV graphs of devices for example a resistor and diode create

#canvas(length: 3cm, {
  import cetz.draw: *
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  line((-1, 0), (1, 0), mark: (end: "stealth"))
  content((), anchor: "west", padding: 0.1, $v$)

  line((0, -1), (0, 1), mark: (end: "stealth"))
  content((), anchor: "south", padding: 0.1, $i$)

  for x in (-1, -0.5, 0.5) {
    line((x, 3pt), (x, -3pt))
  }

  for y in (-1, -0.5, 0.5) {
    line((3pt, y), (-3pt, y))
  }

  let p = none

  for i in range(100) {
    let x = (i - 50) / 50

    let y = if (x < 0) {
      x * calc.exp(20 * -x - 20)
    } else {
      x * calc.exp(2 * x - 2)
    }

    if (p != none) {
      line(p, (x, y), stroke: red)
    }

    p = (x, y)
  }

  let p = none

  for i in range(100) {
    let x = (i - 50) / 50

    let y = if (x > 0) {
      1 - x
    } else {
      none
    }

    if (p != none and y != none) {
      line(p, (x, y), stroke: blue)
    }

    if (y != none) {
      p = (x, y)
    }
  }
})

Therefore, the current & voltage over diode is the intersection between the two lines.

== Appoximation

A real diode can be approximated with a resistor, supply and perfect diode

#circuit({
  import zap: *

  diode("d1", (0, 0), (rel: (0, -2)))
  resistor("r1", "d1.out", (rel: (0, -2)))
  vsource("b", (0, -6), "r1.out", variant: "ieee", label: $V_(t h)$)
})

This repersents the voltage drop over the diode as well as the non straight verical line of the diode in formward bias

#align(center, canvas(length: 3cm, {
  import cetz.draw: *
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  line((-0.1, 0), (1, 0), mark: (end: "stealth"))
  content((), anchor: "west", padding: 0.1, $v$)

  line((0, -0.1), (0, 1), mark: (end: "stealth"))
  content((), anchor: "south", padding: 0.1, $i$)

  line((0.5, 3pt), (0.5, -3pt))
  line((3pt, 0.5), (-3pt, 0.5))

  let p = none

  for i in range(100) {
    let x = i / 100

    let y = if (x < 0) {
      x * calc.exp(200 * -x - 20)
    } else {
      0.5 * x * calc.exp(5 * x - 4)
    }

    if (p != none) {
      line(p, (x, y), stroke: red)
    }

    p = (x, y)
  }

  let p = none

  for i in range(100) {
    let x = i / 100

    let y = if (x < 0.7) {
      0
    } else {
      5*x - 3.5
    }

    if (p != none and y != none) {
      line(p, (x, y), stroke: blue)
    }

    if (y != none) {
      p = (x, y)
    }
  }
}))

#flashcard("What components appoximate a real diode", "A perfect diode, a resistor and a supply for the voltage drop")

Real Diode Eq: $V_o = I_o (e^frac(V_D, V_T) -1)$

#flashcard("Real diode equasion", "$V_o = I_o (e^frac(V_D, V_T) -1)$")
