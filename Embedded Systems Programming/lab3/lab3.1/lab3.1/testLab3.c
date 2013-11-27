#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"
#include "blinker.h"
#include "joystick.h"
#include <avr/io.h>

LCD lcdDriver = initLCD();
PrimeCalculator primeCalc = initPrimeCalculator(&lcdDriver);
Blinker blinker1 = initBlinker(&lcdDriver,3,500);
Blinker blinker2 = initBlinker(&lcdDriver,1,1000);
Joystick stick = initJoystick(&lcdDriver);

typedef struct{
	Object super;
	PrimeCalculator* pctr;
	Blinker* bkr1;
	Blinker* bkr2;
} APP;

#define initAPP(p,b1,b2) {initObject(),p,b1,b2}
 
int startup(APP * self, int x){
  ASYNC(self -> pctr, primes,0);
  ASYNC(self -> bkr1, startBlinking, 0);
  ASYNC(self -> bkr2, startBlinking, 0);
} 

APP app = initAPP(&primeCalc,&blinker1,&blinker2);

int main(){
  CONFLCD;
  CONFJOY;
  INSTALL(&stick,button,IRQ_PCINT1);
  return TINYTIMBER(&app,startup,0);
}