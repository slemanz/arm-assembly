
.equ    RCC_BASE,           0x40023800
.equ    AHB1ENR_OFFSET,     0x30

.equ    RCC_AHB1ENR,        (RCC_BASE + AHB1ENR_OFFSET)
.equ    GPIOA_BASE,         0x40020000

.equ    MODER_OFFSET,       0x00
.equ    PUPDR_OFFSET,       0x0C
.equ    IDR_OFFSET,         0x10
.equ    ODR_OFFSET,         0x14
.equ    BSRR_OFFSET,        0x18

.equ    GPIOA_MODER,        (GPIOA_BASE + MODER_OFFSET)
.equ    GPIOA_PUPDR,        (GPIOA_BASE + PUPDR_OFFSET)
.equ    GPIOA_IDR,          (GPIOA_BASE + IDR_OFFSET)
.equ    GPIOA_ODR,          (GPIOA_BASE + ODR_OFFSET)
.equ    GPIOA_BSRR,         (GPIOA_BASE + BSRR_OFFSET)


.equ    GPIOA_EN,           (1 << 0)
.equ    MODER5_OUT,         (1 << 10)
.equ    PUPDR6_PU,          (1 << 12)
.equ    LED_ON,             (1U << 5)
.equ    LED_OFF,            (1U << 0)
.equ    ONESEC,             5333333

.equ BSRR_5_SET,            (1 << 5)
.equ BSRR_5_RESET,          (1 << 21)

// active low switch
.equ    BTN_ON,             0x0000
.equ    BTN_OFF,            0x0040
.equ    BTN_PIN,            0x0040


        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb

        .section .text
        .global __main

__main:
        bl      gpio_init

loop:
        bl      get_input
        cmp     r0, #BTN_ON
        beq     turn_led_on
        cmp     r0, #BTN_OFF
        beq     turn_led_off
        b       loop




turn_led_on:
        mov     r1, #0
        ldr     r2, =GPIOA_BSRR
        mov     r1, #BSRR_5_SET
        str     r1, [r2]

turn_led_off:
        mov     r1, #0
        ldr     r2, =GPIOA_BSRR
        mov     r1, #BSRR_5_RESET
        str     r1, [r2]

get_input:
        ldr     r1, =GPIOA_IDR
        ldr     r0, [r1]
        and     r0, r0, #BTN_PIN
        bx      lr
    
gpio_init:
        /* Set PA5 as output */
        /* ENABLE CLOCK ACCESS TO GPIOA */
        ldr r0, =RCC_AHB1ENR

        ldr r1, [r0]

        orr r1, #GPIOA_EN

        str r1, [r0]

        // set PA5 as output
        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        orr r1, #MODER5_OUT
        str r1, [r0]

        // set PA6 as input
        ldr r0, =GPIOA_PUPDR
        ldr r1, [r0]
        orr r1, #PUPDR6_PU
        str r1, [r0]
        bx  lr

stop:
        b stop


        .align
        .end
