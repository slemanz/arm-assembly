        
.equ RCC_BASE,              0x40023800
.equ AHB1ENR_OFFSET,        0x30

.equ RCC_AHB1ENR,           (RCC_BASE + AHB1ENR_OFFSET)
.equ GPIOA_BASE,            0x40020000

.equ APB2ENR_OFFSET,        (0x44)
.equ RCC_APB2ENR,           (RCC_BASE + APB2ENR_OFFSET)



.equ ADC1_BASE,             0x40012000

.equ ADC1_CR2_OFFSET,       0x08
.equ ADC1_CR2,              (ADC1_BASE + ADC1_CR2_OFFSET)

.equ ADC1_SQR3_OFFSET,      0x34
.equ ADC1_SQR3,             (ADC1_BASE + ADC1_SQR3_OFFSET)

.equ ADC1_SQR1_OFFSET,      0x2C
.equ ADC1_SQR1,             (ADC1_BASE + ADC1_SQR1_OFFSET)

.equ ADC1_SR_OFFSET,        0x00
.equ ADC1_SR,               (ADC1_BASE + ADC1_SR_OFFSET)

.equ ADC1_DR_OFFSET,        0x4C
.equ ADC1_DR,               (ADC1_BASE + ADC1_DR_OFFSET)

.equ MODER_OFFSET,          0x00
.equ GPIOA_MODER,           (GPIOA_BASE + MODER_OFFSET)

.equ ODR_OFFSET,            0x14
.equ GPIOA_ODR,             (GPIOA_BASE + ODR_OFFSET)

.equ BSRR_OFFSET,           0x18
.equ GPIOA_BSRR,           (GPIOA_BASE + BSRR_OFFSET)




.equ GPIOA_EN,              (1 << 0)
.equ ADC1_EN,               (1 << 8)
.equ SQR3_CNF,              1  /*Conversion sequence starts at ch1*/
.equ SQR1_CNF,              0  /*Conversion sequence length to 1*/
.equ CR2_ADCON,             (1 << 0)
.equ CR2_SWSTART,           (1 << 30)
.equ SR_EOC,                (1 << 1)	

.equ MODER5_OUT,            (1<<10)
.equ LED_ON,                (1U<<5)
.equ LED_OFF,               (1<<0)
.equ ONESEC,                5333333

.equ SENS_THRESH,           3000

.equ BSRR_5_SET,            (1<<5)
.equ BSRR_5_RESET,          (1<<21)

.equ  MODER1_ANLG_SLT,      0xC


        .syntax unified
        .cpu    cortex-m4
        .fpu    softvfp
        .thumb

        .section .text
        .global adc_init
        .global adc_read
        .global led_init
        .global turn_led_on
        .global turn_led_off
        .global led_control

adc_init:
        /* 1. Enable clock access to ADC pin's GPIO port */
        ldr r0, =RCC_AHB1ENR
        ldr r1, [r0]
        orr r1, #GPIOA_EN
        str r1, [r0]

        /* 2. Set ADC pin, PA as analog pin */
        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        orr r1, #MODER1_ANLG_SLT
        str r1, [r0]

        /* 3. Enable clock access to the ADC */
        ldr r0, =RCC_APB2ENR
        ldr r1, [r0]
        orr r1, #ADC1_EN
        str r1, [r0]

        /* 4. select software trigger */
        ldr r0, =ADC1_CR2
        ldr r1, =0x00000000
        str r1, [r0]

        /* 5. Set conversion sequence starting channel */
        ldr r0, =ADC1_SQR3
        ldr r1, =#SQR3_CNF
        str r1, [r0]

        /* 6. Set conversion sequence length */
        ldr r0, =ADC1_SQR1
        ldr r1, =#SQR1_CNF
        str r1, [r0]

        /* 7. Enable adc module */
        ldr r0, =ADC1_CR2
        ldr r1, [r0]
        orr r1, #CR2_ADCON
        str r1, [r0]

        bx lr

adc_read:
        /* 1. Start conversion */
        ldr r0, =ADC1_CR2
        ldr r1, [r0]
        orr r1, #CR2_SWSTART
        str r1, [r0]

        /* 2. Wait for the conversion to be complete */
lp1:
        ldr r0, =ADC1_SR
        ldr r1, [r0]
        and r1, #SR_EOC
        cmp r1, #0x00
        beq lp1

        /* 3. Read content of ADC data register */
        ldr r2, =ADC1_DR
        ldr r0, [r2]
        bx lr

led_init:
        /* Enable clock access to GPIOA */
        ldr r0, =RCC_AHB1ENR
        ldr r1, [r0]
        orr r1, #GPIOA_EN
        str r1, [r0]

        /* Set PA5 as output pin */
        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        orr r1, #MODER5_OUT
        str r1, [r0]
        bx lr
    
led_control:
        ldr r1, =SENS_THRESH
        cmp r0, r1
        bgt turn_led_on // Branch to turn turn_led_on if adc value is greater than SENS_THRESH
        blt turn_led_off // Branch to turn turn_led_off if adc value is less than SENS_THRESH
        bx lr

turn_led_on:
        ldr r5, =GPIOA_BSRR
        mov r1, #BSRR_5_SET
        str r1, [r5]
        bx lr

turn_led_off:
        ldr r5, =GPIOA_BSRR
        mov r1, #BSRR_5_RESET
        str r1, [r5]
        bx lr


stop:
        b stop


        .align
        .end
