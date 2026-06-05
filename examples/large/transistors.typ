#import "vault.typ":*
#show: setup
#tag("analouge")

= Transistors
Two types: #note("./bjt.typ") and #note("./mosfet.typ")

When creating a transistor circuit two analysis stages:
- DC bias conditions to find operating point
- Analysis with AC assuming linear behavior around the operating point

== DC Bias Point
The bias point $Q$ is some point on the load line (blue)

#let plot(fn, color) = {
  import cetz.draw: *
  let p = (0,fn(0));

  for i in range(0, 100) {
    let x = i / 100;
    let n = (x, fn(x));

    line(p, n, stroke: color)

    p = n
  }
}

#canvas({
  import cetz.draw: *

  line((-0.1, 0), (1, 0), mark: (end: "stealth"))
  content((), anchor: "west", padding: 0.1, $V_(c e)$)

  line((0, -0.1), (0, 1), mark: (end: "stealth"))
  content((), anchor: "south", padding: 0.1, $I_c$)
 
  line((0.5, 3pt), (0.5, -3pt))
  line((3pt, 0.5), (-3pt, 0.5))

  for a in range(1, 10) {
    let b = a / 10
    let c = calc.ln(a / 10);

    plot(x => b - calc.exp(c - 10 * x), red)
  }

  plot(x => 1 - x, blue)
}))

- The Y intercept is the saturation region where the transistor has no voltage drop and the (fully on)
- The X intercept is the cutoff region where the transistor has no current through (off)
- The Q point lies in the active region between them with ideal being $Q$ is at $x= frac(V_(c c), 2)$ but may not always be possible

When doing DC biasing can approxmate active reigon as 75% of the load line

#flashcard("Approximatley what is the safe range of a transistor load line", "75%")

== AC analysis
- AC sees capacitors as a short circuit therefore short the capacitors
- AC only sees changing signals not static so short power to ground
- Replace the transistor with its AC small circuit model
- Solve the amplifier circuit using gain equations


#circuit({
  import zap:*

  bjt("t1", (0,0))

  resistor("rc", "t1.c", (0, 3))

  vcc("c1", "rc.out")

  wire("rc.out", (rel: (-2, 0)))

  resistor("rb", (-2,3), (rel: (0, -3)))

  wire("rb.out", "t1.base")

  capacitor("c1", "rb.out", (rel: (-2, 0)))

  capacitor("c2", "rc.in", (rel: (2,0)))
  estub("c2.out", label: $V_(o u t)$)

  acvsource("vin", "c1.out", (rel: (0, -2)))

  zwire("vin.out", "t1.e", ratio: 100%)


  resistor("rl", "c2.out", (2, -2), label: $R_l$)
  wire("rl.out", "vin.out")
})

- Short circuit capacitors & supplies - should be low impedance at analyzed frequency, supplies are DC which is ground to AC

#circuit({
  import zap:*
  bjt("t1", (0,0))

  resistor("rc", "t1.c", (0, 3))

  wire("rc.out", (rel: (-2, 0)))

  resistor("rb", (-2,3), (rel: (0, -3)))

  wire("rb.out", "t1.base")

  acvsource("vin", "rb.out", (rel: (0, -2)))


  zwire("vin.out", "t1.e", ratio: 100%)

  zwire("rc.out", "vin.out", ratio: -150%)

  resistor("rl", (2, 0.5), (2, -2), label: $R_l$)
  wire("rl.in", "t1.c")
  wire("rl.out", "vin.out")
})

- Redraw the circuit as simple as possible

#circuit({
  import zap:*
  bjt("t1", (0,0))

  resistor("rc", (1, 1), (1, -2), label: $R_c || R_l$)

  resistor("rb", (-2,0), (rel: (0, -2)))

  // wire("rb.out", "t1.base")
  //

  acvsource("vin", (-4, 0), (rel: (0, -2)))

  wire("vin.in", "t1.base")

  zwire("vin.out", "t1.e", ratio: 100%)

  zwire("t1.c", "rc.in", ratio: 0%)

  wire("vin.out", "rc.out")

  // zwire("rc.out", "vin.out", ratio: -150%)
})

- Replace transistor with small signal model

The model is


#circuit({
  import zap:*
  acvsource("vin", (-4, 0), (rel: (0, -2)))

  resistor("rb", (-2,0), (rel: (0, -2)))
  
  resistor("rb", (0,0), (rel: (0, -2)), label: $r_b$)
  wire("rb.out", (rel: (2, 0)))
  transformer("g", (2,-2), (2, 0), label: (content: $beta i_b$, anchor: "west"))
  resistor("rg", (4, -2), (4, 0), label: $1/g_o$)

  wire("g.in", "rg.in")
  wire("g.out", "rg.out")

  wire("rb.in", "vin.in")
  wire("rb.out", "vin.out")

  resistor("rc", (6, 0), (6, -2), label: $R_c || R_l$)

  wire("rc.in", "rg.out")
  wire("rc.out", "rg.in")
})

Omg its #note("./amplifier.typ") circuit that can be simplified!!! Use thenivin theorem to get from current parallel to voltage series voltage and can be easily solved!