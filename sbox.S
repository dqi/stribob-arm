.data
.balign 4
testvector:
.word 0x77, 0x38, 0xE1, 0xB5, 0x41, 0xA0, 0x36, 0xEA
.word 0x45, 0x8D, 0x50, 0xF8, 0x0F, 0xA0, 0x1C, 0x44
.word 0x72, 0x88, 0xCE, 0x97, 0xD1, 0xA0, 0xDC, 0xF0
.word 0x16, 0x95, 0xFF, 0xD6, 0xE7, 0x1D, 0x09, 0x25
.word 0x33, 0xBE, 0x30, 0x9F, 0x01, 0x2A, 0x59, 0x09
.word 0x72, 0x91, 0x14, 0x59, 0x5F, 0x08, 0x6E, 0x76
.word 0x07, 0x18, 0xAF, 0xE3, 0x65, 0xBC, 0x09, 0xDE
.word 0xB6, 0xAF, 0xA1, 0x80, 0xBC, 0xEC, 0x2A, 0x98
step1: .skip 256
sbox:
.word 0x18, 0x23, 0xC6, 0xE8, 0x87, 0xB8, 0x01, 0x4F, 0x36, 0xA6, 0xD2, 0xF5, 0x79, 0x6F, 0x91, 0x52
.word 0x60, 0xBC, 0x9B, 0x8E, 0xA3, 0x0C, 0x7B, 0x35, 0x1D, 0xE0, 0xD7, 0xC2, 0x2E, 0x4B, 0xFE, 0x57
.word 0x15, 0x77, 0x37, 0xE5, 0x9F, 0xF0, 0x4A, 0xDA, 0x58, 0xC9, 0x29, 0x0A, 0xB1, 0xA0, 0x6B, 0x85
.word 0xBD, 0x5D, 0x10, 0xF4, 0xCB, 0x3E, 0x05, 0x67, 0xE4, 0x27, 0x41, 0x8B, 0xA7, 0x7D, 0x95, 0xD8
.word 0xFB, 0xEE, 0x7C, 0x66, 0xDD, 0x17, 0x47, 0x9E, 0xCA, 0x2D, 0xBF, 0x07, 0xAD, 0x5A, 0x83, 0x33
.word 0x63, 0x02, 0xAA, 0x71, 0xC8, 0x19, 0x49, 0xD9, 0xF2, 0xE3, 0x5B, 0x88, 0x9A, 0x26, 0x32, 0xB0
.word 0xE9, 0x0F, 0xD5, 0x80, 0xBE, 0xCD, 0x34, 0x48, 0xFF, 0x7A, 0x90, 0x5F, 0x20, 0x68, 0x1A, 0xAE
.word 0xB4, 0x54, 0x93, 0x22, 0x64, 0xF1, 0x73, 0x12, 0x40, 0x08, 0xC3, 0xEC, 0xDB, 0xA1, 0x8D, 0x3D
.word 0x97, 0x00, 0xCF, 0x2B, 0x76, 0x82, 0xD6, 0x1B, 0xB5, 0xAF, 0x6A, 0x50, 0x45, 0xF3, 0x30, 0xEF
.word 0x3F, 0x55, 0xA2, 0xEA, 0x65, 0xBA, 0x2F, 0xC0, 0xDE, 0x1C, 0xFD, 0x4D, 0x92, 0x75, 0x06, 0x8A
.word 0xB2, 0xE6, 0x0E, 0x1F, 0x62, 0xD4, 0xA8, 0x96, 0xF9, 0xC5, 0x25, 0x59, 0x84, 0x72, 0x39, 0x4C
.word 0x5E, 0x78, 0x38, 0x8C, 0xD1, 0xA5, 0xE2, 0x61, 0xB3, 0x21, 0x9C, 0x1E, 0x43, 0xC7, 0xFC, 0x04
.word 0x51, 0x99, 0x6D, 0x0D, 0xFA, 0xDF, 0x7E, 0x24, 0x3B, 0xAB, 0xCE, 0x11, 0x8F, 0x4E, 0xB7, 0xEB
.word 0x3C, 0x81, 0x94, 0xF7, 0xB9, 0x13, 0x2C, 0xD3, 0xE7, 0x6E, 0xC4, 0x03, 0x56, 0x44, 0x7F, 0xA9
.word 0x2A, 0xBB, 0xC1, 0x53, 0xDC, 0x0B, 0x9D, 0x6C, 0x31, 0x74, 0xF6, 0x46, 0xAC, 0x89, 0x14, 0xE1
.word 0x16, 0x3A, 0x69, 0x09, 0x70, 0xB6, 0xD0, 0xED, 0xCC, 0x42, 0x98, 0xA4, 0x28, 0x5C, 0xF8, 0x86
mdsmatrix_1:
.word 0xa5a5b7ed
.word 0x124800
.word 0x49248012
.word 0x12492480

