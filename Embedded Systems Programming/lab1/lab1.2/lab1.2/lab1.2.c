/*
* lab1.c
*
* Created: 2012/11/16 11:53:05
*  Author: xufei
*/


#include <avr/io.h>

int main(void)
{
	TCNT1 = 0;
	LCDCRA  = 0x80;
	LCDCRB  = 0xB7;
	TCCR1B = 0x04;
	while (1)
	{
		/*if (TCNT1>=32767)
		{
			symbool = 1-symbool;
			if (symbool==0)
			{
				LCDDR18 = 0x01;
				TCNT1 = 0;
			}
			else
			{
				LCDDR18 = 0x00;
				TCNT1 = 0;
			}
		}*/
		while (TCNT1<=32767)
		{
		}
		LCDDR18 = 0x00;
		TCNT1 = 0;
		while (TCNT1<=32767)
		{
		}
		LCDDR18 = 0x01;
		TCNT1 = 0;
	}
}