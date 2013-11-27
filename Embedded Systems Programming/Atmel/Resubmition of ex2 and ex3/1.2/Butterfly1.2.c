/*
 * Butterfly_lab1.2.c
 *
 * Created: 2012/11/14 15:21:24
 *  Author: Sun Gao
 */ 

#include <avr/io.h>

#define blink_off LCDDR8=0x00
#define blink_on  LCDDR8=0x01


void lcd_int(void)
{
	LCDCRA  = 0x80;
	LCDCRB  = 0xb7;
}




void blink(void)
{
	TCCR1B=0x04;
	while(1)
	{
		while(TCNT1<15625);
		blink_off;
	
		while(TCNT1<31250);
		blink_on;
		TCNT1=0;
	}
	
}


int main(void)
{
	CLKPR=0x80;
	CLKPR=0x00;
	lcd_int();
	blink();
}