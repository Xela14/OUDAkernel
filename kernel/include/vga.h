#ifndef VGA_H
#define VGA_H
 
#include <stdint.h>
 
static inline uint16_t VgaEntry(unsigned char uc, uint8_t color) 
{
	return (uint16_t) uc | (uint16_t) color << 8;
}
 
#endif