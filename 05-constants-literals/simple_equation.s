// P = Q + R + S
// let Q = 2, R = 4, S = 5

.equ Q, 2
.equ R, 4
.equ S, 5

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
        mov r1, #Q
        mov r2, #R
        mov r3, #S

        add r0, r1, r2
        add r0, r0, r3

stop:
        b   stop
        .align
        .end
