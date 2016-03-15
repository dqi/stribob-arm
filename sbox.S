.data
# is it faster to align 1 or 4 and then multiply the registers?
.balign 1
sbox:
.byte 0x18
.byte 0x23
.byte 0xc6
.byte 0xe8

.text
.globl _start

_start:
ldr r6,=0x000000ff
# test
ldr r0,=0x00010203

# This piece of assembly (function?) does the following:
# r0 = 4 bytes to be sboxed
# r5 = 4 bytes sboxed
# we use r0-5, store result in r5

# Get the base sbox-address
ldr r1,=sbox

# Get the bytes out of r0
and r2,r6,r0
and r3,r6,r0, asr #8
and r4,r6,r0, asr #16
# the first register here is the one we return in
and r5,r6,r0, asr #24

# Result will be in r2, load the sboxvalue of the least significant byte directly into r2
ldrb r2,[r1,r2]

# Do the sbox for three more bytes
ldrb r3,[r1,r3]
ldrb r4,[r1,r4]
ldrb r5,[r1,r5]

# Get them into the return register r2, is this even needed? Is there clockcycle
# loss here since they all write to r2?

orr r2,r2,r3, lsl #8
orr r2,r2,r4, lsl #16
orr r2,r2,r5, lsl #24
# return r2
# store return in different registers? we would need 16 registers...
# maybe store some in registers and the rest in memory...
