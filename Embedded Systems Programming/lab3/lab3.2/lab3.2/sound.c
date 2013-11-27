/*
 * sound.c
 *
 * Created: 2012/12/3 20:51:07
 *  Author: xufei
 */ 

#include "piezo.h"
#include "sound.h"
#include "TinyTimber.h"
#include <avr/io.h>

int playMiddletone(Sound *self, int nothing)
{
	if(self->frequence!=0)
	{
		SEND(RESOLUTION(31250/(self->frequence)), MSEC(5), self,playMiddletone, 1-nothing);
	    //AFTER(RESOLUTION(31250/(self->frequence)),self,playMiddletone,1-nothing);
	    if (nothing)
	    {
		    //ASYNC(self->p,turnOff,0);
			turnOff(self->p,0);
	    }
	    else
	    //ASYNC(self->p,turnOn,0);
		turnOn(self->p,0);
	}
}

int playHightone(Sound *self, int nothing)
{
	SEND(RESOLUTION(15625/(self->frequence)), MSEC(10), self,playHightone, 1-nothing);
	if (nothing)
	{
		ASYNC(self->p,turnOff,0);
	}
	else
	ASYNC(self->p,turnOn,0);
}

int startPlaying(Sound *self, int nothing)
{
	//ASYNC(self,playMiddletone,0);
	playMiddletone(self,0);
}

int stopPlaying(Sound *self, int nothing)
{
	ASYNC(self,setFrequence,0);
}

int setFrequence(Sound *self, int frequency)
{
	self -> frequence = frequency;
}
