#import "vault.typ":*
#show: setup
#tag("analouge")

= Amplifiers
Any amplifier can be generally modeled as

#circuit({
  import zap: *

  vsource("v1", (0, -2), (0, 2), variant: "ieee")
  resistor("rin", (4, -2), (4, 2), variant: "ieee")
  resistor("rs", "v1.out", "rin.out")
  wire("v1.in", "rin.in")
  resistor("rout", (5.75, 2), (10, 2))
  resistor("rload", (10, -2), (10, 2))
  draw.rect((5, 1.25), (6.5,-1.25), name: "rect", stroke: white)
  draw.content("rect.center", align(center, [Gain \ Element]), anchor: "center",   padding: 10pt, align: center)
  wire("rout.in", "rect.north")
  swire("rload.in", "rect.south")
  draw.rect((3, 2.5), (7,-2.5),stroke: (dash: "dashed", thickness: .8pt, paint: white), name: "a")
  draw.content("a.north", align(center, [Voltage Amplifier]), anchor: "south",   padding: 10pt, align: center)
})

#circuit({
  import zap:*;

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

== Gain
Gain is the ratio between in and out

#align(center, table(align: center, columns: (auto, auto, auto),
[*Type*, *Symbol*, *Formula*, *Unit*],
[Voltage], $A_v$, $frac(v_o, v_i)$, [None],
[Current], $A_i$, $frac(i_o, i_i)$, [None],
[Transconductance], $g_m$, $frac(i_o, v_i)$, [Siemens $S$],
[Transresistance], $r_m$, [$frac(v_o, i_i)$], [Ohm $Omega$] 
))

These quantities are generally presented in decibels rather than a decimal value this is

#align(center, $G = 10 log_10 abs(frac(P_o, P_i))$)

for voltage amplifiers as power on a resistor is linked to $V^2$ this causes

#align(center, $A_v = 20 log_10 abs(frac(v_o, v_i))$)
#align(center, $A_i = 20 log_10 abs(frac(i_o, i_i))$)

These are both measured in $d B$

== Frequency Response
Not all amplifiers have the same amplification response at all frequencies this can be shown in a bode plot

#context {

let bode-plot(
  width: 12,
  height: 4,
  low-gain-db: 20,
  cutoff-decade: 1,
) = {
  canvas({
    import cetz.draw:*

    let x0 = 0
    let x1 = width

    let mag-y0 = 0
    let mag-y1 = height

    let xmin = 0
    let xmax = 3

    let min = -20
    let max = 30

    let fx(x) = (x - xmin) / (xmax - xmin) * width
    let my(y) = (y - min) / (max - min) * height

    set-style(stroke: 0.8pt)
    line((0, 0), (0, height))
    line((0, 0), (width, 0))

    for d in range(0, 4) {
      let x = fx(d)

      set-style(stroke: (dash: "dashed", thickness: 0.5pt))

      set-style(stroke: 0.8pt)
      line((x, 0), (x, -0.12))

      let label = if d == 0 {
          $10^0$
        } else if d == 1 {
          $10^1$
        } else if d == 2 {
          $10^2$
        } else {
          $10^3$
        }
    }

    for db in (-20, 0, 20) {
      let y = my(db)

      set-style(stroke: (dash: "dashed", thickness: 0.5pt))
      line((0, y), (width, y))

      set-style(stroke: 0.8pt)
      line((0, y), (-0.12, y))
      content((-0.25, y), anchor: "east", [$#db$ dB])
    }

    content((0, height + 0.35), anchor: "south-west", [Magnitude])
    let x_cut = fx(cutoff-decade)
    set-style(stroke: (dash: "dotted", thickness: 0.8pt))
    content((x_cut + 0.12, height - 0.2), anchor: "west", [$omega_c$])

    let y_flat = my(low-gain-db)
    set-style(stroke: 1.4pt)
    line((fx(0), y_flat), (x_cut, y_flat))
    line(
      (x_cut, y_flat),
      (fx(3), my(low-gain-db - 20 * (3 - cutoff-decade))),
    )
  })
}

 bode-plot(
  width: 11,
  height: 4,
  low-gain-db: 20,
  cutoff-decade: 1,
)
}