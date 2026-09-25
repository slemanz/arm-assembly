# ADC Driver

## ADC Independent Modes

- Single-channel: single conversion mode
- Multichannel(scan): single conversion mode
- Single-channel continuous conversion mode
- Multichannel continuous conversion mode
- Injected continuous conversion mode

### Single-channel, single conversion mode

- Simplest ADC mode
- ADC performs a single conversion of a single channel x and stops after
conversion is complete

Example use case:

Measurement of voltage level to determine if a system should be started on not

### Multichannel, single conversion mode

- Used to convert multiple channels successively
- Up to 16 different channels with different sampling times can be converted on
the stm32f4

Example use case:

Measurement of multiple sensors to determine whether a system should start or not.

### Single-channel, continuous conversion mode

- Used to convert a single channel continuously
- Works in the background without intervention from the CPU

Example use case:

Measurement of room temperature continuous to adjust air-conditioner

### Multichannel, continuous conversion mode

- Used to convert multiple channels continuously
- Up to 16 different channels with different sampling times can be converted on
the stm32f4

Example use case:

Continuously measuring multiple accelerometers to adjust joints of a robotic arm.

### Injected conversion mode

- Intended for use when conversion is triggered by an external event or by
software.
- The injected group has priority over the regular channel group.
- Interrupts the conversion of the current channel in the regular channel group.

Example use case:

For synchronizing the conversion of channels to an event

## Resolution

| n-bit | Number of Steps   | Step Size |
| ---   | ---               | ---       |
| 8-bit | 256               | 5v/256 = 19.53mV |
| 10-bit | 1024             | 5v/1024 = 4.88mV |
| 12-bit | 4096             | 5v/4096 = 1.2mV |
| 16-bit | 65,536           | 5v/65,536 = 0.076mV |

---

## Example code:

- [main.c](main.c)
- [adc.s](adc.s)