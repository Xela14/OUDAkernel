#ifndef _KERNEL_TTY_H
#define _KERNEL_TTY_H
 
#include <stddef.h>
#include <stdint.h>
 
void TerminalInitialise(void);
void TerminalPutChar(char c);
void TerminalSetColor(uint8_t color); 
void TerminalRemoveChar(void)
 
#endif