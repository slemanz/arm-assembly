.syntax unified
.cpu    cortex-m4
.fpu    softvfp
.thumb


.word 0x20010000
.word Reset_Handler

.section .text
.global __main
.global Reset_Handler
.thumb_func

Reset_Handler:
    mov r1, #100
    mov r2, #126

__main:
    mov r5, #45
    mov r3, #45

    add r6, r5, r3

stop:
    b   stop
    .align
    .end
