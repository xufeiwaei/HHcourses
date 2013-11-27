#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"

LCD lcdDriver = initLCD();
PrimeCalculator primeCalc = initPrimeCalculator(&lcdDriver);

int main(){
  CONFLCD;
  return TINYTIMBER(&primeCalc,primes,0);
}