.text
    .syntax unified
    .globl _start

_start:
// Get the base sbox-address
ldr r13,=sbox
// test
ldr r0,=testvector
ldr r14,=step1

// This piece of assembly (function?) does the following:
// r0 pointer to 64 bytes to be sboxed
// at the end all the bytes will be sboxed in step1

////////////////////////////////////////////////////////////////////////////////
// Sbox 12 bytes, in 61 cycles
// Load 12 bytes to sbox (13 cycles)
ldr r1, [r0], #4
ldr r2, [r0], #4
ldr r3, [r0], #4
ldr r4, [r0], #4
ldr r5, [r0], #4
ldr r6, [r0], #4
ldr r7, [r0], #4
ldr r8, [r0], #4
ldr r9, [r0], #4
ldr r10, [r0], #4
ldr r11, [r0], #4
ldr r12, [r0], #4

// Multiply the offsets so we do not have to use byte offsets (ldrb) which would add two
// cycles. (Instead we can use word-align) (12 cycles)
lsl r1, #2
lsl r2, #2
lsl r3, #2
lsl r4, #2
lsl r5, #2
lsl r6, #2
lsl r7, #2
lsl r8, #2
lsl r9, #2
lsl r10, #2
lsl r11, #2
lsl r12, #2

// Do the sbox and store the bytes (3 cycles per byte, 36 total)
ldr r1, [r13,r1]
str r1, [r14], #4
ldr r2, [r13,r2]
str r2, [r14], #4
ldr r3, [r13,r3]
str r3, [r14], #4
ldr r4, [r13,r4]
str r4, [r14], #4
ldr r5, [r13,r5]
str r5, [r14], #4
ldr r6, [r13,r6]
str r6, [r14], #4
ldr r7, [r13,r7]
str r7, [r14], #4
ldr r8, [r13,r8]
str r8, [r14], #4
ldr r9, [r13,r9]
str r9, [r14], #4
ldr r10, [r13,r10]
str r10, [r14], #4
ldr r11, [r13,r11]
str r11, [r14], #4
ldr r12, [r13,r12]
str r12, [r14], #4
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Sbox 12 bytes, in 61 cycles
// Load 12 bytes to sbox (13 cycles)
ldr r1, [r0], #4
ldr r2, [r0], #4
ldr r3, [r0], #4
ldr r4, [r0], #4
ldr r5, [r0], #4
ldr r6, [r0], #4
ldr r7, [r0], #4
ldr r8, [r0], #4
ldr r9, [r0], #4
ldr r10, [r0], #4
ldr r11, [r0], #4
ldr r12, [r0], #4

// Multiply the offsets so we do not have to use byte offsets (ldrb) which would add two
// cycles. (Instead we can use word-align) (12 cycles)
lsl r1, #2
lsl r2, #2
lsl r3, #2
lsl r4, #2
lsl r5, #2
lsl r6, #2
lsl r7, #2
lsl r8, #2
lsl r9, #2
lsl r10, #2
lsl r11, #2
lsl r12, #2

// Do the sbox and store the bytes (3 cycles per byte, 36 total)
ldr r1, [r13,r1]
str r1, [r14], #4
ldr r2, [r13,r2]
str r2, [r14], #4
ldr r3, [r13,r3]
str r3, [r14], #4
ldr r4, [r13,r4]
str r4, [r14], #4
ldr r5, [r13,r5]
str r5, [r14], #4
ldr r6, [r13,r6]
str r6, [r14], #4
ldr r7, [r13,r7]
str r7, [r14], #4
ldr r8, [r13,r8]
str r8, [r14], #4
ldr r9, [r13,r9]
str r9, [r14], #4
ldr r10, [r13,r10]
str r10, [r14], #4
ldr r11, [r13,r11]
str r11, [r14], #4
ldr r12, [r13,r12]
str r12, [r14], #4
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Sbox 12 bytes, in 61 cycles
// Load 12 bytes to sbox (13 cycles)
ldr r1, [r0], #4
ldr r2, [r0], #4
ldr r3, [r0], #4
ldr r4, [r0], #4
ldr r5, [r0], #4
ldr r6, [r0], #4
ldr r7, [r0], #4
ldr r8, [r0], #4
ldr r9, [r0], #4
ldr r10, [r0], #4
ldr r11, [r0], #4
ldr r12, [r0], #4

