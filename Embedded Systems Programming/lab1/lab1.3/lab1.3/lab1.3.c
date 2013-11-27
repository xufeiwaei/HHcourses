/*
 * lab1.c
 *
 * Created: 2012/11/17 0:48:23
 *  Author: xufei
 */ 


#include <avr/io.h>

int main(void)
{
	LCDCRA  = 0x80;
	LCDCRB  = 0xB7;
	PORTB = PORTB|0x80;
    while (1)
    {
		 /*if ((PINB&0x80)!=0x80)
		 {
			 LCDDR13 &= 0x00;
		 }
		 else
		 LCDDR13 |= 0x01;*/
             while ((PINB&0x80)!=0x80)
             {
             }
             LCDDR13 = 0x01;
			 while ((PINB&0x80)==0x80){}
			 LCDDR13 = 0x00;
    }  
}