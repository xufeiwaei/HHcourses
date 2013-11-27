#include "TinyTimber.h"
#include "lcd.h"
#include "blinker.h"

char flag_blinking;

int Blinking(Blinker *self, int nothing)
{
	if (flag_blinking)
	{
		AFTER(MSEC(setPeriod(self,0)),self,Blinking,1-nothing);
		if(nothing)
		{
			ASYNC(self->lcd,segmentOff,self->segment);
		}
		else
		{
			ASYNC(self->lcd,segmentOn,self->segment);
		}
	}
	
}

int startBlinking(Blinker *self, int nothing)
{
	flag_blinking=1;
	ASYNC(self,Blinking,0);
}


int stopBlinking(Blinker *self, int nothing)
{
	flag_blinking=0;
	ASYNC(self,Blinking,0);
}


int setPeriod(Blinker *self, int period)
{
	return self->period/2;
}
