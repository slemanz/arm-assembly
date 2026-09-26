# UART

## Serial vs. Parallel

- Parallel: 8-bit data is transferred the same time
- Serial : 8-bit data is transferred one bit at a time

## Introduction

Serial data communication uses two methods:

**Synchronous:** Clock is transmitted with the data

**Asynchronous:** No clock is transmitted. Transmitter and receiver agree on the
*Clock speed for the data transmission (Baudrate)

- **UART:** Universal Asynchronous Receiver/Transmitter
- **USART:** Universal Synchronous Receiver/Transmitter

### Transmission Modes

- Duplex: Data can be transmitted and received
- Simplex: Data can be transmitted only or received only. i.e. one direction
only
- Half Duplex: Data can be transmitted in only one way at a time.
- Full Duplex: Data can be transmitted in both ways at a time.

### Protocol Summary

In asynchronous transmission, each byte (character) is packed between start and
stop bits.

- Start bit is always 1 bit, the value of the start bit is always 0
- Stop bit can be 1 or 2 bits, the value of the stop bit is always 1

### Configuration Parameters

- Baudrate: Connection speed expressed in bits per second
- Stop Bit Number of stop bits transmitted, can be one or two
- Parity: Indicates the parity mode, whether odd or even. Used for error
checking.
- Mode: Specifies whether RX or TX mode is enabled or disabled.
- Word Length: Specifies the number of data bits transmitted or received. Can be
8-bits or 9-bits.
- Hardware Flow Control: Specifies whether Hardware Flow Control is enabled or
disabled.

## Code

- [Uart TX](uart_tx.s)
- [Uart RX](uart_rx.s)

- [main.c](main.c)
- [uart.s](uart.s)

