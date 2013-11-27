/*
 * joystick.c
 *
 * Created: 2012/11/27 17:02:21
 *  Author: xufei
 */ 

#include "TinyTimber.h"
#include "primes.h"
#include "joystick.h"
#include "lcd.h"
#include "blinker.h"
#include <avr/io.h>

int button(Joystick *self, int i)
{
	if ((PINB & PORTB) != PORTB)
	{
		//ASYNC(self,segmentOn(self,2),0);
		LCDDR13 = 0x01;
	}
	else
	//ASYNC(self,segmentOff(self,2),0);
	LCDDR13 = 0x00;
}