
.equ    RCC_BASE,           0x40023800
.equ    AHB1ENR_OFFSET,     0x30

.equ APB1ENR_OFFSET,        0x40
.equ RCC_APB1ENR,           (RCC_BASE + APB1ENR_OFFSET)


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


.equ TIM2_BASE,				0x40000000


.equ CR1_OFFSET,            0x00
.equ PSC_OFFSET,            0x28
.equ ARR_OFFSET,            0x2C
.equ CNT_OFFSET,            0x24
.equ SR_OFFSET,             0x10

.equ TIM2_PSC,              (TIM2_BASE  + PSC_OFFSET)
.equ TIM2_ARR,              (TIM2_BASE  + ARR_OFFSET)
.equ TIM2_CNT,              (TIM2_BASE  + CNT_OFFSET)
.equ TIM2_CR1,              (TIM2_BASE  + CR1_OFFSET)
.equ TIM2_SR,               (TIM2_BASE  + SR_OFFSET)

.equ GPIOA_EN,              (1 << 0)
.equ TIM2_EN,               (1 << 0)
.equ CR1_CEN,               (1 << 0)
.equ SR_UIF,                (1 << 0)


.equ    MODER5_OUT,         (1 << 10)
.equ    PUPDR6_PU,          (1 << 12)
.equ    LED_ON,             (1U << 5)
.equ    LED_OFF,            (1U << 0)
.equ    ONESEC,             5333333

.equ BSRR_5_SET,            (1 << 5)
.equ BSRR_5_RESET,          (1 << 21)

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
        bl      tim2_1hz_init

        bl      led_blinky

loop:
        b       loop

tim2_1hz_init:
        /* 1. Enable Clock access to TIM2 */
        ldr     r0, =RCC_APB1ENR
        ldr     r1, [r0]
        orr     r1, #TIM2_EN
        str     r1, [r0]

        /* 2. Set prescaler value */
        ldr     r0, =TIM2_PSC
        mov     r1, #1599   /* divide 16 000 000 by  1600 = 10 000 */
        str     r1, [r0]

        /* 3. Set the auto-reload value */
        ldr     r0, =TIM2_ARR
        mov     r1, #9999  /* divide 10000 by 10000*/
        str     r1, [r0]

        /* 4. Clear timer counter */
        ldr     r0, =TIM2_CNT
        mov     r1, #0
        str     r1, [r0]

        /* 5. Enable timer */
        ldr     r0, =TIM2_CR1
        mov     r1, #CR1_CEN
        str     r1, [r0]
        bx      lr

__wait:
        /* wait for UIF flag to be set */
        ldr     r1, =TIM2_SR
lp1:
        ldr     r2, [r1]    /* while(!(TIM2-SR & (1u<<0))){} */
        and     r2, #SR_UIF
        cmp     r2, #0x00
        beq     lp1

        /* Clear UIF */
        ldr     r3, [r1]
        bic     r3, r3, #SR_UIF
        str     r3, [r1]

        bx      lr

led_blinky:
        ldr     r4, =GPIOA_BSRR
        mov     r1, #BSRR_5_SET
        str     r1, [r4]
        bl      __wait

        ldr     r4, =GPIOA_BSRR
        mov     r1, #BSRR_5_RESET
        str     r1, [r4]
        bl      __wait

        bl      led_blinky
    
gpio_init:
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

        bx  lr

stop:
        b stop


        .align
        .end
