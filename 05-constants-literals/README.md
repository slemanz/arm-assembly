# Constants and Literal Pools

In ARM assembly, constants are immediate values or symbolic definitions used
directly in instructions or as fixed values. Literal pools are a mechanism used
by the assembler to store constant data (especially large or arbitrary 32-bit
values and addresses) in a memory area within the code section, from which they
can be loaded into registers using PC-relative LDR instructions. 

## Loading constants into memory

Loading constants into memory in ARM assembly can be accomplished using several
methods, depending on the size and type of the constant.

For arbitrary 32-bit or larger constants, or when the constant is stored in a
data section, LDR (Load Register) is used to load the value from a memory
address into a register. This often involves using a literal pool or a
PC-relative load.

**Example (GNU Assembler):**

```
ldr r0, =0x12345678 ; Load the 32-bit constant 0x12345678 into r0
```

Also can be direct loading with MOV and MVN.

MOV (Move): This instruction allows loading immediate 16-bit constants directly
into a register (in ARMv7 and later, using movw for the lower 16 bits and movt
for the upper 16 bits of a 32-bit constant). For older ARM architectures or
smaller constants in Thumb mode, a single MOV can load constants within a
specific range (e.g., 0-255 for 16-bit Thumb MOV).

MVN (Move Not): This instruction loads the bitwise NOT of an immediate constant
into a register. This can be useful for loading certain constants that are the
inverse of a value loadable by MOV.

```
movw r0, #0x5678    ; Load lower 16 bits of the constant into r0
movt r0, #0x1234    ; Load upper 16 bits of the constant into r0 (r0 now holds 0x12345678)
```

## Loading Labels

In ARM assembly, the ADR, ADRL, and LDR instructions are used to load addresses
of labels into registers, each with different capabilities and limitations.

1. ADR (Address Register):
    - Loads a PC-relative address into a register. It is a pseudo-instruction
    that the assembler converts into a single ADD or SUB instruction.
    - Suitable for loading addresses of labels that are close to the current
    instruction within the same code section.

    ```
        ADR R0, MyLabel ; R0 now holds the address of MyLabel
    ```

2. ADRL (Address Register Long):
    -  Loads a PC-relative address into a register, similar to ADR, but with a
    wider range. It is also a pseudo-instruction, but it always assembles to two
    instructions (typically two ADD or SUB instructions), even if a single
    instruction would suffice.
    -  Used when the label is within the same code section but further away than
    ADR can reach.
    - But not available in Thumb-2 (T32) code for ARMv6-M and ARMv8-M baseline
    profiles.

    ```
        ADRL R1, AnotherLabel ; R1 now holds the address of AnotherLabel
    ```

3. LDR Rd, =label (Load Register, pseudo-instruction):
    - Loads the address of a label into a register. This is a powerful
    pseudo-instruction that can handle labels outside the current code section
    and those beyond the range of ADR and ADRL.
    - The assembler places the address of the label in a literal pool (a data
    section containing constants and addresses). The LDR instruction then loads
    this value from the literal pool into the specified register. This involves
    a memory access.
    - The most flexible option for loading addresses, especially for global
    labels or labels in different sections.

    ```
        LDR R2, =GlobalData ; R2 now holds the address of GlobalData
    ```

## Examples

- [Simple Equation](simple_equation.s)

**Import from C to Assembly:**

- [main.s](main.s)
- [function.c](function.c)