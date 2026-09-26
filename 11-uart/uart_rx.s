
.equ    RCC_BASE,           0x40023800
.equ    AHB1ENR_OFFSET,     0x30

.equ    RCC_AHB1ENR,        (RCC_BASE + AHB1ENR_OFFSET)
.equ    GPIOA_BASE,         0x40020000

.equ    APB1ENR_OFFSET,     0x40
.equ    RCC_APB1ENR,        (RCC_BASE + APB1ENR_OFFSET)

.equ    MODER_OFFSET,       0x00
.equ    PUPDR_OFFSET,       0x0C
.equ    IDR_OFFSET,         0x10
.equ    ODR_OFFSET,         0x14
.equ    BSRR_OFFSET,        0x18
.equ    AFRL_OFFSET,        0x20

.equ    GPIOA_MODER,        (GPIOA_BASE + MODER_OFFSET)
.equ    GPIOA_PUPDR,        (GPIOA_BASE + PUPDR_OFFSET)
.equ    GPIOA_IDR,          (GPIOA_BASE + IDR_OFFSET)
.equ    GPIOA_ODR,          (GPIOA_BASE + ODR_OFFSET)
.equ    GPIOA_BSRR,         (GPIOA_BASE + BSRR_OFFSET)
.equ    GPIOA_AFRL,         (GPIOA_BASE + AFRL_OFFSET)



.equ    UART2_BASE,         0x40004400

.equ    CR1_OFFSET,         0x0C
.equ    CR2_OFFSET,         0x10
.equ    CR3_OFFSET,         0x14
.equ    BRR_OFFSET,	        0x08
.equ    SR_OFFSET,          0x00
.equ    DR_OFFSET,          0x04

.equ    UART2_CR1,          (UART2_BASE	+ CR1_OFFSET)
.equ    UART2_CR2,          (UART2_BASE	+ CR2_OFFSET)
.equ    UART2_CR3,          (UART2_BASE	+ CR3_OFFSET)
.equ    UART2_BRR,          (UART2_BASE	+ BRR_OFFSET)
.equ    UART2_SR,           (UART2_BASE	+ SR_OFFSET)
.equ    UART2_DR,           (UART2_BASE	+ DR_OFFSET)


.equ    GPIOA_EN,           (1 << 0)
.equ    USART2_EN,          (1 << 17)

.equ MODER2_ALT_SLT,        (1 << 5)
.equ MODER3_ALT_SLT,        (1 << 7)
.equ PIN2_AF7_SLT,          0x700
.equ PIN3_AF7_SLT,          0x7000

.equ    BRR_CNF,            0x683       // 9600 baudrate @16Mhz
.equ    CR1_CNF,            0x0008      /* Enable TX, 8-bit data*/
.equ    CR2_CNF,            0x0000      /* 1 stop bit*/
.equ    CR3_CNF,            0x0000      /* no flow control*/
.equ    CR1_UARTEN,         (1 << 13)   /* enable uart*/
.equ    CR1_RE,             (1 << 2)   /* enable uart*/
.equ    SR_TXE,             (1 << 7)
.equ    SR_RXNE,            (1 << 5)

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
        bl uart_init

uart_loop:
        bl uart_readchar
        bl uart_outchar
        b uart_loop

uart_init:
        /* 1. Enable clock access to UART GPIO pins */
        ldr r0, =RCC_AHB1ENR
        ldr r1, [r0]
        orr r1, GPIOA_EN
        str r1, [r0]

        /* 2. Set UART gpio pin mode to alternate function mode */

        /*Set PA2 mode as ALT*/
        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        bic r1, #0x30
        str r1, [r0]

        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        orr r1, #MODER2_ALT_SLT
        str r1, [r0]

        /*Set PA3 mode as ALT*/
        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        bic r1, #0xC0

        ldr r0, =GPIOA_MODER
        ldr r1, [r0]
        orr r1, #MODER3_ALT_SLT
        str r1, [r0]

        /* 3. Set UART gpio pin alternate funtion type to UART */

        /*Set PA2 ALT type to AF7*/
        ldr r0, =GPIOA_AFRL
        ldr r1, [r0]
        bic r1, 0xF00
        str r1, [r0]

        ldr r0, =GPIOA_AFRL
        ldr r1, [r0]
        orr r1, #PIN2_AF7_SLT
        str r1, [r0]

        /*Set PA3 ALT type to AF7*/
        ldr r0, =GPIOA_AFRL
        ldr r1, [r0]
        bic r1, #0xF000
        str r1, [r0]

        ldr r0, =GPIOA_AFRL
        ldr r1, [r0]
        orr r1, #PIN3_AF7_SLT
        str r1, [r0]

        /* 4. Enable clock access to UART2 module */
        ldr r0, =RCC_APB1ENR
        ldr r1, [r0]
        orr r1, #USART2_EN
        str r1, [r0]

        /* 5. Set UART baudrate */
        ldr r0, =UART2_BRR
        mov r1, #BRR_CNF
        str r1, [r0]

        /* 6. Configure control register 1 */
        /*Enable uart rx*/
        ldr r0, =UART2_CR1
        mov r1, #CR1_CNF
        orr r1, #CR1_RE
        str r1, [r0]

        /* 7. Configure control register 2 */
        ldr r0, =UART2_CR2
        mov r1, #CR2_CNF
        str r1, [r0]

        /* 8. Configure control register 3 */
        ldr r0, =UART2_CR3
        mov r1, #CR3_CNF
        str r1, [r0]

        /* 9. Enable UART module */
        ldr r0, =UART2_CR1
        ldr r1, [r0]
        orr r1, #CR1_UARTEN
        str r1, [r0]

        bx lr

uart_readchar:
        ldr r1, =UART2_SR

lp1:
        ldr r2, [r1]
        and r2, #SR_RXNE
        cmp r2, #0x00
        beq lp1

        ldr r3, =UART2_DR
        ldr r0, [r3]
        bx lr


uart_outchar: 
        /* 1. Make sure UART transmit fifo is not full */
        ldr r1, =UART2_SR

lp2:
        ldr r2, [r1]
        and r2, #SR_TXE
        cmp r2, 0x00
        beq lp2

        /* 2. Write data into uart data register */
        mov r1, r0
        ldr r2, =UART2_DR
        str r1, [r2]
        bx lr

stop:
        b stop


        .align
        .end
