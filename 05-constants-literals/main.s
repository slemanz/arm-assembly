.syntax unified
.cpu    cortex-m4
.fpu    softvfp
.thumb

.global __main
.global Reset_Handler

.word 0x20010000
.word Reset_Handler

        .section .text

.global num
.global Adder

.thumb_func
Reset_Handler:

__main:
        ldr r1, =num
        mov r0, #100
        str r0, [r1]

        bl Adder

stop:
        b   stop
        .align
        .end
