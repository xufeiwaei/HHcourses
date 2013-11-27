#include <avr/io.h>

void lcd_int(void)
{
	LCDCRA  = 0x80;
	LCDCRB  = 0xb7;
}


void disp_on(void)
{
	

	LCDDR3=0x01;
	LCDDR13=0x00;
}

void disp_off(void)
{
	
	LCDDR3=0x00;
	LCDDR13=0x01;
	
}



void button(void)
{
	PORTB |=1<<7;
	disp_off();
	while(1)
	{
		while((PINB&(1<<7)));
		disp_on();
		while(!(PINB&(1<<7)));
		disp_off();
	}
}



int main(void)
{
	CLKPR=0x80;
	CLKPR=0x00;
	lcd_int();
	button();
}