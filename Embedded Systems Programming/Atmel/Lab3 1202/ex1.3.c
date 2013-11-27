#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"
#include "blinker.h"

LCD lcdDriver = initLCD(); 
PrimeCalculator primeCalc = initPrimeCalculator(&lcdDriver);
Blinker blinker = initBlinker(&lcdDriver,7,500);

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
  CONFLCD;
  return TINYTIMBER(&blinker,Blinking,0);
}