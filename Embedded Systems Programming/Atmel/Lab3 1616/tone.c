#include "TinyTimber.h"
#include "piezo.h"
#include "tone.h"
#include <avr/io.h>

char flag_play;

int  playing(Tone *self, int nothing)
{
	if(flag_play)
	{
		AFTER(RESOLUTION(15625/self->frequency),self,playing,1-nothing);
		if(nothing) ASYNC(self->piezo,PiezoOff,0);
		else ASYNC(self->piezo,PiezoOn,0);
	}
}


int start_playing(Tone *self, int nothing)
{
	flag_play=1;
	ASYNC(self,playing,0);
}


int stop_playing(Tone *self, int nothing)
{
	flag_play=0;
	//ASYNC(self,playing,0);
}


int  setFrequency(Tone *self, int frequency)
{
	self->frequency = frequency;
	//ASYNC(self,playing,0);
}

