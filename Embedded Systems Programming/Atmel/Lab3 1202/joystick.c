#include "TinyTimber.h"
#include "joystick.h"
#include <avr/io.h>


int detect(Joystick *self,int sig)
{
	if(PINB&(1<<7))
	{
		LCDDR3=0x01;
		LCDDR18=0x00;
	} 
	else
	{
		LCDDR3=0x00;
		LCDDR18=0x01;
	}
}
