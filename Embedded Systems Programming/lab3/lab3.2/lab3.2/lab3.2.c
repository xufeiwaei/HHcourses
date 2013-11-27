/*
 * lab3.2.c
 *
 * Created: 2012/12/4 23:41:39
 *  Author: xufei
 */ 


#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"
#include "piezo.h"
#include "sound.h"
#include "melody.h"
#include <avr/io.h>
#include <avr/pgmspace.h>

typedef struct{
	Object super;
	PrimeCalculator* pctr;
	Melody *mel;
} APP;

#define initAPP(p,mel) {initObject(),p,mel}

LCD lcdDriver = initLCD();
PrimeCalculator primeCal = initPrimeCalculator(&lcdDriver);
Piezo piezo = initPiezo();
Sound sound = initSound(&piezo,0);
Melody melody = initMelody(&sound,0);
APP app = initAPP(&primeCal,&melody);

int startup(APP * self){
  ASYNC(self -> mel, playDiana,0);
  ASYNC(self -> pctr, primes,0);
}

int main()
{
	CONFLCD;
	CONFPIE;
	return TINYTIMBER(&app,startup,0);
}