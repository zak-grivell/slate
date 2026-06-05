#import "vault.typ":*
#show: setup
#tag("analouge")

= Operational Amplifiers
Is legit the coolest #note("./amplifier.typ") - moggs all the other amplifiers. No even an ASU amplifier can amplify mogg it

#circuit({
  import zap:*

  opamp("o2", (0, 0), fill: none, variant: "ieee", sign-stroke: white)
  wstub("o2.minus", label: $V_+$)
  wstub("o2.plus", label: $V_-$)
  nstub("o2.north", label: $V_(b a r +)$)
  sstub("o2.south", label: $V_(b a r -)$)
  estub("o2.out", label: $V_o$)
})

Follows the equation of
#align(center, $V_o = A(V_+ - V_-)$)

For a perfect operational amplifier

- $A, V_(b a r +), V_(b a r -) arrow infinity$
- $I_+ = I_- = 0$
- No output impedance
- Infinite frequency bandwidth

== In the real world

Mainly
- The amplification has a limit and will only go between $V_(b a r -) <-> V_(b a r +)$
- There is a gain bandwidth product. Bandwidth is the -3db decibel point due to frequency response so this means as $V_i$ moves the bandwidth does but is a constant

== Open Loop
#circuit({
  import zap:*

  opamp("o2", (0, 0), fill: none, variant: "ieee", sign-stroke: white)
  wstub("o2.minus", label: $V_+$)
  wstub("o2.plus", label: $V_-$)
  estub("o2.out", label: $V_o$)
})

This will just throw $V_o$ to the rail of whatever side is larger

== Positive Feedback
This happens when there is a connection between the output and the negative terminal, this feedback loop will in a perfect op amp
#align(center, $V_+ = V_-$)
There are many different feedback and input circuit to achieve many effects.

- #note("./follower.typ")
- #note("./non_inverting.typ")
- #note("./inverting.typ")
- #note("./differential.typ")
- #note("./integrator.typ")
- #note("./instrumentation.typ")

== Negative Feedback
This happens when there is a connection between the output and the positive terminal, this causes the output to immediately jump to one of the rails.

The most basic form of this is the #note("schmitt_trigger.typ") but can then be built upon with circuits like #note("astable_multivibrator.typ") and #note("./monostable_pulse_generator.typ")