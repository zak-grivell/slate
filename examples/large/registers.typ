#import "vault.typ":*
#show: setup
#tag("embedded")

= Registers
RAM is slow as hell. We don't want to be waiting for slow RAM reads to do quick operations why not registers on the CPU that have the current values being worked on, there are generally not many of these sometimes even only 16

They simply hold their value and each clock cycle the ALU operation can take two registers as input and output to another, or one of the source, register