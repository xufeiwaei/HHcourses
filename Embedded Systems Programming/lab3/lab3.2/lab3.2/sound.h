/*
 * sound.h
 *
 * Created: 2012/12/3 20:51:23
 *  Author: xufei
 */ 


#ifndef SOUND_H_
#define SOUND_H_

#include "TinyTimber.h"
#include "piezo.h"

typedef struct{
	Object super;
	Piezo *p;
	int frequence;
}Sound;

#define initSound(p,frequence) {initObject(),p,frequence}

int playMiddletone(Sound *self, int nothing);
int playHightone(Sound *self, int nothing);
int setFrequence(Sound *self, int frequency);
int startPlaying(Sound *self, int nothing);
int stopPlaying(Sound *self, int nothing);

#endif 