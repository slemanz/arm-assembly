/*
    PC0 :  East car sensor
    PC1 :  North car sensor
*/

/*
    Go north    :  PA9-PA4 = 100001 = 0x21: Green on North, Red on East
    Wait north  :  PA9-PA4 = 100010 = 0x22: Yellow on North, Red on East
    Go east     :  PA9-PA4 = 001100 = 0x0C: Red on North, Green on East
    Wait east   :  PA9-PA4 = 010100 = 0x14: Red on North, Yellow on East
*/

.equ RCC_BASE,              0x40023800
.equ AHB1ENR_OFFSET,        0x30

.equ RCC_AHB1ENR,           (RCC_BASE + AHB1ENR_OFFSET)
.equ GPIOA_BASE,            0x40020000

.equ MODER_OFFSET,          0x00
.equ GPIOA_MODER,           (GPIOA_BASE + MODER_OFFSET)

.equ ODR_OFFSET,            0x14
.equ GPIOA_ODR,             (GPIOA_BASE + ODR_OFFSET)

.equ BSRR_OFFSET,           0x18
.equ GPIOA_BSRR,            (GPIOA_BASE + BSRR_OFFSET)

.equ GPIOC_BASE,            0x40020800
.equ GPIOC_MODER,           (GPIOC_BASE + MODER_OFFSET)
.equ IDR_OFFSET,            0x10
.equ GPIOC_IDR,             (GPIOC_BASE + IDR_OFFSET)

.equ GPIOA_EN,              (1 << 0) // 0B 000000 00000.............0001
.equ GPIOC_EN,              (1 << 2)

.equ TRAFFIC_LIGHTS_ODR,        GPIOA_ODR
.equ TRAFFIC_LIGHTS_MDR,        GPIOA_MODER
.equ CAR_SENSORS_MDR,           GPIOC_MODER
.equ CAR_SENSORS_IDR,           GPIOC_IDR

.equ MODER4_OUT,                (1U << 8)
.equ MODER5_OUT,                (1U << 10)
.equ MODER6_OUT,                (1U << 12)
.equ MODER7_OUT,                (1U << 14)
.equ MODER8_OUT,                (1U << 16)
.equ MODER9_OUT,                (1U << 18)

.equ NORTH_LED_RED,             (1U << 6)
.equ NORTH_LED_YELLOW,          (1U << 5)
.equ NORTH_LED_GREEN,           (1U << 4)

.equ EAST_LED_RED,              (1U << 9)
.equ EAST_LED_YELLOW,           (1U << 8)
.equ EAST_LED_GREEN,            (1U << 7)

.equ NORTH_SENSOR,              (1U << 1)
.equ EAST_SENSOR,               (1U << 0)


        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb

        .section .text
        .global __main
        .global systick_init
        .global systick_delay
        .global systick_delay_ms

/* Make sure PA0 is always set HIGH for debug usb connection */
go_north:
        .word	0x211   /* Green on North, Red on East */
        .word   3000    /* 3sec */
        .word	go_north, wait_north, go_north, wait_north

wait_north:
        .word   0x221    /* Yellow on North, Red on East */
        .word   500      /* 0.5 sec */
        .word   go_east, go_east, go_east, go_east

go_east:
        .word   0x0C1   /* Red on North, Green on East */
        .word   3000
        .word   go_east, go_east, wait_east, wait_east

wait_east:
        .word   0x141 /* Red on North, Yellow on East */
        .word   500
        .word   go_north, go_north, go_north, go_north

.equ    OUT,  0     /* offset of output value in data structure */
.equ    WAIT, 4     /* offset of time value in data structure */
.equ    NEXT, 8     /* offset of NEXT value in data structure */


/* PC0 =  0001 ,PC1 = 0010 , PC0+ PC1 =  0011 =  0x3 */
.equ    SENSOR_PINS, 0x3
.equ    go_north_addr, go_north

__main:
        bl   systick_init

        /* Enable clock access to GPIOA */
        ldr  r0, =RCC_AHB1ENR
        ldr  r1, [r0]
        orr  r1, #GPIOA_EN
        str  r1, [r0]

        /* Set all traffic light pins to ouput */
        ldr  r0, =TRAFFIC_LIGHTS_MDR
        ldr  r1, [r0]

        orr  r1, #MODER4_OUT
        orr  r1, #MODER5_OUT
        orr  r1, #MODER6_OUT
        orr  r1, #MODER7_OUT
        orr  r1, #MODER8_OUT
        orr  r1, #MODER9_OUT

        str  r1, [r0]

        /* Enable clock to GPIOC */
        ldr  r0, =RCC_AHB1ENR
        ldr  r1, [r0]
        orr  r1, #GPIOC_EN
        str  r1, [r0]

        ldr  r4, =go_north_addr /* State pointer */
        ldr  r5, =CAR_SENSORS_IDR
        ldr  r6, =TRAFFIC_LIGHTS_ODR

fsm:
        ldr  r0, [r4, #OUT] /* Output value */
        str  r0, [r6]       /* Configure lights */
        ldr  r0, [r4, #WAIT]
        bl   systick_delay_ms

        ldr  r0, [r5]
        and  r0, r0, #SENSOR_PINS
        lsl  r0, r0, #2     /* Multiply by 4 = {0,4,8,12} */
        add  r0, r0, #NEXT  /* {8,12,16,20}*/
        ldr  r4, [r4, r0]
        b    fsm

loop:
        b       loop

        .align
        .end
