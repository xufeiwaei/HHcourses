#include "TinyTimber.h"
#include "piezo.h"
#include "tone.h"
#include "melody.h"
#include <avr/io.h>


#define c 523
#define d 587
#define e 659
#define f 698
#define g 784
#define a 880
#define b 988
#define h 1047



int array_tones[]={c,d,e,f,g,a,b,h,0};
int array_durations[]={100,100,100,100,100,100,100,100,0};

void transfer_duration()
{
	int *p;
	int n,i;
	p=array_durations;
	while(*(p++)!=0) n++;
	for(i=1;i<n;i++)
	{
		array_durations[i]=array_durations[i-1]+array_durations[i];
	}
}



typedef struct{
  Object super;
  Melody *melody;
} APP;

#define initAPP(t) {initObject(),t}

Piezo piezo = initPiezo();
Tone tone = initTone(&piezo,0);
Melody scale = initMelody(&tone,array_tones,array_durations);
APP app = initAPP(&scale);


int startup(APP * self, int x){
  /*AFTER(MSEC(800),self->tone,stop_playing,0);
  AFTER(MSEC(700),self->tone,setFrequency,1047);
  AFTER(MSEC(600),self->tone,setFrequency,988);
  AFTER(MSEC(500),self->tone,setFrequency,880);
  AFTER(MSEC(400),self->tone,setFrequency,784);
  AFTER(MSEC(300),self->tone,setFrequency,698);
  AFTER(MSEC(200),self->tone,setFrequency,659);
  AFTER(MSEC(100),self->tone,setFrequency,587);
  ASYNC(self->tone,start_playing,0);*/
  ASYNC(self->melody,start_playing_melody,0);
}





int main()
{
	ENPIEZO;
	
	tone.frequency=array_tones[0];
	
	transfer_duration();
	
	
	return TINYTIMBER(&app,startup,0);
}