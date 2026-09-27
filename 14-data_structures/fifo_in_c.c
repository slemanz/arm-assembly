#include <stdint.h>

#define TXFIFOSIZE          1024
#define RXFIFOSIZE          1024
#define TXFAIL              0
#define RXFAIL              0
#define TXSUCCESS           1
#define RXSUCCESS           1
#define FIFOFAIL            0

typedef char tx_dataType;
typedef char rx_dataType;

tx_dataType static TX_FIFO[TXFIFOSIZE];
rx_dataType static RX_FIFO[RXFIFOSIZE];

volatile uint32_t tx_put_itr;
volatile uint32_t rx_put_itr;
volatile uint32_t tx_get_itr;
volatile uint32_t rx_get_itr;

/* Functions */
void tx_fifo_init(void);
uint8_t tx_fifo_put(tx_dataType data);
uint8_t tx_fifo_get(tx_dataType *pData);
uint32_t tx_fifo_size(void);
void rx_fifo_init(void);
uint8_t rx_fifo_put(rx_dataType data);
uint8_t rx_fifo_get(rx_dataType *pData);
uint32_t rx_fifo_size(void);



/* Initialize Tx fifo */

void tx_fifo_init(void)
{
    tx_put_itr = 0;
    tx_get_itr = 0;
}

/* Put data into tx fifo*/

uint8_t tx_fifo_put(tx_dataType data)
{
    /* Check if fifo is full */
    if((tx_put_itr - tx_get_itr) & ~(TXFIFOSIZE - 1))
    {
        /* fifo is full */
        return (TXFAIL);
    }

    /* Put data into fifo */
    TX_FIFO[tx_put_itr & (TXFIFOSIZE - 1)] = data;

    /* Increment itr*/
    tx_put_itr++;
    return TXSUCCESS;
}

uint8_t tx_fifo_get(tx_dataType *pData)
{
     /* Check if fifo is empty */
     if(tx_put_itr == tx_get_itr)
     {
        /* fifo empty */
        return TXFAIL;
     }

     /* Get the data*/
     *pData = TX_FIFO[tx_get_itr & (TXFIFOSIZE - 1)];

     /* Increment the itr */
     tx_get_itr++;
     return TXSUCCESS;
}

uint32_t tx_fifo_size(void)
{
    return (uint32_t)(tx_put_itr - tx_get_itr);
}



/* Initialize rx fifo */

void rx_fifo_init(void)
{
    rx_put_itr = 0;
    rx_get_itr = 0;
}

/* Put data into rx fifo*/

uint8_t rx_fifo_put(rx_dataType data)
{
    /* Check if fifo is full */
    if((rx_put_itr - tx_get_itr) & ~(TXFIFOSIZE - 1))
    {
        /* fifo is full */
        return (RXFAIL);
    }

    /* Put data into fifo */
    RX_FIFO[tx_put_itr & (TXFIFOSIZE - 1)] = data;

    /* Increment itr*/
    rx_put_itr++;
    return RXSUCCESS;
}

uint8_t rx_fifo_get(rx_dataType *pData)
{
     /* Check if fifo is empty */
     if(rx_put_itr == tx_get_itr)
     {
        /* fifo empty */
        return RXFAIL;
     }

     /* Get the data*/
     *pData = RX_FIFO[tx_get_itr & (TXFIFOSIZE - 1)];

     /* Increment the itr */
     rx_get_itr++;
     return RXSUCCESS;
}

uint32_t rx_fifo_size(void)
{
    return (uint32_t)(rx_put_itr - tx_get_itr);
}