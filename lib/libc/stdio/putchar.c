#include <stdio.h>
#include <tty.h>

 
int putchar(int ic) {

	char c = (char) ic;
	TerminalPutChar(c);
	return ic;
}