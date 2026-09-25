# Arithmetic and Logic Instruction

ARM assembly language includes a comprehensive set of arithmetic and logic
instructions for manipulating data within registers. These instructions are
fundamental for performing computations and controlling program flow.

## Flags

In ARM assembly, there are four condition code flags (N, Z, C, V) found in the
Application Program Status Register (APSR) or Program
Status Register (PSR). These flags are updated by arithmetic and logical
operations, particularly when the 'S' suffix is used with an instruction (e.g.,
ADDS, SUBS, ANDS). They are crucial for conditional execution and branching
based on the result of an operation.

### N Flag (Negative Flag):

- The N flag is set to 1 when the result of an operation, interpreted as a
signed two's-complement integer, is negative. 
- It is cleared to 0 if the result is positive or zero. 
- Essentially, the N flag reflects the most significant bit (MSB) of the result:
if the MSB is 1, the N flag is 1; if the MSB is 0, the N flag is 0.

### V Flag (Overflow Flag):

- The V flag is set to 1 when an arithmetic operation on signed numbers results
in an overflow.
- Signed overflow occurs when the result of an operation is too large to be
represented in the available number of bits for a signed integer, causing the
sign bit to be incorrectly set.
- For example, adding two positive numbers might result in a negative number if
overflow occurs, or adding two negative numbers might result in a positive
number.
- The V flag is cleared to 0 if no signed overflow occurs.

### C flag (Carry)

- For unsigned arithmetic. It signals an "unsigned overflow".
- Addition: Set to 1 if an addition produces a carry out of the most significant
bit (i.e., the result is too large to fit in 32 bits).
- Subtraction: Set to 1 if there is no borrow. This is equivalent to A - B
without a borrow, which means A is greater than or equal to B in unsigned terms.
- Logical Shift: Can be updated by a bit shifted out of the register. 

### Z flag (Zero)

- To check for a zero result.
- Condition: Set to 1 if the result of an operation is zero.
- Condition: Cleared to 0 otherwise.
- Example: After comparing two equal values, or after decrementing a value to zero. 

## Comparison Instructions

ARM assembly uses several instructions for comparing values and setting
condition flags in the Current Program Status Register (CPSR), which are then
used by conditional branch instructions. These comparison instructions do not
store a result in a register; their primary purpose is to update the condition
flags.

- **CMP (Compare):** This instruction subtracts the second operand from the first
and updates the condition flags (N, Z, C, V) in the CPSR based on the result. It
is functionally similar to a SUBS instruction where the result is discarded.

- **CMN (Compare Negative):** This instruction adds the second operand to the first
and updates the condition flags based on the result. It is functionally similar
to an ADDS instruction where the result is discarded. This is useful for
comparing a register with a negative value.

- **TST (Test):** This instruction performs a bitwise AND operation between two
operands and updates the N and Z flags based on the result. It is used to check
if specific bits are set in a register.

- **TEQ (Test Equivalence):** This instruction performs a bitwise XOR operation
between two operands and updates the N and Z flags based on the result. It is
used to check for equality of two values, as the Z flag will be set if the XOR
result is zero.

**MRS (Move to Register from Special Register)** and
**MSR (Move from Register to Special Register)** are used to move data between a
general-purpose register and a special-purpose register, like the Program
Status Register (PSR).  MRS copies the value from a special register to a
general-purpose register, while MSR copies a value from a general-purpose
register to a special register.  These instructions are essential for reading
and modifying processor state, such as condition flags, though their usage is
restricted by processor mode and privilege level. 

E.g:

```
MRS r0, CPSR
MRS r1, SPSR
```

```
CMP r8, #0 ; r = =0?
BEQ routine ; yes, then go to my routine
TST r4, r3 ; r * 3 = 0xC0000000 to test bits 31, 30
TEQ r9, r4, LSL #3
```

```
MRS r3, APSR ; read flag information into r3
MSR APSR, r2 ; write to just the flags
MSR PSR, r7  ; write all status information to r7
```

**What sets N, Z, C, V flags?**

1. Flag setting and clearing instructions TST or CMP
2. Explicit flag setting instructions i.e. instructions ending in S e.g. ADDS, SUBS
3. Direct write to PSR to explicitly set or clear flags
4. 16-bit Thumb ALU instruction

