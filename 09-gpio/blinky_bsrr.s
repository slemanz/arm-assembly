
.equ    RCC_BASE,           0x40023800
.equ    AHB1ENR_OFFSET,     0x30

.equ    RCC_AHB1ENR,        (RCC_BASE + AHB1ENR_OFFSET)
.equ    GPIOA_BASE,         0x40020000

.equ    MODER_OFFSET,       0x00
.equ    ODR_OFFSET,         0x14
.equ    BSRR_OFFSET,        0x18

.equ    GPIOA_MODER,        (GPIOA_BASE + MODER_OFFSET)
.equ    GPIOA_ODR,          (GPIOA_BASE + ODR_OFFSET)
.equ    GPIOA_BSRR,         (GPIOA_BASE + BSRR_OFFSET)


.equ    GPIOA_EN,           (1 << 0)
.equ    MODER5_OUT,         (1 << 10)
.equ    LED_ON,             (1U << 5)
.equ    LED_OFF,            (1U << 0)
.equ    ONESEC,             5333333

.equ BSRR_5_SET,            (1 << 5)
.equ BSRR_5_RESET,          (1 << 21)

        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb

        .section .text
        .global __main

__main:
        /* ENABLE CLOCK ACCESS TO GPIOA */
        // point r0 to RCC_AHB1ENR
        ldr r0, =RCC_AHB1ENR

        // load value at address found in r0 into r1
        ldr r1, [r0]

        orr r1, #GPIOA_EN

        // store content in r1 at address found in r0
        str r1, [r0]

        // set PA5 as output
        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        orr r1, #MODER5_OUT
        str r1, [r0]

        mov r1, #0
        ldr r2, =GPIOA_BSRR

Blink:
        mov r1, #BSRR_5_SET
        str r1, [r2]
        ldr r3, =ONESEC
        bl Delay

        mov r1, #BSRR_5_RESET
        str r1, [r2]
        ldr r3, =ONESEC
        bl Delay

        b Blink

Delay:
        subs r3, r3, #1
        // branch if z flag is not equal to zero
        bne Delay
        bx lr


        .align
        .end
