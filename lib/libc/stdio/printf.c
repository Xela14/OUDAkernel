#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

uint32_t written = 0;

int print(char* s)
{
	while(*s != 0x00)
	{
		putchar(*(s++));
		++written;
	}
	return 1;
}

int printf(const char* restrict format, ...)
{
	va_list arguments;
	va_start(arguments, format);

	while (*format != 0x00)
	{
		if (*format != '%')
		{
			putchar(*(format++));
			++written;
			continue;
		}
		
		const char format_mod = *(++format);
		switch (format_mod){
			case 's' :
			{
				const char* str = va_arg(arguments, const char*);
				print(str);
				break;
			}

			case 'c' :
			{
				char c = (char) va_arg(arguments, int);
				putchar(c);
				++written;
				break;
			}

			case 'd' :
			{
				char str[11];		// 10 Characters is the max a 32int translated to a string can reach
				char *str_ptr = itoa(va_arg(arguments, int), str);
				print(str_ptr);
				break;
			}
		}
		++format;					// This is neccessary to account for the character after the %
		++written;
	}

	va_end(arguments);
	return written;
}
