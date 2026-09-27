
        .section .data

putPt:      .space      4   /* Allocate 4 bytes of memory filled with zeros */
getPt:      .space      4   /* Allocate 4 bytes of memory filled with zeros */
.equ        SIZE,       8
fifo:       .space      SIZE /* fifo can accept size-1 items */

.equ        fifo_addr,      fifo            /* Address of fifo */
.equ        fifo_end_addr,  fifo + SIZE
.equ        putPt_addr,     putPt           /* Put pointer address */
.equ        getPt_addr,     getPt           /* Get pointer address */

        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb
        .section .text
        .global     fifo_init
        .global     fifo_put
        .global     fifo_get
        .global     fifo_size

fifo_init:
        /* Set putPt and getPt to fifo_addr */
        ldr     r0, =fifo_addr
        ldr     r1, =putPt_addr
        str     r0, [r1]

        ldr     r1, =getPt_addr
        str     r0, [r1]

        bx lr

/*
    R0 has data to be put into fifo
    R0 has return value, 1 for success
    and 0 for failure
 */
 fifo_put:
        ldr     r1, =putPt_addr
        ldr     r2, [r1]
        add     r3, r2, #1
        ldr     r12, =fifo_end_addr
        cmp     r3, r12             /* Check if end of fifo is reached */
        bne     proceed_with_put    /* if not end proceed, do not wrap around */

        ldr     r3, =fifo_addr      /* wrap around, meaning set position to starting point */

proceed_with_put:
        ldr     r12, =getPt_addr
        ldr     r12, [r12]
        cmp     r3, r12 
        bne     _not_full
        mov     r0, #0          /* Failure */
        bx      lr

_not_full:
        strb    r0, [r2]        /* Save data */
        str     r3, [r1]        /* Update putPt */
        mov     r0, #1          /* Success */
        bx      lr


/*
    Takes address to store value from fifo as argument
    destination address is passed to r0
    R0 has return value, 1 for success
    and 0 for failure
 */
 fifo_get:
        push    {r4, r5, lr}
        ldr     r1, =putPt_addr
        ldr     r1, [r1]        /* putPt */
        ldr     r2, =getPt_addr
        ldr     r3, [r2]
        cmp     r1, r3          /* check if putPt == getPt */
        bne     _fifo_not_empty
        mov     r0, #0          /* fifo is empty, nothing to get, error */
        b       _cleanup

_fifo_not_empty:
        ldrsb   r4, [r3]
        strb    r4, [r0]
        add     r3, r3, #1      /* move to next place */
        ldr     r5, =fifo_end_addr
        cmp     r3, r5          /* check if getPt + 1 == end_of_fifo */
        bne     _update_get_pt
        ldr     r3, =fifo_addr  /* wrap around, meaning set position to starting point */

_update_get_pt:
        str r3, [r2]

_cleanup:
        pop {r4, r5, lr}


/*
    Returns current number of elements in fifo,
    R0 contians return value
 */

 fifo_size:
        ldr     r1, =putPt_addr
        ldr     r1, [r1]
        ldr     r2, =getPt_addr
        ldr     r3, [r2]
        sub     r0, r1, r3 /* putPt - getPt */
        and     r0, #(SIZE - 1)
        bx      lr

        .align 
        .end
