# Load-Store Instructions

ARM uses load-store instructions, like LDR (load) and STR (store), to move data
between memory and registers. 

## Bit size

Bit size allows the CPU to address memory for an individual process.

X-bit can handle $2^X$ bytes of memory.

The higher the bit size, the higher performance.

## Frequently used Load/Store Instructions

| LOAD | STORE | Size and Type |
|---|---|---|
| LDR   | STR   | 32-bits           |
| LDRB  | STRB  | 8-bits (byte)     |
| LDRH  | STRH  | 16-bits(Halfword) |
| LDRSB |       | Signed byte       |
| LDRSH |       | Signed halfword   |
| LDM   | SDM   | Multiple words    |


Load: Take value from memory write to register
- `LDR {size} {cond} <Rd>, <addressing_mode>`

Store: Read value from register write to memory
- `STR {size} {cond} <Rd>, <addressing_mode>`

### Example 

The `LDRH r1, [r0]` instruction in ARM assembly loads a halfword (16 bits) from
memory into a register.

Example:

Consider the following scenario:
- Register r0 contains the memory address 0x20008000.
- The memory location at 0x20008000 contains the byte 0xEF.
- The memory location at 0x20008001 contains the byte 0xCD.
- Register r1 initially contains 0x12345678.

When the instruction `LDRH r1, [r0]` is executed:
- The processor reads the 16-bit halfword from the memory address specified by
r0, which is 0x20008000.
- Assuming a little-endian system, the halfword at 0x20008000 would be 0xCDEF
(byte 0xEF at 0x20008000 and byte 0xCD at 0x20008001).
- This 16-bit value (0xCDEF) is then loaded into the lower 16 bits of r1.
- The upper 16 bits of r1 are cleared (zero-extended) to ensure the entire
32-bit register is correctly populated.

Therefore, after the execution of `LDRH r1, [r0]`, the value in r1 would become
0x0000CDEF.

### Example 2

```
LDR     r5, [r3]            ; load r5 with data from ea<r3>
STRB    r0, [r9]            ; store data in r0 to ea<r9>
STR     r3, [r9, r5, LSL#3] ; store data in r3 to ea<r8 +(r5<<3)>
LDR     r1, [r0, #4]!       ; load r1 from ea<r0+4>, r0 = r0 + 4
STRB    r7, [r6,#-1]!       ; store byte to ea<r6-1>, r6=r6-1
LDR     r3, [r9], #4        ; load r3 from ea<r9>, r9 = 9+4
STR     r1, [r5], #8        ; store word to ea<r5>, r5 = r5+8
```

`ea` means Effective Address.

## Indexing

ARM assembly includes addressing modes for load and store instructions that
involve automatically updating a base register, known as pre-indexing and
post-indexing. These modes are particularly useful for iterating through data
structures or memory blocks.

### Pre-indexed Addressing:

In pre-indexed addressing with write-back, the offset is added to (or subtracted
from) the base register before the memory access occurs. The resulting address
is then used for the load or store operation, and the base register is updated
with this new address. This is indicated by an exclamation mark (!) after the
instruction's address operand.

```
LDR     R0, [R1, #4]!           ; R1 = R1 + 4; then R0 = Memory[R1]
STR     R0, [R1, R2, LSL #2]!   ; R1 = R1 + (R2 << 2); then Memory[R1] = R0
```

### Post-indexed Addressing:

In post-indexed addressing, the value of the base register alone is used as the
memory address for the load or store operation. After the data transfer, the
offset is added to (or subtracted from) the base register, and the result is
written back into the base register. This is indicated by placing the offset
outside the square brackets of the address operand.

```
LDR     R0, [R1], #4            ; R0 = Memory[R1]; then R1 = R1 + 4
STR     R0, [R1], R2, LSL #2    ; Memory[R1] = R0; then R1 = R1 + (R2 << 2)
```

## Endianness

Refers to the order in which bytes are stored in a computer's memory for
multi-byte data types. There are two types: big-endian, where the most
significant byte (the "big end") is stored at the lowest memory address, and
little-endian, where the least significant byte (the "little end") is stored at
the lowest address. This byte order is crucial for network communication and
data sharing, as a mismatch between systems can cause data corruption. 

**Big-endian**
- The most significant byte comes first.

**Little-endian**
- The least significant byte comes first.

## Defining Memory Areas

In ARM assembly, the DCD (Define Constant Data) directive is used to allocate
one or more 32-bit words of memory and define their initial contents at runtime.
These words are always aligned on 4-byte boundaries.

```
my_data DCD     1, 5, 20            ; Defines 3 words containing decimal values 1, 5, and 20
        DCD     0xDEADBEEF          ; Defines a word containing the hexadecimal value DEADBEEF
        DCD     my_label + 4        ; Defines a word containing the address of my_label plus 4 bytes
```
