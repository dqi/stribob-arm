// Macro's

// sboxall: combine sbox12 and sbox4 to do a whole sbox

// sbox12: when inserted r13 points at sbox, r14 at storage for the result of the
// sbox and r0 at the input data. in and output are words. sbox8 uses r0-r12 for
// variables

// sbox4: when inserted r13 points at sbox, r14 at storage for the result of the
// sbox and r0 at the input data. in and output are words. sbox4 uses r0-r4 for
// variables

// bitslice: combine bitslice 4&3 to bitslice a vector, the 8 arguments should be such
// that the shiftcolumns is done (please remember: it shifts down not up)

// bitslice4,3: when inserted r14 points at the base of sboxed bytes, it will
// bitslice the lsb of the byte at r14+arg0 into r1-r8 and asr #4 to copy it 4,3 times, it
// will also throw out the lsb in r0 so this can be inserted in succesion to
// bitslice the full byte

// loadmultresult: loads r1-r8 with bitsliced polynomials

// bitslicedmult: when inserted r13 points to an area of memory where we can
// store 10 polynomials, there should be bitsliced poynomials in r1-r12, with
// r9,r10,r11,r12 being the polynomials from the bitsliced matrix;
// calculations are done with r0 and r14.

// unbitslice: when inserted r13 points to bitsliced polynomials, it will
// unbitslice 8 polynomials stored there into r0 and store the byte at r9. uses
// r1-r8 for unbitslicing

// getbyte0-7: gets the 8 bytes from the i'th column from the multiplyresult, xors
// them together and stores them at r10 and then increases r10.

// getbytes: call getbyte0-7 in order to store the 8 bytes we have ready after two
// matrix multiplications

.macro onevector arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, r10offset
// Bitslice the bytes
// Bitslice byte 0
// r13 points to the base of the sboxed bytes, same each round
bitslice \arg0, \arg1, \arg2, \arg3, \arg4, \arg5, \arg6, \arg7
// Lets get the 0th byte from r14-252
add r13,r13,#1280
// r13 points at mds1 now
loadmds1
add r13,r13,#32
// r13 points at polynomials1 now
bitslicedmult
add r13,r13,#-16
// r13 points at mds2 now
loadmds2
add r13,r13,#56
// r13 points at polynomials2 now
bitslicedmult
add r13,r13,#-40
// r13 points at polynomials1 now
add r9,r13,#80
// Make sure r0[31:8 is empty]
eor r0,r0,r0
// We shall store these 64 bytes at r9 = unbitslicestore
loadmultresult
unbitslice32times
// 32 Bytes unbitsliced, now the r2 stored at polynomials2
add r13,r13,#40
// r13 points to polynomials2
loadmultresult
unbitslice32times
add r9,r9,#-256
add r10,r9,#\r10offset
// r9 points to unbitslicestore
// r10 points to testvector, so we can store the round,
// this will be a different number each round
getbytes
// 8 bytes done
// get r13 ready for another vector
add r13,r13,#-1352
// ----
.endm

.macro sboxall
sbox12
sbox12
sbox12
sbox12
sbox12
sbox4
.endm

.macro bitslice arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7
bitslice4 \arg0
bitslice4 \arg1
bitslice4 \arg2
bitslice4 \arg3
bitslice4 \arg4
bitslice4 \arg5
bitslice4 \arg6
bitslice3 \arg7
.endm

