
        .data

consumer_arr:       .space      8

.equ    arr_idx0,   consumer_arr    /*address of consumer_arr[0]*/
.equ    arr_idx1,   consumer_arr+1  /*address of consumer_arr[1]*/
.equ    arr_idx2,   consumer_arr+2  /*address of consumer_arr[1]*/
.equ    arr_idx3,   consumer_arr+3  /*address of consumer_arr[1]*/
.equ    arr_idx4,   consumer_arr+4  /*address of consumer_arr[1]*/
.equ    arr_idx5,   consumer_arr+5  /*address of consumer_arr[1]*/
.equ    arr_idx6,   consumer_arr+6  /*address of consumer_arr[1]*/
.equ    arr_idx7,   consumer_arr+7  /*address of consumer_arr[1]*/

        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb

        .section .text
        .global __main

__main:
        bl  fifo_init

        mov     r0,#1
        bl      fifo_put
        mov     r0,#2
        bl      fifo_put
        mov     r0,#3
        bl      fifo_put
        mov     r0,#4
        bl      fifo_put
        mov     r0,#5
        bl      fifo_put
        mov     r0,#6
        bl      fifo_put
        mov     r0,#7
        bl      fifo_put
        mov     r0,#8
        bl      fifo_put   /*Will generate a fail, fifo limit exceeds*/

        bl      fifo_size

        ldr     r0,=arr_idx0
        bl      fifo_get
        ldr     r0,=arr_idx1
        bl      fifo_get
        ldr     r0,=arr_idx2
        bl      fifo_get
        ldr     r0,=arr_idx3
        bl      fifo_get
        ldr     r0,=arr_idx4
        bl      fifo_get
        ldr     r0,=arr_idx5
        bl      fifo_get
        ldr     r0,=arr_idx6
        bl      fifo_get
        ldr     r0,=arr_idx7


        bl      fifo_get        /*Will generate a fail, fifo empty*/

stop:
        b       stop

        .align
        .end
