#import "vault.typ":*
#show: setup
#tag("analouge")

= Voltage Follower

#circuit({
  import zap:*
  set-style(stroke: white)
  set-style(fill: none)
  set-style(sign-stroke: white)

  opamp("o1", (0, 0), variant: "ieee", sign-stroke: white, scale: (y: -1),)
  resistor("r1", (-1.5, -2), (1.5, -2))

  zwire("o1.out", "r1.out", ratio: 100%)
  zwire("o1.minus", "r1.in", ratio: 100%)

  estub("o1.out", label: $V_(o u t)$)

  wstub("o1.plus", label: $V_(a)$)
})

This does not effect the voltage of the signal it just decouples the input from the rest of the circuit. It uses the fact op amps draw no current at their inputs to protect things like sensors and other devices that do not produce a lot of current

#flashcard("What op amp configuration is for connecting to sensors", "Voltage Follower")
#flashcard("Why is a voltage follower used", "As sensors cannot produce lots of current")
#flashcard("Describe the voltage follower configuration", "
#circuit({
  import zap:*
  set-style(stroke: white)
  set-style(fill: none)

  opamp(\"o1\", (0, 0), variant: \"ieee\", sign-stroke: white, scale: (y: -1),)
  resistor(\"r1\", (-1.5, -2), (1.5, -2))

  zwire(\"o1.out\", \"r1.out\", ratio: 100%)
  zwire(\"o1.minus\", \"r1.in\", ratio: 100%)

  estub(\"o1.out\", label: $V_(o u t)$)

  wstub(\"o1.plus\", label: $V_(a)$)
})")