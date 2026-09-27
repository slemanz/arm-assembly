
.equ NVIC_ST_CTRL_R,            0xE000E010
.equ NVIC_ST_RELOAD_R,          0xE000E014
.equ NVIC_ST_CURRENT_R,         0xE000E018

.equ SYSTICK_24BIT_MAX,         0x00FFFFFF
.equ ST_CTRL_EN,                (1 << 0)
.equ ST_CTRL_CLKSRC,            (1 << 2)
.equ ST_CTRL_COUNTFLG,          (1 << 16)

.equ DELAY1MS,                  16000

        .syntax	unified
        .cpu	cortex-m4
        .fpu	softvfp
        .thumb
        .section	.text
        .globl systick_init
        .globl systick_delay
        .globl systick_delay_ms

systick_init:
        /* Disable systick before configuration */
        ldr   r1, =NVIC_ST_CTRL_R /* r1 =  &NVIC_ST_CTRL_R */
        mov   r0, #0
        str   r0, [r1]

        /* Load maximum value into systick */
        ldr   r1, =NVIC_ST_RELOAD_R
        ldr   r0, =SYSTICK_24BIT_MAX
        str   r0, [r1]

        /*
        Clear SYSTICK CURRENT VALUE register
        by writing any value into it 
        */
        ldr  r1, =NVIC_ST_CURRENT_R
        mov  r0, #0
        str  r0, [r1]

        /*Select internal clock source and enable Systick*/
        ldr  r0, =NVIC_ST_CTRL_R
        ldr  r1, [r0]
        orr  r1, #ST_CTRL_CLKSRC
        orr  r1, #ST_CTRL_EN
        str  r1, [r0]

        bx   lr

/*
    Takes number clock cycles to delay as argument
    r0 is argument register
*/
systick_delay:
		
        ldr     r1, =NVIC_ST_RELOAD_R
        sub     r0, #1
        str     r0, [r1]

        /* Check if timeout has occured */
        ldr     r1, =NVIC_ST_CTRL_R
lp1:
        ldr     r3, [r1]
        ands    r3, r3, #ST_CTRL_COUNTFLG
        beq     lp1
        bx      lr


systick_delay_ms:
        push    {r4, lr} /* Save current value of r4 and lr */
        movs    r4, r0
        beq     cmplt

lp2:
        ldr     r0, =DELAY1MS
        bl      systick_delay
        subs    r4, r4, #1
        bhi     lp2	  /* if r4>0 delay another 1ms */

cmplt:
        pop     {r4, lr}  /* restore previous values of r4 and lr */
        bx    lr

        .align
        .end