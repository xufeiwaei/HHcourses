#include "TinyTimber.h"
#include "piezo.h"
#include <avr/io.h>

int  PiezoOn(Piezo *self, int nothing)
{
	PORTB&=~(1<<5);
}


int  PiezoOff(Piezo *self, int nothing)
{
	PORTB|=1<<5;
}