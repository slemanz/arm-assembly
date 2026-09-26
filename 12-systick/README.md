# Systick

- Found in all ARM Cortex-Microcontrollers, regardless of silicon manufacturer.

- Used for taking actions periodically. Often used as time-base for real-time
operating systems.

- The Systick is a 24-bit down counter driven by the processor clock.

## Counting

- Counts from initial value down to zero
- 24-bits imply maximum initial value of: $2^{24}$ = 0xFFFFFF = 16,777,216
- Initial value can be set to a value between: 0x000000 to 0xFFFFFF

## Registers

- Systick Current Value Register (STCVR): This register contains the current
count value
- Systick Control & Status Register (STCSR): This register allows us to
configure the systick clock source, enable/disable interrupts and enable/disable
the systick counter
- Systick Reload Value Register (STRVR): This is where the initial count value
is placed

## Example

Compute the delay achieved by loading 10 in the Systick Reload Value Register
(STRVR) given system clock = 16Mhz

Written as: `Systick->LOAD = 9`

**Solution:**

System clock = 16MHz = 16 000 000 cycles/second

If 1 second executes 16 000 000 cycles, how many seconds execute 1 cycle?

Rightarrow 1/160000000 = 67.5ns =67.5*10^8 s

Then 10 cycles Rightarrow 10 * 62.5 * 10^9 s = 625 * 10^9 s = 625ns

## Count value computations

System Clock (SYSCLK) is chosen as clock source.

If: Systick->LOAD = N

Delay achieved = $\dfrac{N}{SYSCLK}$

## Documentation

Because SYSTICK is a core Cortex-M peripheral its references are found in the
Cortex-M Generic User Guides provided by Arm.

## Code