## Boolean Operations

ARM assembly uses specific instructions to perform bitwise logical operations
that can be used to implement boolean logic. These instructions operate on the
individual bits of registers, treating them as boolean values (0 for false, 1
for true).

- AND: Performs a bitwise logical AND operation.
- ORR: Performs a bitwise logical OR operation.
- EOR: Performs a bitwise logical Exclusive OR (XOR) operation.
- BIC: Performs a Bit Clear operation. This is equivalent to Rd = Rn AND NOT Operand2.

```
MOVN r5, #0     ; r5 = -1 in two's complement
AND r1, r2, r3  ; r1 = r2 AND r3
ORR r1, r2, r3  ; r1 = r2 OR r3
EOR r1, r2, r3  ; r1 = r2 exclusive OR r3
BIC r1, r2, r3  ; r1 = r2 AND NOT 3
```

## Shifts and Rotations

ARM assembly includes shift (LSL, LSR, ASR) and rotate (ROR, RRX) instructions
to manipulate bits within a register. Shifts move bits left or right, dropping
bits from one end and filling with zeros (logical) or the sign bit (arithmetic).
Rotations, however, move bits off one end and insert them on the opposite end,
wrapping the bits around. 

### Shifts

- **Logical Shift Left (LSL):** Shifts bits to the left. Zeros are shifted in from
the right, and the most significant bit is shifted into the carry flag. This
operation is equivalent to multiplying by 2.
- **Logical Shift Right (LSR):** Shifts bits to the right. Zeros are shifted in
from the left, and the least significant bit is shifted into the carry flag.
This is equivalent to unsigned division by 2.
- **Arithmetic Shift Right (ASR):** Shifts bits to the right. The sign bit (most
significant bit) is copied and shifted in from the left. This preserves the sign
of the number and is used for signed division by 2. 

### Rotations

- **Rotate Right (ROR):** Shifts bits to the right, but the bits shifted off the
right end are wrapped around and inserted into the leftmost position.
- **Rotate Right with Extend (RRX):** Shifts bits to the right by one position.
The bit shifted off the right end is shifted into the carry flag, and the value
of the carry flag is inserted into the leftmost position. 

### Examples

```
LSL r4, r6, #4  ; r4 = r6 << 4 bits
LSL r4, r6, r3  ; r4 = r6 << # specified in r3
ROR r4, r6, #12 ; r4 = r6 rotated right 12 bits
                ; r4 = ró rotated left 20 bits
```

```
LSR ro, r2, #224        ; extract top byte from R2 into RO
ORR r3, ro, r3, LSL #8  ; shift up r3 and insert r0
```

## Basic Addition and Subtraction

```
ADD r1, r2, r3  ; r1 = r2 + r3
ADC r1, r2, r3  ; r1 = r2 + r3 + C
SUB r1, r2, r3  ; r1 = r2 - r3
SUBC r1, r2, r3 ; r1 = r2 - r3 + C - 1
RSB r1, r2, r3  ; r1 = r3 -r2
RSC r1, r2, r3  ; r1 = r3 - r2 + C - 1
```

**Adding 64-bit integers:**

```
ADDS r4, r0, r2 ; adding the least significant words
ADC r5, r1, r3  ; adding the most significant words
```

## Multiplication

ARM assembly language provides several instructions for performing
multiplication, catering to different needs such as standard multiplication,
multiply-accumulate operations, and handling of 64-bit results.

```
MUL     32x32 multiply with 32-bit product
MLA     32x32 multiply added to a 32-bit accumulated value
SMULL   Signed 32x32 multiply with 64-bit product
UMULL   Unsigned 32x32 multiply with 64-bit product
SMLAL   Signed 32x32 multiply added to a 64-bit accumulated value
UMLAL   Unsigned 32x32 multiply added to a 64-bit accumulated value
```

**Simple multiplications**

```
MUL r4, r2, r1      ; r4 = r2 * r1
MULS r4, r2, r1     ; r4 = r2 * r1, then set the flags
MLA r7, r8, r9, r3  ; r7 = r8 * r9 + r3
```

