#import "vault.typ":*
#show: setup
#tag("analouge")

= Rectifiers
#circuit({
  import zap:*

  acvsource("s1", (0, -1), (0, 1))
  diode("d1", "s1.out", (rel: (2, 0)))
  resistor("r1", "d1.out", (rel: (0, -2)), label: $R_L$)
  wire("r1.out", "s1.in")
})

This is a half bridge rectifier. It takes an AC voltage an essentially chops the bottom half off and only gives the positive half. It will often come with a capacitor to smooth the voltage towards more DC. This is very inefficient for AC to DC conversion as half the power is dissipated over a diode therefore a full bridge rectifier is used

#circuit({
  import zap:*
  
  acvsource("s1", (-2, -1), (-2, 1))
  diode("d1", (0,0), (rel: (2, 2)))
  diode("d2", "d1.out", (rel: (2, -2)))
  diode("d3", (0,0), (rel: (2, -2)))
  diode("d4", "d3.out", (rel: (2, 2)))
  zwire("s1.out", "d1.out", ratio: 0%)
  zwire("s1.in", "d3.out", ratio: 0%)
  resistor("r1", (6, 0), (rel: (0, -3)), label: $R_L$)
  zwire("r1.out", "d1.in", ratio: 100%)
  zwire("r1.in", "d4.out", ratio: 100%)
}))

This essentially takes the absolute value of the input as the path is made positive through two diodes each way. This combined with some smoothing capacitors make a full bridge rectifier