.macro loadmultresult
// Load the multiplication result in the registers
ldr r1,[r13]
ldr r2,[r13,#4]
ldr r3,[r13,#8]
ldr r4,[r13,#12]
ldr r5,[r13,#16]
ldr r6,[r13,#20]
ldr r7,[r13,#24]
ldr r8,[r13,#28]
.endm

.macro getbytes
getbyte0
getbyte1
getbyte2
getbyte3
getbyte4
getbyte5
getbyte6
getbyte7
.endm

.macro getbyte7
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9,#140]
ldr r1, [r9,#156]
ldr r2, [r9,#172]
ldr r3, [r9,#188]
ldr r4, [r9,#204]
ldr r5, [r9,#220]
ldr r6, [r9,#236]
ldr r7, [r9,#252]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro getbyte6
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9,#136]
ldr r1, [r9,#152]
ldr r2, [r9,#168]
ldr r3, [r9,#184]
ldr r4, [r9,#200]
ldr r5, [r9,#216]
ldr r6, [r9,#232]
ldr r7, [r9,#248]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro getbyte5
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9,#132]
ldr r1, [r9,#148]
ldr r2, [r9,#164]
ldr r3, [r9,#180]
ldr r4, [r9,#196]
ldr r5, [r9,#212]
ldr r6, [r9,#228]
ldr r7, [r9,#244]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro getbyte4
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9,#128]
ldr r1, [r9,#144]
ldr r2, [r9,#160]
ldr r3, [r9,#176]
ldr r4, [r9,#192]
ldr r5, [r9,#208]
ldr r6, [r9,#224]
ldr r7, [r9,#240]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro getbyte3
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9,#12]
ldr r1, [r9,#28]
ldr r2, [r9,#44]
ldr r3, [r9,#60]
ldr r4, [r9,#76]
ldr r5, [r9,#92]
ldr r6, [r9,#108]
ldr r7, [r9,#124]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro getbyte2
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9,#8]
ldr r1, [r9,#24]
ldr r2, [r9,#40]
ldr r3, [r9,#56]
ldr r4, [r9,#72]
ldr r5, [r9,#88]
ldr r6, [r9,#104]
ldr r7, [r9,#120]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro getbyte1
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9,#4]
ldr r1, [r9,#20]
ldr r2, [r9,#36]
ldr r3, [r9,#52]
ldr r4, [r9,#68]
ldr r5, [r9,#84]
ldr r6, [r9,#100]
ldr r7, [r9,#116]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm
.macro getbyte0
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r9]
ldr r1, [r9,#16]
ldr r2, [r9,#32]
ldr r3, [r9,#48]
ldr r4, [r9,#64]
ldr r5, [r9,#80]
ldr r6, [r9,#96]
ldr r7, [r9,#112]
// Eor them into r0
eor r0,r0,r1
eor r0,r0,r2
eor r0,r0,r3
eor r0,r0,r4
eor r0,r0,r5
eor r0,r0,r6
eor r0,r0,r7
// store r0 at r10 = testvector
str r0,[r10],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro unbitslice32times
////////////////////////////////////////////////////////////////////////////////
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
unbitslice
////////////////////////////////////////////////////////////////////////////////
.endm
.macro unbitslice
////////////////////////////////////////////////////////////////////////////////
// Unslice one byte
bfi r0,r1,#0,#1
bfi r0,r2,#1,#1
bfi r0,r3,#2,#1
bfi r0,r4,#3,#1
bfi r0,r5,#4,#1
bfi r0,r6,#5,#1
bfi r0,r7,#6,#1
bfi r0,r8,#7,#1
// Throw the unbitsliced byte out
lsr r1,#1
lsr r2,#1
lsr r3,#1
lsr r4,#1
lsr r5,#1
lsr r6,#1
lsr r7,#1
lsr r8,#1
// Store the byte and increase r9
str r0,[r9],#4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro bitslicedmult
////////////////////////////////////////////////////////////////////////////////
// 10th degree
and r0,r8,r12
str r0,[r13,#40]
// 9th degree
and r0,r8,r11
and r14,r7,r12
eor r0,r0,r14
str r0,[r13,#36]
// 8th degree
and r0,r8,r10
and r14,r7,r11
eor r0,r0,r14
and r14,r6,r12
eor r0,r0,r14
str r0,[r13,#32]
// 0th degree, because 8th degree is still in r0 we do not load it this time
and r14,r1,r9
eor r0,r0,r14
str r0,[r13]
// 1st degree
ldr r0,[r13,#36]
and r14,r1,r10
eor r0,r0,r14
and r14,r2,r9
eor r0,r0,r14
str r0,[r13,#4]
// 2nd degree
ldr r0,[r13,#32]
ldr r14,[r13,#40]
eor r0,r0,r14
and r14,r1,r11
eor r0,r0,r14
and r14,r2,r10
eor r0,r0,r14
and r14,r3,r9
eor r0,r0,r14
str r0,[r13,#8]
// 3th degree
ldr r0,[r13,#32]
ldr r14,[r13,#36]
eor r0,r0,r14
and r14,r1,r12
eor r0,r0,r14
and r14,r2,r11
eor r0,r0,r14
and r14,r3,r10
eor r0,r0,r14
and r14,r4,r9
eor r0,r0,r14
str r0,[r13,#12]
// 4th degree
ldr r0,[r13,#32]
ldr r14,[r13,#36]
eor r0,r0,r14
ldr r14,[r13,#40]
eor r0,r0,r14
and r14,r2,r12
eor r0,r0,r14
and r14,r3,r11
eor r0,r0,r14
and r14,r4,r10
eor r0,r0,r14
and r14,r5,r9
eor r0,r0,r14
str r0,[r13,#16]
// 5th degree
ldr r0,[r13,#40]
ldr r14,[r13,#36]
eor r0,r0,r14
and r14,r3,r12
eor r0,r0,r14
and r14,r4,r11
eor r0,r0,r14
and r14,r5,r10
eor r0,r0,r14
and r14,r6,r9
eor r0,r0,r14
str r0,[r13,#20]
// 6th degree
ldr r0,[r13,#40]
and r14,r4,r12
eor r0,r0,r14
and r14,r5,r11
eor r0,r0,r14
and r14,r6,r10
eor r0,r0,r14
and r14,r7,r9
eor r0,r0,r14
str r0,[r13,#24]
// 7th degree
and r0,r5,r12
and r14,r6,r11
eor r0,r0,r14
and r14,r7,r10
eor r0,r0,r14
and r14,r8,r9
eor r0,r0,r14
str r0,[r13,#28]
////////////////////////////////////////////////////////////////////////////////
.endm

.macro sbox12
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
.endm

.macro sbox4
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
.endm

.macro bitslice4 arg0:req
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r13,#\arg0]

bfi r1,r0,#31,#1
lsr r0, #1 // Throw out the least significant bit we just bitsliced
bfi r2,r0,#31,#1
lsr r0, #1
bfi r3,r0,#31,#1
lsr r0, #1
bfi r4,r0,#31,#1
lsr r0, #1
bfi r5,r0,#31,#1
lsr r0, #1
bfi r6,r0,#31,#1
lsr r0, #1
bfi r7,r0,#31,#1
lsr r0, #1
bfi r8,r0,#31,#1

asr r1, #4 // Copy the bit 4 times
asr r2, #4
asr r3, #4
asr r4, #4
asr r5, #4
asr r6, #4
asr r7, #4
asr r8, #4
////////////////////////////////////////////////////////////////////////////////
.endm

.macro bitslice3 arg0:req
////////////////////////////////////////////////////////////////////////////////
ldr r0, [r13,#\arg0]

bfi r1,r0,#31,#1
lsr r0, #1
bfi r2,r0,#31,#1
lsr r0, #1
bfi r3,r0,#31,#1
lsr r0, #1
bfi r4,r0,#31,#1
lsr r0, #1
bfi r5,r0,#31,#1
lsr r0, #1
bfi r6,r0,#31,#1
lsr r0, #1
bfi r7,r0,#31,#1
lsr r0, #1
bfi r8,r0,#31,#1
asr r1, #3
asr r2, #3
asr r3, #3
asr r4, #3
asr r5, #3
asr r6, #3
asr r7, #3
asr r8, #3
////////////////////////////////////////////////////////////////////////////////
.endm

.macro loadmds1
////////////////////////////////////////////////////////////////////////////////
ldr r9,[r13]
ldr r10, [r13,#4]
ldr r11, [r13,#8]
ldr r12, [r13,#12]
////////////////////////////////////////////////////////////////////////////////
.endm

.macro loadmds2
////////////////////////////////////////////////////////////////////////////////
ldr r9,[r13]
ldr r10, [r13,#4]
ldr r11, [r13,#8]
ldr r12, [r13,#12]
////////////////////////////////////////////////////////////////////////////////
.endm

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
.word 0x5a5ade7b
.word 0x842100
.word 0x29421084
.word 0x84294210
mdsmatrix_2:
.word 0xde7b5a5a
.word 0x21000084
.word 0x10842942
.word 0x42108429
// Here we will store the bitsliced polynomial results from the matrix
// multiplication. Offset 0 = x^0, offset 40 = x^10
polynomials:
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
// Same for another 32 10th-degree polynomials
polynomials2:
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
unbitslicestore: .skip 256
roundresult: .skip 256

.text
    .syntax unified
    .globl _start
_start:
// Get the base sbox-address
ldr r13,=sbox
ldr r0,=testvector
ldr r14,=step1

// Sbox the bytes
sboxall
// That should be 326 cycles for one sbox
.ltorg
// correct r13 to be pointing to the start of sboxed bytes (=step1)
add r13,r13,#-256

onevector 0,228,200,172,144,116,88,60,256
onevector 32,4,232,204,176,148,120,92,288
onevector 64,36,8,236,208,180,152,124,320
onevector 96,68,40,12,240,212,184,156,352
onevector 128,100,72,44,16,244,216,188,384
onevector 160,132,104,76,48,20,248,220,416
onevector 192,164,136,108,80,52,24,252,448
onevector 224,196,168,140,112,84,56,28,480
// EOR 8 words starting at r10-0x100
nop

