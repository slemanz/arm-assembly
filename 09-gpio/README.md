# GPIO Driver

MCU pins are grouped into PORT

- PA1 = Port A Pin 1

**Interfacing**

- General Purpose Input/Output (GPIO): General function of the pin
- Special Purpose Input/Output: Special or alternate function of the pin

MCUs GPIO modules have at least 2 registers:
- Direction Register: Set pin as input or output
- Data Register: Write to pin or read from pin

**MCU: Clock Sources**
- On-Chip RC Oscillator: Least precise
- Externally Connected Crystal: Most precise
- Phase Locked Loop (PLL): Programmable

### Drivers

- **[Blinky](blinky.s)**
- **[Blinky bsrr](blinky_bsrr.s)**
- **[Button](button.s)**