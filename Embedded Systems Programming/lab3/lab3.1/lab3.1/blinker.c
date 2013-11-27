/*
 * blinker.c
 *
 * Created: 2012/11/27 16:53:56
 *  Author: xufei
 */ 

#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"
#include "blinker.h"
static int flag=0;

int blink(Blinker *self, int x)
{
	AFTER(MSEC(self->halfPeriod),self,blink,1-x);
	if (1-x)
	ASYNC(self->driver,segmentOff,self->segment);
	else
	ASYNC(self->driver,segmentOn,self->segment);
}

int startBlinking(Blinker *self, int nothing)
{
	flag = 0;
	if (flag==0)
	{
		SYNC(self,blink(self,0),0);
	}
}

int stopBlinking(Blinker *self, int nothing)
{
	flag = 1;
	if (flag==1)
	{
		SYNC(self,segmentOff(self,self->segment),0);
	}
}

int setPeriod(Blinker *self, int period)
{
	self -> halfPeriod = period;
}
