.data
.balign 4
test:
.word 0x00010203
.word 0x04050607
.balign 1
sbox:
.byte 0x18
.byte 0x23
.byte 0xc6
.byte 0xe8
.byte 0x87
.byte 0xb8
.byte 0x01
.byte 0x4f

.text
.globl _start

_start:
ldr r9,=0x000000ff
# Get the base sbox-address
ldr r12,=sbox
# test
ldr r0,=test

# This piece of assembly (function?) does the following:
# r0 pointer to 64 bytes to be sboxed
# at the end all the bytes will be sboxed

# This is one block, it sbox-es 8 bytes
# Get 4 bytes into r10, and 4 into r11
ldrd r10, r11,[r0]

# Get the bytes out of r10
and r1,r9,r10
and r2,r9,r10, asr #8
and r3,r9,r10, asr #16
and r4,r9,r10, asr #24

# Also get the bytes from r11
and r5,r9,r11
and r6,r9,r11, asr #8
and r7,r9,r11, asr #16
and r8,r9,r11, asr #24

# Do sbox-ing
# For r10
ldrb r10,[r12,r1]
ldrb r2,[r12,r2]
ldrb r3,[r12,r3]
ldrb r4,[r12,r4]

# For r11
ldrb r11,[r12,r5]
ldrb r6,[r12,r6]
ldrb r7,[r12,r7]
ldrb r8,[r12,r8]

# Construct r10 from the bytes
orr r10,r10,r2, lsl #8
orr r10,r10,r3, lsl #16
orr r10,r10,r4, lsl #24

# Construct r11 from the bytes
orr r11,r11,r6, lsl #8
orr r11,r11,r7, lsl #16
orr r11,r11,r8, lsl #24

# Store to memory
strd r10,r11,[r0]!
