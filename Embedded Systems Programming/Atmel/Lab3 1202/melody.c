#include "TinyTimber.h"
#include "tone.h"
#include "melody.h"

int start_playing_melody(Melody *self, int x)
{
	unsigned int i,n=0,j;
	int *p;
	p=self->array_durations;
	while(*(p++)!=0) n++;
	n--;
	
	
	ASYNC(self->tone,start_playing,0);
	
	/*
	for(i=0;i<n;i++)
	{
		
		AFTER(MSEC(*((self->array_durations)++)),self->tone,setFrequency,*(++(self->array_tones)));
	}*/
	
	
	
	for(i=0;i<8;i++)
	{
		p=(self->array_durations)++;
		j=(*p)+10*i;
		AFTER(MSEC(j),self->tone,stop_playing,0);
		j=(*p)+10*i+10;
		AFTER(MSEC(j),self->tone,start_playing,0);
		AFTER(MSEC(j),self->tone,setFrequency,*(++(self->array_tones)));
	}	
	
}


int stop_playing_melody(Melody *self, int x)
{
	
}