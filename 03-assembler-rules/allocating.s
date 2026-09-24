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
        ldr r0, =A          // point r0 to mem location A
        mov r1, #0x05
        str r1, [r0]        // store content of r1 into address pointed to by r0

        ldr r0, =D
        mov r1, #0x10
        str r1, [r0]

        ldr r0, =C
        mov r1, #0x200
        str r1, [r0]

stop:
        b   stop


        .section .data

A:      .space      4  // Allocate 4 bytes of mem filled with zero
C:      .space      4
D:      .space      4

        .align
        .end