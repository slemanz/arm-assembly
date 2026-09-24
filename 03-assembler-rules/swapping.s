.syntax unified
.cpu    cortex-m4
.fpu    softvfp
.thumb

.global __main
.global Reset_Handler

.word 0x20010000
.word Reset_Handler

        .section .text

.thumb_func
Reset_Handler:

__main:
        ldr r0, =0xBABEFACE
        ldr r1, =0xDEADBEEF

        eor r0, r0, r1
        eor r1, r0, r1
        eor r0, r0, r1

stop:
        b   stop
        .align
        .end
