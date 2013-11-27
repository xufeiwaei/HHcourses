#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"
#include "blinker.h"
#include "joystick.h"
#include "piezo.h"
#include "tone.h"
#include <avr/io.h>
/*

LCD lcdDriver = initLCD(); 
PrimeCalculator primeCalc = initPrimeCalculator(&lcdDriver);
Blinker blinker = initBlinker(&lcdDriver,4,1000);
Joystick joystick = initJoystick();

typedef struct{
  Object super;
  PrimeCalculator* pctr;
  Blinker* bkr;
} APP;

#define initAPP(p,b) {initObject(),p,b}
 
int startup(APP * self, int x){
  ASYNC(self -> pctr, primes,0);
  ASYNC(self -> bkr, startBlinking, 0);
}

APP app = initAPP(&primeCalc,&blinker);


int main(){
  CONFKEY;
  CONFLCD;
  INSTALL(&joystick,detect,IRQ_PCINT1);
  return TINYTIMBER(&app,startup,0);
}

*/


typedef struct{
  Object super;
  Tone *tone;
} APP;

#define initAPP(t) {initObject(),t}

Piezo piezo = initPiezo();
Tone tone = initTone(&piezo,523);
APP app = initAPP(&tone);


int startup(APP * self, int x){
  AFTER(MSEC(800),self->tone,stop_playing,0);
  AFTER(MSEC(700),self->tone,setFrequency,1047);
  AFTER(MSEC(600),self->tone,setFrequency,988);
  AFTER(MSEC(500),self->tone,setFrequency,880);
  AFTER(MSEC(400),self->tone,setFrequency,784);
  AFTER(MSEC(300),self->tone,setFrequency,698);
  AFTER(MSEC(200),self->tone,setFrequency,659);
  AFTER(MSEC(100),self->tone,setFrequency,587);
  SYNC(self->tone,start_playing,0);
}



int main()
{
	ENPIEZO;
	return TINYTIMBER(&app,startup,0);
}