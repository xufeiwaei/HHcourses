/*
 * melody.h
 *
 * Created: 2012/12/5 13:41:01
 *  Author: xufei
 */ 


#ifndef MELODY_H_
#define MELODY_H_

#include "TinyTimber.h"
#include "sound.h"

#define a 440
#define b 494
#define c 262
#define d 294
#define e 330
#define f 349
#define g 392
#define h 311

#define x MSEC(500)//x MSEC(500)
#define y MSEC(250)//y MSEC(250)
#define z MSEC(1250)//z MSEC(1250)
#define ss MSEC(2500)//ss MSEC(2500)
#define t MSEC(1500)//t MSEC(1500)

typedef struct{
	Object super;
	Sound *sound;
	int pos;
} Melody;

#define initMelody(sound,pos) {initObject(),sound,pos}

int playDiana(Melody *self, int nothing);
int stop(Melody *self, int nothing);

#endif /* MELODY_H_ */