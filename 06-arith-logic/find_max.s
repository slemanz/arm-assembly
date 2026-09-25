
count       .req    r0
max         .req    r1
pointer     .req    r2
next        .req    r3

mydata:     .word 0x69, 0x87, 0x86, 0x45, 0x75



.syntax unified
.cpu    cortex-m4
.fpu    softvfp
.thumb

.global __main

__main:

        mov count, #5
        mov max, #0

        // load mem address of mydata into r2
        ldr pointer, =mydata

again:
        // load value at mem adress found in pointer into next
        ldr next, [pointer]

        // compare max with next and update conditional flags
        cmp max, next

        // branch to ctnu if max is equal or greater than next
        bhs ctnu
        mov max, next

ctnu:
        // add 4 bytes to pointer and sotre results in pointer
        add pointer, pointer, #4

        // subtract 1 from count, store result into count and
        // update conditional flags

        subs count, count, #1

        // branch if results is not equal to zero
        bne again


stop:
        b   stop
        .align
        .end
