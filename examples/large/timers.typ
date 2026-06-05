#import "vault.typ": *;
#show: setup
#tag("embedded")

= Timers
Use a physical hardware timer to precisley time between event rather than relying on CPU cycles which is not precise

Varients:
- Timer - just start and stop it
- Ticker - run a interupt service routine to switch cpu to function at intervals
- Timeout - once after an amount of time run an ISR

#flashcard("What is an ISR", "Iterupt Service Routine - triggered by hardware and moves CPU to different thread")
#flashcard("What is a mbed timeout", "Wait then trigger ISR")
#flashcard("What is a mbed ticker", "At set intervals trigger ISR")
#flashcard("What is a mbed timer", "Count time between .start() and .stop()")
