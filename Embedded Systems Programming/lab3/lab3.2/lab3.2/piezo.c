/*
 * piezo.c
 *
 * Created: 2012/12/4 11:45:53
 *  Author: xufei
 */ 
#include "TinyTimber.h"
#include "piezo.h"

int turnOn(Piezo *self, int nothing)
{
	PORTB |= 0x20;
}

int turnOff(Piezo *self, int nothing)
{
	PORTB &= 0xDF;
}

int testPiezo(Piezo *self, int nothing)
{
	if(nothing) {
		turnOn(self, 0);
	} else {
		turnOff(self, 0);
	}
	AFTER(MSEC(500), self, testPiezo, !nothing);

}
