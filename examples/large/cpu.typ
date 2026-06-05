#import "vault.typ": *;
#show: setup
#tag("embedded")

= CPU
#flashcard("Difference between harvard and van neuman arcitecture", "memory and data stored in same memory for van neuman")
#flashcard("What direction is the databus", "Bidirectional")
#flashcard("What direction is the address bus", "Single Direction")

The flow in this is simple fetch, decode, execute is applys to when both memory and registers

#flashcard("What are the three main steps of most CPU instructions", "Fetch, decode, exectute")

There is some overlap with this they are independant steps so why not do them at once one instruction can be executing while the next is decoding and the one after that is executing. This means an ALU can do one operation per clock cycle rather than taking multiple as has to fetch and decode first

#flashcard("What is pipelining", "When exectuing an instruction already be decoding one and already be fetching the one after")
#flashcard("What does pipelining allow the ALU to do", "Calculate each tick rather than after a few")
#flashcard("What is the disadvatage of piplining", "Bigger more complex chip taking more power")

#flashcard("What issues can pipelining cause?", "Branch fails")
#flashcard("How does arm prevent pipelining branch fails?", "Instructions that do op conditonally for small otherwise jump")
