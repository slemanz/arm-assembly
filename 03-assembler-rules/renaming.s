
val1        .req        r1
val2        .req        r2
sum         .req        r3

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

__main:
    mov val1, #0x10
    mov val2, #0x10

    add sum, val1, val2

stop:
    b   stop
    .align
    .end