// Multiply the offsets so we do not have to use byte offsets (ldrb) which would add two
// cycles. (Instead we can use word-align) (12 cycles)
lsl r1, #2
lsl r2, #2
lsl r3, #2
lsl r4, #2
lsl r5, #2
lsl r6, #2
lsl r7, #2
lsl r8, #2
lsl r9, #2
lsl r10, #2
lsl r11, #2
lsl r12, #2

// Do the sbox and store the bytes (3 cycles per byte, 36 total)
ldr r1, [r13,r1]
str r1, [r14], #4
ldr r2, [r13,r2]
str r2, [r14], #4
ldr r3, [r13,r3]
str r3, [r14], #4
ldr r4, [r13,r4]
str r4, [r14], #4
ldr r5, [r13,r5]
str r5, [r14], #4
ldr r6, [r13,r6]
str r6, [r14], #4
ldr r7, [r13,r7]
str r7, [r14], #4
ldr r8, [r13,r8]
str r8, [r14], #4
ldr r9, [r13,r9]
str r9, [r14], #4
ldr r10, [r13,r10]
str r10, [r14], #4
ldr r11, [r13,r11]
str r11, [r14], #4
ldr r12, [r13,r12]
str r12, [r14], #4
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Sbox 12 bytes, in 61 cycles
// Load 12 bytes to sbox (13 cycles)
ldr r1, [r0], #4
ldr r2, [r0], #4
ldr r3, [r0], #4
ldr r4, [r0], #4
ldr r5, [r0], #4
ldr r6, [r0], #4
ldr r7, [r0], #4
ldr r8, [r0], #4
ldr r9, [r0], #4
ldr r10, [r0], #4
ldr r11, [r0], #4
ldr r12, [r0], #4

// Multiply the offsets so we do not have to use byte offsets (ldrb) which would add two
// cycles. (Instead we can use word-align) (12 cycles)
lsl r1, #2
lsl r2, #2
lsl r3, #2
lsl r4, #2
lsl r5, #2
lsl r6, #2
lsl r7, #2
lsl r8, #2
lsl r9, #2
lsl r10, #2
lsl r11, #2
lsl r12, #2

// Do the sbox and store the bytes (3 cycles per byte, 36 total)
ldr r1, [r13,r1]
str r1, [r14], #4
ldr r2, [r13,r2]
str r2, [r14], #4
ldr r3, [r13,r3]
str r3, [r14], #4
ldr r4, [r13,r4]
str r4, [r14], #4
ldr r5, [r13,r5]
str r5, [r14], #4
ldr r6, [r13,r6]
str r6, [r14], #4
ldr r7, [r13,r7]
str r7, [r14], #4
ldr r8, [r13,r8]
str r8, [r14], #4
ldr r9, [r13,r9]
str r9, [r14], #4
ldr r10, [r13,r10]
str r10, [r14], #4
ldr r11, [r13,r11]
str r11, [r14], #4
ldr r12, [r13,r12]
str r12, [r14], #4
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Sbox 12 bytes, in 61 cycles
// Load 12 bytes to sbox (13 cycles)
ldr r1, [r0], #4
ldr r2, [r0], #4
ldr r3, [r0], #4
ldr r4, [r0], #4
ldr r5, [r0], #4
ldr r6, [r0], #4
ldr r7, [r0], #4
ldr r8, [r0], #4
ldr r9, [r0], #4
ldr r10, [r0], #4
ldr r11, [r0], #4
ldr r12, [r0], #4

// Multiply the offsets so we do not have to use byte offsets (ldrb) which would add two
// cycles. (Instead we can use word-align) (12 cycles)
lsl r1, #2
lsl r2, #2
lsl r3, #2
lsl r4, #2
lsl r5, #2
lsl r6, #2
lsl r7, #2
lsl r8, #2
lsl r9, #2
lsl r10, #2
lsl r11, #2
lsl r12, #2

// Do the sbox and store the bytes (3 cycles per byte, 36 total)
ldr r1, [r13,r1]
str r1, [r14], #4
ldr r2, [r13,r2]
str r2, [r14], #4
ldr r3, [r13,r3]
str r3, [r14], #4
ldr r4, [r13,r4]
str r4, [r14], #4
ldr r5, [r13,r5]
str r5, [r14], #4
ldr r6, [r13,r6]
str r6, [r14], #4
ldr r7, [r13,r7]
str r7, [r14], #4
ldr r8, [r13,r8]
str r8, [r14], #4
ldr r9, [r13,r9]
str r9, [r14], #4
ldr r10, [r13,r10]
str r10, [r14], #4
ldr r11, [r13,r11]
str r11, [r14], #4
ldr r12, [r13,r12]
str r12, [r14], #4
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Sbox 4 bytes, in 21 cycles
// Load 12 bytes to sbox (5 cycles)
ldr r1, [r0], #4
ldr r2, [r0], #4
ldr r3, [r0], #4
ldr r4, [r0], #4

