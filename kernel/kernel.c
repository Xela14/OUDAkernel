#include <stdio.h> 
#include <tty.h>
 
void kernel_main(void) 
{
	TerminalInitialise();
	TerminalSetColor(0x8F);
	printf("normal test\nint test: %d\nstring test: %s\n", 0x204, "this is a string");
}