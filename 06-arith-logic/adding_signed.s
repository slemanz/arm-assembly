
        .section .data
SIGN_DATA:      .byte   +13, -14, +9, +14, -18, -9, +12, -19, +16

        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb

        .section .text
        .global __main


__main:
        // load the address of SIGN_DATA into r0
        ldr r0, =SIGN_DATA
        mov r3, #9
        mov r2, #0

        // load a singned byte from mem address found in r0 into r1
l:      ldrsb r1, [r0]
        add r2, r2, r1
        add r0, r0, #1
        subs r3, r3, #1

        // branch to the top if result not equal to zero
        bne l

stop:
        b   stop
        .align
        .end