// Multiply the offsets so we do not have to use byte offsets (ldrb) which would add two
// cycles. (Instead we can use word-align) (4 cycles)
lsl r1, #2
lsl r2, #2
lsl r3, #2
lsl r4, #2

// Do the sbox and store the bytes (3 cycles per byte, 12 total)
ldr r1, [r13,r1]
str r1, [r14], #4
ldr r2, [r13,r2]
str r2, [r14], #4
ldr r3, [r13,r3]
str r3, [r14], #4
ldr r4, [r13,r4]
str r4, [r14]
////////////////////////////////////////////////////////////////////////////////
// That should be 326 cycles for one sbox
// Lets get the 0th byte from r14-252
ldr r0, [r14, -252]!

// Let us bitslice this byte into r1-r8
// #1 bits in r1 starting at #31 are repleaced by #1 bits from r0 starting at
// bit[0]
// Using ASR in a smart way can probably save a few cycles, just mind the last
// one.
bfi r1,r0,#31,#1
asr r1, #4 // Copy the bit 4 times
lsr r0, #1 // Throw out the least significant bit we just bitsliced

bfi r2,r0,#31,#1
asr r2, #4
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #4
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #4
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #4
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #4
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #4
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #4
// now the 30-27 bit of r1-r8 contains the first byte bitsliced (so we have it 4
// times, and we will need this 4 times for the multiplication)

// Do this for seven more bytes:
// The columnshift means we need to get byte number 9 here
ldr r0, [r14, #36]

bfi r1,r0,#31,#1
asr r1, #4
lsr r0, #1

bfi r2,r0,#31,#1
asr r2, #4
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #4
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #4
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #4
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #4
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #4
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #4
// Do this for six more bytes:
// The columnshift means we need to get byte number 18 here
ldr r0, [r14, #72]

bfi r1,r0,#31,#1
asr r1, #4
lsr r0, #1

bfi r2,r0,#31,#1
asr r2, #4
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #4
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #4
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #4
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #4
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #4
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #4
// Do this for five more bytes:
// The columnshift means we need to get byte number 27 here
ldr r0, [r14, #108]

bfi r1,r0,#31,#1
asr r1, #4
lsr r0, #1

bfi r2,r0,#31,#1
asr r2, #4
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #4
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #4
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #4
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #4
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #4
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #4
// Do this for four more bytes:
// The columnshift means we need to get byte number 36 here
ldr r0, [r14, #144]

bfi r1,r0,#31,#1
asr r1, #4
lsr r0, #1

bfi r2,r0,#31,#1
asr r2, #4
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #4
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #4
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #4
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #4
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #4
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #4
// Do this for three more bytes:
// The columnshift means we need to get byte number 45 here
ldr r0, [r14, #180]

bfi r1,r0,#31,#1
asr r1, #4
lsr r0, #1

bfi r2,r0,#31,#1
asr r2, #4
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #4
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #4
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #4
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #4
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #4
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #4
// Do this for two more bytes:
// The columnshift means we need to get byte number 54 here
ldr r0, [r14, #216]

bfi r1,r0,#31,#1
asr r1, #4
lsr r0, #1

bfi r2,r0,#31,#1
asr r2, #4
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #4
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #4
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #4
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #4
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #4
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #4

// For the last byte the asr shift is only 3
// The columnshift means we need to get byte number 63 here
ldr r0, [r14, #252]

bfi r1,r0,#31,#1
asr r1, #3
lsr r0, #1

bfi r2,r0,#31,#1
asr r2, #3
lsr r0, #1

bfi r3,r0,#31,#1
asr r3, #3
lsr r0, #1

bfi r4,r0,#31,#1
asr r4, #3
lsr r0, #1

bfi r5,r0,#31,#1
asr r5, #3
lsr r0, #1

bfi r6,r0,#31,#1
asr r6, #3
lsr r0, #1

bfi r7,r0,#31,#1
asr r7, #3
lsr r0, #1

bfi r8,r0,#31,#1
asr r8, #3
// One vector bitsliced into r1-r8, next up bitslicing the matrix into
// r9,10,11,12, they use low weight matrix so it fits in four registers :),
// be sure to take bytes per row (so first four bytes are from the first row)

// first row is 01 01 04 01... actually these are constants which we can load
// from somewhere
ldr r0,=mdsmatrix_1
ldr r9,[r0]
ldr r10, [r0,#4]
ldr r11, [r0,#8]
ldr r12, [r0,#12]

// Time for some finite field multiplication
// r14: points to sboxed bytes
// r0: points to mdsmatrix
// r13: pointer to base of sbox
// r1-12 bitsliced polynomials
