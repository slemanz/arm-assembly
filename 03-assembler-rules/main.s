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
        mov r5, #0x10
        mov r3, #0x10

        add r6, r5, r3

stop:
        b   stop
        .align
        .end
