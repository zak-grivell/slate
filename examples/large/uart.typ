#import "vault.typ":*
#show: setup
#tag("embedded")

= UART
Universal asyncronous reciver-transmitter
- asyncronous
- peer to peer
- full duplex

#flashcard("What does UART stand for", "Universal asyncronous reciver-transmitter")
#flashcard("Is UART asyncronous or syncronous", "asyncronous ")
#flashcard("Is UART master slave or ptp", "ptp")
#flashcard("Is UART simplex, duplex or half-duplex", "full-duplex")

#flashcard("What is a frame in UART", "One transmission")

== Wiring
Two wires
- RX = reciver 
- TX = transmitter
RX is hooked up to peers TX and vice versa and both idle high

#flashcard("What are the two ports in UART", "TX, RX")
#flashcard("What does RX connect to", "TX")
// #flashcard("What is RX", "Reciver")
// #flashcard("What is TX", "Transmitter")
#flashcard("How do the lines in UART idle and who does it", "Transmitter idles high")

== Timings
Starts with tranmitter pulling line low, then 8 bits lsb first and a parity bit then a stop bit high

#flashcard("Describe the sequence of UART", "Start, 8 data bits, maybe partiy bit, stop bit")
#flashcard("What is the start bit in UART", "Down transistion")
#flashcard("What direction do UART data bits go in", "Least significant first")
#flashcard("What is a parity bit", "Make numbers of 1's and 0's even so can detect errors")
#flashcard("What is the stop bit of UART", "Simply up transistion after 8 bits")