**Multiplication with SMULL and UMULL**

```
SMULL r4, r8, r2, r3    ; r4 = bits 31-0 of r2*r3
                        ; r8 = bits 63-32 of r2*r3
UMULL r6, r8, r0, r1    ; {r8,r6} = r0*r1
```
## Multiplying by a constant

```
LSL r1, r0, #2          ; r1 = r0*4
ADD r0, r1, r1, LSL #2  ; r0 = r1 + r1*4
RSB r0, r2, r2, LSL #3  ; r0 = r2*7
```

## Division

Modern ARM architectures include hardware divide instructions:

- SDIV: Performs a signed 32-bit integer division.
- UDIV: Performs an unsigned 32-bit integer division.

These instructions take two registers as input (dividend and divisor) and store
the quotient in a destination register. The result is typically rounded towards
zero.

```
; Signed division: r0 = r1 / r2
SDIV r0, r1, r2

; Unsigned division: r0 = r1 / r2
UDIV r0, r1, r2
```

### Software Division Algorithms

When higher precision is required, division can be implemented in software using
algorithms like:

- Repeated Subtraction: This involves repeatedly subtracting the divisor from the
dividend and incrementing a counter (the quotient) until the dividend is less
than the divisor. The remaining dividend is the remainder.

```
    ; Example: Divide R1 by R2, store quotient in R0
    MOV R0, #0       ; Initialize quotient to 0
    .subtract_loop
    CMP R1, R2       ; Compare dividend with divisor
    BLT .end_subtract ; If dividend < divisor, end loop
    SUB R1, R1, R2   ; Subtract divisor from dividend
    ADD R0, R0, #1   ; Increment quotient
    B .subtract_loop
    .end_subtract
    ; R0 now holds the quotient, R1 holds the remainder
```

- Shifting and Subtraction: More efficient algorithms leverage bit shifting to
perform division, similar to long division.

### Run-time Library Functions

Compilers and operating systems often provide run-time library functions for
division, such as __aeabi_idiv (for integer division in the ARM Embedded
Application Binary Interface). These functions handle the complexities of
division, including potential edge cases like division by zero.

```
; Example: Call __aeabi_idiv to divide r0 by r1
; r0 will contain the quotient after the call
BL __aeabi_idiv
```

### Bit manipulation instruction

ARM assembly provides a comprehensive set of instructions for bit manipulation,
operating primarily on values within registers. These instructions facilitate
various bitwise operations, bit field manipulation, and bit reversal.

**Bit Field Manipulation:**

- BFI (Bit Field Insert): Inserts a series of adjacent bits from the bottom of
one register into a specified position within a destination register.
- BFC (Bit Field Clear): Clears a series of adjacent bits within a register.
- SBFX (Signed Bit Field Extract): Extracts a bit field from a register,
sign-extends it, and places it into the least significant bits of another
register.
- UBFX (Unsigned Bit Field Extract): Extracts a bit field from a register,
zero-extends it, and places it into the least significant bits of another
register. 

**Bit Reversal**

- RBIT: Reverses the order of all bits within a register.

**Syntax:**

```
BFI {<cond>} <Rd>, <Rn>, <#lsb>, <#width>
SBFX{<cond>} <Rd>, <Rn>, <#lsb>, <#width>
UBFX{<cond>} <Rd>, <Rn>, <#lsb>, <#width>

BFC {<cond>} <Rd>, <#1sb>, <#width>

RBIT {<cond>} <Rd>, <Rn>
```

Before instruction
- R0 0xABCDDCВА
- R1 0xFFFFFFFF

```
BFI r1, r0, #8, #8
```

After instruction
- R0 0xABCDDCВА
- R1 0xFFFFBAFF

Before instruction
- R0 0x000000DD

```
BFC r0, #4, #4
```

After instruction
- R0 0x000000D

## Programs

- [Find Max Value in an Array](find_max.s)
- [LSL Instruction](lsl_instruction.s)
- [Adding Signed Numbers](adding_signed.s)
- [Find Min Value in an Array](find_min.s)
- [Solving a complex equation](complex_equation.s)
- [Division by Subtraction](division_sub.s)