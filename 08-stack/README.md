# Stack

In ARM assembly, the stack is a crucial region of memory used for temporary data
storage, primarily for function calls and local variables. It operates as a
Last-In-First-Out (LIFO) data structure, meaning the last item added is the
first one removed.

## LDM and STM

LDM (Load Multiple) and STM (Store Multiple) are ARM assembly instructions for
transferring a block of registers to or from memory in a single operation. LDM
loads registers from memory, while STM stores registers to memory. These
instructions are more efficient than individual LDR or STR instructions,
especially for transferring multiple words of data, and are commonly used for
implementing stack operations like push and pop

`LDM <address-mode> {<cond>} <Rn> {!}, <reg-list>`

Example of use:

`LDMIA r9, {r0-r3}`

is equal:

```
LDR r0, [r9]
LDR r0, [r9, #4]
LDR r0, [r9, #8]
LDR r0, [r9, #12]
```

(STM is the exactly same syntax)

- IA : Increment After
- IB : Increment Before
- DA : Decrement After
- DB : Decrement Before

## Syntax of the PUSH and POP instruction

In ARM assembly, the PUSH and POP instructions are used to store and retrieve
register values from the stack. They operate on a full-descending stack, meaning
the stack pointer (SP) points to the last occupied location, and the stack grows
downwards in memory.

### Syntax of PUSH:

`PUSH{<cond>} {reglist}`

PUSH stores the specified registers onto the stack. The lowest numbered register
in the list is stored at the lowest memory address, and the highest numbered
register is stored at the highest memory address. The stack pointer (SP) is then
updated to point to the new top of the stack (the lowest stored address). 

### Syntax of POP:

`POP{<cond>} {reglist}`

POP loads the specified registers from the stack. The lowest numbered register
in the list is loaded from the lowest memory address, and the highest numbered
register is loaded from the highest memory address. The stack pointer (SP) is
then updated to point to the new top of the stack (the address above the highest
loaded location). If PC (Program Counter) is included in the reglist, a branch
to the loaded PC value occurs after the instruction completes. 

### Examples

```
PUSH {r0, r1, r2}     ; Pushes registers r0, r1, and r2 onto the stack.
PUSH {r4-r7, lr}      ; Pushes registers r4, r5, r6, r7, and the Link Register (lr) onto the stack.
POP {r0, r1}          ; Pops values from the stack into r0 and r1.
POP {r0-r3, pc}       ; Pops values into r0-r3 and then branches to the address loaded into pc.
```

- **[Pushing and Popping](main.s)**

