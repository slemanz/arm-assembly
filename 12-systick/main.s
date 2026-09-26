.equ NVIC_ST_CTRL_R,        0xE000E010
.equ NVIC_ST_RELOAD_R,      0xE000E014
.equ NVIC_ST_CURRENT_R,     0xE000E018

.equ SYSTICK_24BIT_MAX,     0x00FFFFFF
.equ ST_CTRL_EN,            (1 << 0)
.equ ST_CTRL_CLKSRC,        (1 << 2)
.equ ST_CTRL_COUNTFLG,      (1 << 16)

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

.equ DELAY1MS,              16000


        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb

        .section .text
        .global __main

/*Default frequency =  16Mhz =>  16 0000 0000 cycles/second
 1 millisecond  =  16 0000 */

__main:
        bl      gpioa_init
        bl      systick_init

loop:
        bl      blink
        b       loop

gpioa_init:
        /* enable clock access to gpioa */
        ldr r0, =RCC_AHB1ENR
        ldr r1, [r0]
        orr r1, #GPIOA_EN
        str r1, [r0]

        /* set PA5 as output */
        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        orr r1, #MODER5_OUT
        str r1, [r0]

        mov r1, #0
        ldr r2, =GPIOA_ODR
        bx  lr

systick_init:
        /* Disable systick before configuration*/
        ldr r1, =NVIC_ST_CTRL_R
        mov r0, #0
        str r0, [r1]

        /* Load maximum value into systick */
        ldr r1, =NVIC_ST_RELOAD_R
        ldr r0, =SYSTICK_24BIT_MAX
        str r0, [r1]

        /* Clear SYSTICK CURRENT VALUE register  by writing any value into it */
        ldr r1, =NVIC_ST_CURRENT_R
        mov r0, #0
        str r0, [r1]

        /* Select internal clock source and enable Systick */
        ldr r0, =NVIC_ST_CTRL_R
        ldr r1, [r0]
        orr r1, #ST_CTRL_CLKSRC
        orr r1, #ST_CTRL_EN
        str r1, [r0]

        bx lr

        /*Takes number clock cycles to delay as argument
        r0 is argument register*/

systick_delay:
        ldr r1, =NVIC_ST_RELOAD_R
        sub r0, #1
        str r0, [r1]

lp1: 
        /* Check if timeout has occured */
        ldr r1, =NVIC_ST_CTRL_R
        ldr r3, [r1]
        ands r3, r3, #ST_CTRL_COUNTFLG
        beq lp1
        bx lr

systick_delay_ms:
        push {r4, lr} /* Save current value of r4 and lr */
        movs r4, r0
        beq cmplt
lp2:
        ldr r0, =DELAY1MS
        bl systick_delay
        subs r4, r4, #1
        bhi lp2 /* if r4>0 delay another 1ms */
cmplt:
        pop   {r4,lr}  /* restore previous values of r4 and lr */
        bx lr

blink:
        mov r1, #LED_ON
        str r1, [r2]

        ldr r0, =500
        bl systick_delay_ms

        mov r1, #LED_OFF
        str r1, [r2]

        ldr r0, =500
        bl systick_delay_ms

        b blink



stop:
        b stop


        .align
        .end
