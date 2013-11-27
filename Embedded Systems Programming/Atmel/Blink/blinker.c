#include "TinyTimber.h"
#include "lcd.h"
#include "blinker.h"

int blink(Blinker *self, int on)
{
	AFTER(MSEC(self->period),self,blink,1-on);
	
	if(on)
	{
		ASYNC(self->lcd,segmentOff,self->segment);
	}
	else
	{
		ASYNC(self->lcd,segmentOn,self->segment);
	}
}

int startblink(Blinker *self, int x)
{
	ASYNC(self, blink, 0);
}