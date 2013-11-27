/*
 * joystick.h
 *
 * Created: 2012/11/27 17:02:36
 *  Author: xufei
 */ 


#ifndef JOYSTICK_H_
#define JOYSTICK_H_

#include "TinyTimber.h"
#include "lcd.h"
#include "blinker.h"
#include "primes.h"

typedef struct{
	Object super;
	LCD *driver;
} Joystick;

#define initJoystick(driver) {initObject(), driver}
#define CONFJOY {PORTB = 0x80;	PCMSK1 = 0x80;	EIMSK = 0x80;}

int button(Joystick *self, int nothing);

#endif