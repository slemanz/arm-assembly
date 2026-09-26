#include <stdio.h>
#include <stdint.h>

extern void uart_init(void);
extern void uart_outchar(int ch);

int __io_putchar(int ch)
{
    uart_outchar(ch);
    return ch;
}

int main(void)
{
    uart_init();

    while(1)
    {
        printf("Hello world!\n");
        for(uint32_t i = 0; i < 4000000; i++);
    }
}