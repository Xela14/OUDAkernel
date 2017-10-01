#include <stdint.h>
#include <stddef.h>

static const size_t MAX_DIGITS = 10;

char* itoa(int num, char* str)
{
	char* s = str + MAX_DIGITS;	// Points to terminating null character

	if (num >= 0)
	{
		do
		{
			*(--s) = (char) '0' + (num % 10);
			num /= 10;

		} while (num != 0);
		return s;
	}
	else 
	{
		do
		{
			*(--s) = (char) '0' - (num % 10);
			num /= 10;
		} while (num != 0);
		*--s = '-';
	}
	return s;
}