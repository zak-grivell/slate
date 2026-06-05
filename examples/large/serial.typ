#import "vault.typ":*
#show: setup
#tag("embedded")

= Serial Communication
Way of device communicating with others
- #note("./uart.typ")
- #note("./spi.typ")
- #note("./i2c.typ")

== Asyncronous vs Syncronous
Asyncronous does not share a clock line reducing the number of wires but then requires the communication rate to be the same

#flashcard("Difference between asyncronous and syncronous communication", "Async does not share clock line")
#flashcard("Advantages and disadvantes of asyncronous and syncronous communication", "Less wires for async but have to share baud rate")

== Peer to Peer vs Master to Slave
Peer to peer requires no set relationship between devices this generall means is one to one at a time compared to master slave which can share wires and one is in charge of all

#flashcard("Difference between master slave and peer to peer communication", "Master slave fixed heiarchy")

== Types
- Simplex - One way only
- Half Duplex - Both ways but not same time
- Full Duplex - Both ways at same time

#flashcard("What is Simplex Communication", "One way only")
#flashcard("What is Half Duplex Communication", "Both ways but not at same time")
#flashcard("What is Full Duplex Communication", "Both ways at same time")

== Timings
To syncronise generall have a start 'bit' or 'condiditon'

#flashcard("What are the purpose of start and end bits", "Syncronisation")

#flashcard("What is a frame in SPI", "The number of bits making up one value")