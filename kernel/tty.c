#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
 
#include <tty.h>
#include <vga.h>
 
static const size_t 	VGA_WIDTH  = 80;
static const size_t 	VGA_HEIGHT = 25;
static const uint16_t * VGA_MEMORY = (uint16_t*) 0xB8000;
 
static size_t 	 terminal_row;
static size_t 	 terminal_column;
static uint8_t 	 terminal_color;
static uint16_t *terminal_buffer;
 
void TerminalInitialise(void) 
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = 0;
	terminal_buffer = VGA_MEMORY;
	for (size_t y = 0; y < VGA_HEIGHT; y++) 
	{
		for (size_t x = 0; x < VGA_WIDTH; x++) 
		{
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = VgaEntry(' ', terminal_color);
		}
	}
}
 
void TerminalSetColor(uint8_t color) 
{
	terminal_color = color;
}
 
void TerminalPutEntryAt(unsigned char c, uint8_t color, size_t x, size_t y) 
{
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = VgaEntry(c, color);
}
 
void TerminalPutChar(char c) 
{
	unsigned char uc = c;
	if (uc == '\n')
	{
		terminal_column = 0;
		++terminal_row;
		return;
	}
	TerminalPutEntryAt(uc, terminal_color, terminal_column, terminal_row);
	if (++terminal_column == VGA_WIDTH) 
	{
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT)
			terminal_row = 0;				// TODO: scroll screen
	}
}

void TerminalRemoveChar()
{	
	TerminalPutEntryAt(0x00, 0x00, --terminal_column, terminal_row); 	// TODO: Fix bug where you can erase beyond terminal_row==0
}