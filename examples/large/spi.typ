#import "vault.typ":*
#show: setup
#tag("embedded")

= SPI
Serial Peripheral Interface is
- syncronous
- master slave
- half-duplex

#flashcard("What does SPI stand for", "Serial Peripheral Interface")
#flashcard("Is SPI asyncronous or syncronous", "syncronous")
#flashcard("Is SPI master slave or ptp", "Master Slave")
#flashcard("Is SPI simplex, duplex or half-duplex", "full-duplex")

== Wiring
3 main ports
- SCLK - shared clock
- MOSI - master out slave in
- MISO - master in slave out

#flashcard("What are the 3 main connections for SPI", "SLCK, MOSI, MISO")
#flashcard("What is SCLK", "Serial Clock")

#flashcard("What are the two main spi modes in relation to clock idle and read times", "clock idle low write on up, read on down; clock idle high; read on up")

// #flashcard("What is MOSI", "Master out slave in")
// #flashcard("What is MISO", "Master in slave out")
// 
To allow the master to talk to more than one device can have a SS line to select which slave is being talked to
#flashcard("What are the 4 main connections for SPI", "SLCK, MOSI, MISO, SS")

#flashcard("How do MOSI and MISO idle", "High")

#flashcard("What does SPI.format(x,y) do?", "bits per frame = x, mode = y")

#flashcard("What are the two quantities that make up SPI mode and how do they make the modes", "CPOL,CPHA mode would the the nth value")

#flashcard("What is CPOL in SPI", "Clock Polarity - how does the system idel on")
#flashcard("What is CHPA in SPI and what does 0 and 1 mean", "Clock Phase - 0 read on top, 1 read on bottom")



== Timings
Master initates transfer by driving the `SCLK` and then data is send one clock rise and read on the clock down clock frequency it's up to specific implementations SPI just specifies the wires rather than the whole communication standard it essentially is just the physical layer

#flashcard("Describe the start bit of SPI", "Clock Starts")
// #flashcard("Describe the timings of SPI", "Clock rising edge - write, clock falling edge - read")
#flashcard("Describe the stop bit of SPI", "Clock Stops")

== Advantages and Disadvantages
- Very fast as no overhead for stop and start bits and can putout a coninuous stream of data
- Have to have a chip select line for every device
- No hardware flow control - cannot know if message was recived
- No clocks needed on slaves

#flashcard("2 advantages of SPI", "Fast as little overhead; No clocks needed on slaves")
#flashcard("2 disadvateges of SPI", "Do not know if message recived; SS line for each slave")