#import "vault.typ":*
#show: setup
#tag("analouge")

= Filters
Due to the fact `Capacitors` and `Inductors` react differently based on frequency circuits can be constructed to filter out certain frequencies.

This is done by essentially a voltage divider as capacitors and inductors change their impedance based on frequency. Both of them can be used but as capacitors are easier to manufacture and smaller they will be used.

There are two real types of filters: Low pass and high pass but these can be combined to make many different filters like band pass filters

#flashcard("What are the two main filters", "High pass, low pass")
#flashcard("Which one is high pass and what one is low pass
#circuit({
import zap:*

resistor(\"r1\", (0, 2),(0,0))
capacitor(\"c1\", (0, -2),(0,0))

resistor(\"r2\", (4, -2),(4,0))
capacitor(\"c2\", (4, 2),(4,0))

draw.line((5, 0), (5, -2), mark: (end: \">\", start:\">\"), stroke: white + .8pt, label: [Highpass signal])

draw.line((-1, 0), (-1, -2), mark: (end: \">\", start:\">\"), stroke: white +  .8pt, content: [Lowpass signal])
    
ground( \"gnd\",\"c1.in\",)
nstub(\"r1.in\", label: $V_(i n)$)
ground( \"gnd\",\"r2.in\",)
nstub(\"c2.in\", label: $V_(i n)$)
})", "Left low pass, right highpass")

#circuit({
import zap:*
set-style(fill: none)
set-style(stroke: white)

resistor("r1", (0, 2),(0,0))
capacitor("c1", (0, -2),(0,0))

resistor("r2", (4, -2),(4,0))
capacitor("c2", (4, 2),(4,0))

draw.line((5, 0), (5, -2), mark: (end: ">", start:">"), stroke: white + .8pt, label: [Highpass signal])
draw.content((5.5,-1), [Highpass Signal], anchor: "west")

draw.line((-1, 0), (-1, -2), mark: (end: ">", start:">"), stroke: white +  .8pt, content: [Lowpass signal])
draw.content((-1.5,-1), [Lowpass Signal], anchor: "east")
    
ground( "gnd","c1.in",)
nstub("r1.in", label: $V_(i n)$)
ground( "gnd","r2.in",)
nstub("c2.in", label: $V_(i n)$)
})

The left is low pass as the capacitors impedance will increase on low frequencies therefore taking more of the voltage whereas the right is high pass as the capacitor will increase its impedance to the high frequencies while letting the low frequencies move

== Bode Plot
Is a way to quantify the frequency response of a system, the turning point is at $omega_c$ where the gain turns to $-3 d b$ then the slope is -20dB

The stop band is where the attenuation is bellow $-3 d b$ whereas the pass band is above that

#flashcard("Where is the stop band in a bode plot", "After $w_c$ or $-3 d b$")
#flashcard("Where is the pass band in a bode plot", "Before $w_c$ or $-3 d b$")

#flashcard("What rate of change does a first order filter have in the stop band", "$-20 d b$")

#import "@preview/cetz:0.4.2": canvas
#import cetz.draw: *


#let bode-plot(
  width: 12,
  height: 4,
  filter: "lowpass",
  passband-db: 20,
  cutoff-decade: 1,
) = {
  canvas({
    import cetz.draw:*
  
    let xmin = 0
    let xmax = 3

    let min = -40
    let max = 30

    let fx(x) = (x - xmin) / (xmax - xmin) * width
    let my(y) = (y - min) / (max - min) * height

    set-style(stroke: 0.8pt)

    // Axes
    line((0, 0), (0, height))
    line((0, 0), (width, 0))

    // X-axis decade ticks
    for d in range(0, 4) {
      let x = fx(d)

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

      content((x, -0.22), anchor: "north", [#label])
    }

    // Y-axis grid/ticks
    for db in (-40, -20, 0, 20) {
      let y = my(db)

      set-style(stroke: (dash: "dashed", thickness: 0.5pt))
      line((0, y), (width, y))

      set-style(stroke: 0.8pt)
      line((0, y), (-0.12, y))
      content((-0.25, y), anchor: "east", [$#db$ dB])
    }

    // Labels
    content((0, height + 0.35), anchor: "south-west", [Magnitude])
    content((width, -0.45), anchor: "north-east", [$omega$])

    let x_cut = fx(cutoff-decade)

    // Cutoff marker
    set-style(stroke: (dash: "dotted", thickness: 0.8pt))
    line((x_cut, 0), (x_cut, height))
    content((x_cut + 0.12, height - 0.2), anchor: "west", [$omega_c$])

    // Response
    set-style(stroke: 1.4pt)
    let y_flat = my(passband-db)

    if filter == "lowpass" {
      line((fx(0), y_flat), (x_cut, y_flat))
      line(
        (x_cut, y_flat),
        (fx(3), my(passband-db - 20 * (3 - cutoff-decade))),
      )
    } else if filter == "highpass" {
      let y_left = my(passband-db - 20 * cutoff-decade)
      line((fx(0), y_left), (x_cut, y_flat))
      line((x_cut, y_flat), (fx(3), y_flat))
    }
  })
}

#bode-plot(filter: "lowpass", passband-db: 0, cutoff-decade: 2)
#bode-plot(filter: "highpass", passband-db: 0, cutoff-decade: 1)

= Active filters

This is when there is gain not just attenuation you a filter is placed in either a #note("./inverting.typ") or #note("./non_inverting.typ") op amp, their equations still hold true but with impedance not just resistance

#flashcard("What is an active filter", "Filter with an amplifier meaning there is gain not just attenuation")