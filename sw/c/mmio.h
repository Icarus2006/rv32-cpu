#ifndef MMIO_H
#define MMIO_H
#include <stdint.h>
// Address map του SoC (Μέρος ΙΙΙ, κεφ. 3.1)
#define GPIO_LED    (*(volatile uint32_t *)0x10000000u)
#define GPIO_BTN    (*(volatile uint32_t *)0x10000004u)
#define UART_TX     (*(volatile uint32_t *)0x10001000u)
#define UART_STATUS (*(volatile uint32_t *)0x10001004u)
#define UART_RX     (*(volatile uint32_t *)0x10001008u)
#define MTIME_LO    (*(volatile uint32_t *)0x10002000u)
#define MTIME_HI    (*(volatile uint32_t *)0x10002004u)
#endif
