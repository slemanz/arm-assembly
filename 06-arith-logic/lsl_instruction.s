
.syntax unified
.cpu    cortex-m4
.fpu    softvfp
.thumb

.global __main

__main:
        mov r0, #0x11
        lsl r1, r0, #1  // shift 1 bit left (0x11*2^1)
        lsl r2, r1, #1  // shift 1 bit left (0x11*2^1)

stop:
        b   stop
        .align
        .end
