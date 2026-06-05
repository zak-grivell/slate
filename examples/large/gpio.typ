#import "vault.typ":*
#show: setup
#tag("embedded")

= GPIO Acess
Mbed normally just uses `DigitalOut` class and then you can just ```cpp pin = 1``` for high and ```cpp pin=0``` for low. But how does this actually set pins?

== Data bus setup
When outputting to pins you select which pins is changed on the databus this is done with an already decoded value e.g. pin3 would be `1000`

#flashcard("How is a specific pin selected", "Loading its decoded value as a one onto the databus")
#flashcard("What is the device which controlls what pins are hooked up to called", "Pin Control Register Mux Feild")

== Setup
To save power pins at set off by default and need to be enabled to enable the clock to a pin it is ```cpp
SIM->SCGC5
 ``` and is set with the decoded number

#flashcard("What does ```cpp SIM->SCGC5 |= x``` do?", "Enables the clock and power to pin decoded number x")

As pins can have multiple functions have to select the specific output so ```cpp
PORTB->PCR[x] = 0x0100;
``` This sets the Pin control register muliplexr to have pin $x$ as an GPIO pin 

#flashcard("What does ```cpp PORTX->PCR[x] = CODE``` do?", "Sets up pin x of port X to be of type CODE where code is like pwm or aout etc")
#flashcard("What does the Pin control register muliplex do", "Determines what a pin does e.g. is it connected to GPIO or PWM or hardware timer etc")

#flashcard("What are the two lines to setup a GPIO pin", "Enable clock, set pin as GPIO")

== Operation
These control the pin setting

These work by having special addresses associated with registers which control pin IO these are:
- PDOR - Port data output register
- PSOR - Port set output resiger
- PCOR - Port clear output register
- PTOR - Port toggle output register

PSOR, PCOR, PTOR allow for only effecting some pins compared to PDOR which sets all at once

This address decoded into
- PDDR select - Port data direction register select - sets wether input or output
- PDOR select - Selects that is setting all pins
- PSOR select -  Selects that setting a pin
- PCOR select -  Selects that clearing a pin
- PTOR select - Selects that toggling pin
These all take the data from the databus to perform the operations

Also has the input PDIR select which puts the reading value onto the databus

#flashcard("What does the PDDR stand for and what does it do", "Port data direction register select - sets wether input or output")
#flashcard("What does the PDOR stand for and what does it do", "Port data output register - set all outputs")
#flashcard("What does the PSOR stand for and what does it do", "Port set output resiger - Selects that setting a pin")
#flashcard("What does the PCOR stand for and what does it do", "Port clear output register - Selects that clearing a pin")
#flashcard("What does the PTOR stand for and what does it do", "Port toggle output register - Selects that toggling pin")
#flashcard("What does the PDIR stand for and what does it do", "Port data input register - Loads pin value onto databus")

These are all accessed by using PTB->OPERATION = pin

#flashcard("What is the cpp code for doing operation on pin", "PTB->OPERATION = pin where pin is the decoded pin number")

#flashcard("What are the steps for setting a pin up for GPIO output", "Start clock to pin, enable it as GPIO set it as an output via PDDR")


#flashcard("What does MOVS instruction do?", "Loads a value from ether a register or a raw value into specified register")
#flashcard("What does LSLS instruction do?", "Left shift number")
#flashcard("What does LDR instruction do?", "Load data from memory in register")
#flashcard("What does STR instruction do?", "Store data into memory from register")