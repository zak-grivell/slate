#import "vault.typ": *;
#show: setup
#tag("embedded")

= Memory
Ram - random acess memory
  - DRAM - dynamic ram - capacitors storing charge that get refreshed
  - SRAM - latches like registers - big but fast

Rom - read only memory
  - ROM - Factory Programmed
  - PROM - User programmable
  - EEPROM - User programmable and erasable
  - FLASH - like EEPROM but can be written in blocks

#flashcard("Difference between ram and rom", "Write to ram speedily but loose data when powered off")
#flashcard("What are the two types of ram and thier differences", "DRAM - capacitors have to refresh and slower but very small - main memory, SRAM larger but speedy - cache")
#flashcard("Four types of ROM", "Factory, PROM, EEPROM, FLASH")
#flashcard("What is Factory ROM", "Written to at factory and cannot be changed")
#flashcard("What is PROM", "User programmable ROM")
#flashcard("What is EEPROM", "User programmable and erasable ROM")
#flashcard("What is flash", "EEPROM but in blocks")

== Addressing
Memory is a separate component that the processor will connect to but how to address so many blocks of memory? The memory will get an address from the processor but how to write it to the correct place

The number of address lines we can address is $2^n$ where n is the number of address lines.

Generally ram is made up of multiple sets of $2^n$ memory banks

#let pins = (
    (content: "addr[0..n]", side: "west"),
    (side: "west"),
    (side: "west"),
    (content: $overline(R) \/ W$, side: "west"),
    // (content: "AVCC", side: "west"),
    (side: "west"),
    (content: "inout[0..n]", side: "west"),
    // ...
)

#circuit({
    import zap: *

    mcu("mcu", (3, 0), pins: pins)
})

These can be combined with a decoder to combine multiple memory blocks into one accessible by the processor

#flashcard("What component is used to split up an adress into chip select signals", "Decoder")

Best way to do it is in rows and columns to spread out where your data is to even out the load on the chips

== Timings

Read:
- Find desired address
- Ensure read is high
- Push chip select
- Wait for clock edge 


#flashcard("What is DDR RAM", "Double data rate ram")
#flashcard("How does DDR RAM work", "Put out value on up tick and bottom tick to improve speed")

#flashcard("Why is doing a 2d grid of ram faster", "Scales better as 10 bit would have 2^10 wires wheras with 2 2%5 it becomes 2^6")

== Timings

#flashcard("When reading/writing from ram what is the order of operations and why", "Set address wait as takes time to propogate through decoders; have RW bit corrrect; get from databus or put on databus")

#flashcard("Why is there a required delay after setting memory address", "As time to propogate through decoders")

#flashcard("What is DRAM refresh", "Refreshing the capacttors in dram cells as small leak current drains slowly")
