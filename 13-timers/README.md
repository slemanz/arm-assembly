# Timers

### Uses

- Counting Events
- Creating Delays
- Measuring time between event

**TIMER:** Internal clock source. E.g. PLL, XTAL, RC.

**COUNTER:** External clock source. E.g. Clock fed to CPU.

- Can be used as time base generator
- Can be used to measure the frequency of an external event - Input Capture Mode
- Control an output waveform, or to indicate when a period of time has elapsed -
Output Compare Mode
- One pulse mode (OPM)- allows the counter to be started in response to a
stimulus and to generate a pulse with a programmable length after a programmable
delay

## Registers (STM32)

- Timer Count Register (TIMX_CNT): Shows the current counter value. Size could
be 32-bit or 16-bit depending on timer module used.
- Timer Auto-Reload Register (TIMx_ARR): Timer raises a flag and the counter
restarts automatically when counter value reaches the value in the auto-reload
register. The counter is an up counter by default but can also be configured to
be a down counter.
- Timer Prescaler Register (TIMx_PSC): The prescaler slows down the counting
speed of the timer by dividing the input clock of the timer

## Clock Pre-scaling

- Timer prescaler (TIMx_PSC) determines how fast the timer counter(TIMx_CNT)
increases/decreases.
- With each change in the counter(TIMx CNT) value, the new value is compared to
the value in the timer auto-reload register (TIM_ARR), when the values match, a
flag is raised and an interrupt occurs.

## Some Terms

- Update Event: When timeout occurs or how long it takes for flag to be raised
- Period: Value loaded into auto-reload register(TIM_ARR)
- Up counter: Counts from zero to a set value.
- Down counter: Counts from a set value down to zero

## Computing Update Event

$$Update\_ Event = \dfrac{Timer_{clock}}{(Prescaler+1)(Period+1)}$$

Example:

Let:
- Timer clock APB1 clock 48MHz
- Prescaler = TIM PSC value = 47999 + 1
- Period = TIM ARR value = 499+1

$$Update\_ Event = \dfrac{48 000 000}{(47999+1)(499+1)} = 2Hz = \dfrac{1}{2}s = 0.5s$$

## Code

- [main.s](main.s)

