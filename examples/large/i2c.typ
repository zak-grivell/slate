#import "vault.typ":*
#show: setup
#tag("embedded")

= I2C
A communications protocol is syncronous

#flashcard("Is I2C async or syncronous", "syncronous")
#flashcard("Is I2C ptp or master slave", "master slave")
#flashcard("Is I2C simplex, duplex or half-duplex", "half-duplex")

== Wiring
Two wires both idle high
- SDA - data wire
- SCL - clock wire

#flashcard("What are the two wires in I2C", "SDA, SCL")

#flashcard("What is SDA", "Serial Data")
#flashcard("What is SCL", "Serial Clock")

#flashcard("How does SDA idle", "high")
#flashcard("How does SCL idle", "high")
#flashcard("How do the lines in I2C idle high", "Pull up resistor")

Very simple two wires can communicate with many devices

== Timings
Same as #note("./spi.typ") on clock rise read, on clock fall write

#flashcard("When does reading and writing happen in I2C", "Read on clock rise, write on clock fall")

As writing is only meant to happen when the clock is low, a start is identified by data-line falling when the clock is high and conversly stops bit is low to high when clock is high

#flashcard("What is the state of the clock when writing I2C", "Low")
#flashcard("What identifies the start in I2C", "SDA goes low when SCL is high")
#flashcard("What identifies the end in I2C", "SDA goes high when SCL is high")

Structure is 8 bits, wait for acknolegement repeat. Sender releases SDA line after it is done and the reciver should pull down on next clock cycle most significant bit first

#flashcard("Is I2C most or least significant bit first", "Most")
#flashcard("How many bits are sent per cycle in I2C", "a byte")

The first 8 bits are a 7 bit address and a read/write bit $R\/overline(W)$

Reading is requesting data to be send from the slave and writing is sending data to the slave

#table(columns: (1fr, 1fr, 7fr, 1fr, 8fr, 1fr),
[S],
$R\/overline(W)$,
[Address],
[Ak],
[Data],
[P],
)

#flashcard("Describe the ack bit in I2C", "After 8 data bits sender lets go of SDA and the reciver pulls down SDA as a acknolagement")

#flashcard("Describe the sections of an I2C communication", "1 start, then 8 bit one ack pairs until stop first section is 1 Read write, 7 address, ak then it is just a byte at a time")

#flashcard("What does a 0 and 1 mean for the read write bit for I2C", "0 means write, 1 means read")
#flashcard("What is the adress space for I2C", "$2^7$")

== Advantags and Disadvantages
- Only two wires for many many devices
- Know if the reciver actually recived
- Not efficentas have to send address and ack 

#flashcard("2 advantages of I2C", "Only two wires and get feedback from ACK")
#flashcard("Disadvantage of I2C", "In efficent as adress and ack bits take up time")