/*
 * piezo.h
 *
 * Created: 2012/12/4 11:46:07
 *  Author: xufei
 */ 


#ifndef PIEZO_H_
#define PIEZO_H_

#include "TinyTimber.h"
#include <avr/io.h>

typedef struct{
	Object super;
} Piezo;

#define initPiezo() {initObject()}
#define CONFPIE {DDRB = 0x20;}

int turnOn(Piezo *self, int nothing);
int turnOff(Piezo *self, int nothing);
int testPiezo(Piezo *self, int nothing);

#endif /* PIEZO_H_ */