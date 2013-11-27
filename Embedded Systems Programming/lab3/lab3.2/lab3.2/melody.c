/*
 * melody.c
 *
 * Created: 2012/12/5 13:37:51
 *  Author: xufei
 */ 

#include "lcd.h"
#include "TinyTimber.h"
#include "sound.h"
#include "piezo.h"
#include "melody.h"
#include <avr/io.h>
#include <avr/pgmspace.h>

const int16_t freq[] PROGMEM = {f, e, e, e, e, e, e, f, f, f,
                                f, g, f, d, e, e, e, e, e, e,
                                e, f, f, f, f, g, f, d, g, g,
                                g, g, a, a, a, a, a, a, a, h,
			                    h, h, c, c, a, a, g, h, d, c};
					   
const int16_t dur[] PROGMEM = {x, x, x, x, x, y, z, x, x, x,
                               x, x, y, z, x, x, x, x, x, y,
                               z, x, x, x, x, x, y, z, x, x,
	                    	   x, x, x, y, z, x, x, x, x, x,
			                   y, z, ss, ss, t, x, t, x, x, t};
			 				   

int playDiana(Melody *self, int nothing)
{	
	if (self->pos == 49)
	{
		self->pos = 0; 
	}
	BEFORE(pgm_read_word(&dur[self->pos]),self->sound,setFrequence,pgm_read_word(&freq[self->pos]));
	BEFORE(pgm_read_word(&dur[self->pos]),self->sound,startPlaying, 0);
	//AFTER(0,self->sound,setFrequence,pgm_read_word(&freq[self->pos]));
	//AFTER(0,self->sound,startPlaying, 0);
	SEND(pgm_read_word(&dur[self->pos]), pgm_read_word(&dur[self->pos])+MSEC(10),self->sound,stopPlaying,0);
	SEND(pgm_read_word(&dur[self->pos])+MSEC(10),pgm_read_word(&dur[self->pos])+MSEC(10),self,playDiana,self->pos++);
	//AFTER(pgm_read_word(&dur[self->pos]),self->sound,stopPlaying,0);
	//AFTER(pgm_read_word(&dur[self->pos])+MSEC(10),self,playDiana,self->pos++);
	
}

int stop(Melody *self, int nothing)
{
	ASYNC(self->pos,stopPlaying,0);
}

