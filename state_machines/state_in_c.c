#include "stm32f411xx.h"

#define TRAFFIC_LIGHTS_PORT         GPIOA
#define CAR_SENSOR_PORT             GPIOC

#define EAST_LED_RED                (1U << 9)
#define EAST_LED_YELLOW             (1U << 8)
#define EAST_LED_GREEN              (1U << 7)

#define NORTH_LED_RED               (1U << 6)
#define NORTH_LED_YELLOW            (1U << 5)
#define NORTH_LED_GREEN             (1U << 4)

#define EAST_LED_RED_MODE_BIT       (1U << 18)
#define EAST_LED_YELLOW_MODE_BIT    (1U << 16)
#define EAST_LED_GREEN_MODE_BIT     (1U << 14)

#define NORTH_LED_RED_MODE_BIT      (1U << 18)
#define NORTH_LED_YELLOW_MODE_BIT   (1U << 16)
#define NORTH_LED_GREEN_MODE_BIT    (1U << 14)

#define NORTH_SENSOR                (1U << 1)
#define EAST_SENSOR                 (1U << 0)

// go_north, PA9-4   = 100001 makes it green on North and red on East
// wait_north, PA9-4 = 100010 makes it yellow on North and red on East
// go_east, PA9-4    = 001100 makes it red on North and green on East
// wait_east, PA9-4  = 010100 makes it red on North and yellow on East

struct State
{
    uint32_t output;
    uint32_t time;
    uint8_t next_state[4];
};

typedef const struct State stateType;

#define go_north        0
#define wait_north      1
#define go_east         2
#define wait_east       3

stateType STATE_MACHINE[4] = {
    // using 3 sec and 0.5 sec for demo
    {0x210, 3000, {go_north, wait_north, go_north, wait_north}},
    {0x210,  500, {go_east, go_east, go_east, go_east}},
    {0x0C0, 3000, {go_east, go_east, wait_east, wait_east}},
    {0x210,  500, {go_north, go_north, go_north, go_north}}
};

void TrafficSystemInit(void);
void delayMs(int n);

uint8_t current_state;
uint8_t system_input;

int main(void)
{
    // 1. Initialize hardware then set initial state
    TrafficSystemInit();

    current_state = go_north;

    while(1)
    {
        TRAFFIC_LIGHTS_PORT->ODR = STATE_MACHINE[current_state].output;
        delayMs(STATE_MACHINE[current_state].time);
        system_input = CAR_SENSOR_PORT->IDR & (NORTH_SENSOR | EAST_SENSOR);
        current_state = STATE_MACHINE[current_state].next_state[system_input];

    }

}



void TrafficSystemInit(void)
{
    RCC->AHB1ENR |= (0x01 | 0x04); // enable clock access to PORTA and PORTC
    TRAFFIC_LIGHTS_PORT->MODER |= NORTH_LED_RED_MODE_BIT | NORTH_LED_RED_MODE_BIT |
                                    NORTH_LED_YELLOW_MODE_BIT | EAST_LED_RED_MODE_BIT |
                                    EAST_LED_GREEN_MODE_BIT | EAST_LED_YELLOW_MODE_BIT;


}

void delayMs(int n)
{
    /* Configure Systick */
    SYSTICK->LOAD = 16000; /* reload with nomber of clocks por milliseconds */
    SYSTICK->VAL = 0; /* Clear current value register */
    SYSTICK->CTRL = 0x05; /* Enable the timer */

    for(int i = 0; i < n; i++)
    {
        while((SYSTICK->CTRL & 0x10000) == 0){} /* Wait until COUNTFLAG is set*/
    }
}