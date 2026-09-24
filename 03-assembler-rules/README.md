# Assembler Rules

## ARM, Thumb, and Thumb-2

ARM, Thumb, and Thumb-2 are instruction sets for ARM processors, differing
mainly in instruction size, functionality, and performance. ARM instructions are
32-bit and typically performance-oriented, while the original Thumb instruction
set uses 16-bit instructions for better code density, though at the cost of
performance. Thumb-2 is a significant enhancement that includes both 16-bit and
32-bit instructions, offering a combination of ARM-like performance and
Thumb-like code density. 

- ARM instruction: ADD R0, R0, R2
- Thumb instruction: ADD R0, R2

Thumb-2 instruction are supported by Cortex-M

## Predefined Register Names

- r0-r15 or R0-R15
- a1-a4 (argument, result, or scratch registers, same as r0 to r3)
- sp or SP
- lr or LR
- pc or PC
- cpsr or CPSR
- spsr or SPSR
- apsr or APSR

## Directives 

- They are not instructions.
- They assist and control the assembly process.
- They are also called pseudo-ops

**Commonly used:**

- .thumb: Assemble code using thumb instruction set
- .syntax: Specifies the syntax being used
- .cpu: Specifies the cpu being used
- .section: Creates a new section
- .globl or .global: Makes an object accessible from another file
- .equ: Gives a symbolic name to a numeric value
- .end: Indicates the end of a file
- .space: Reserves a block of memory and fills it with zero
- .align: Ensures next object aligns properly
- .req: Renames register
- .byte: Allocate one-byte blocks of memory, and specify the initial contents
- .hword: Reserves a block of memory and fills it with zero
- .word: Allocate four-byte blocks of memory, and specify the initial contents.
- .space: Allocate a zeroed block of memory.
- .quad: Allocate eight-byte blocks of memory, and specify the initial contents.

## Operators

- **Data Processing Instructions:** These perform arithmetic and logical
operations on registers. Examples include:

- ADD: Addition.
- SUB: Subtraction.
- MUL: Multiplication.
- AND, ORR, EOR, BIC: Bitwise logical operations (AND, OR, Exclusive OR, Bit Clear).
- MOV: Move data between registers or load an immediate value.
- MVN: Move and Negate.
- CMP: Compare (updates flags based on subtraction).
- TST: Test (updates flags based on bitwise AND).
- LSL, LSR, ASR, ROR: Logical Shift Left, Logical Shift Right, Arithmetic Shift Right, Rotate Right.

**Load and Store Instructions:** These move data between memory and registers.

- LDR: Load Register (loads a word, halfword, or byte from memory into a register).
- STR: Store Register (stores a word, halfword, or byte from a register into memory).
- LDM, STM: Load Multiple, Store Multiple (load/store multiple registers from/to memory, often used for stack operations).
- PUSH, POP: Stack operations, often implemented using STMDB and LDMIA with the stack pointer.

**Branch and Control Instructions:** These manage program flow.

- B: Branch (unconditional jump).
- BL: Branch with Link (calls a subroutine, saving the return address in the Link Register, LR).
- BX: Branch and Exchange (changes execution state, e.g., from ARM to Thumb or vice versa, and jumps to a new address).
- BLX: Branch with Link and Exchange (combines BL and BX).

**Special Instructions:**

- SWI/SVC: Software Interrupt/System Call (initiates a system call).
- MRS, MSR: Move from/to Status Register (accesses the CPSR or SPSR).

## Examples

- [Renaming](renaming.s)
- [Allocating Space](allocating.s)
- [Swapping](swapping.s)