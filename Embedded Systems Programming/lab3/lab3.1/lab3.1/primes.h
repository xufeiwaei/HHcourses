/*
 * primes.h
 *
 * Created: 2012/11/27 9:33:53
 *  Author: xufei
 */ 

#ifndef primes_h
#define primes_h

#include "TinyTimber.h"
#include "lcd.h"

typedef struct{
	Object super;
	LCD *driver;
}PrimeCalculator;

#define initPrimeCalculator(driver) {initObject(),driver}

int primes(PrimeCalculator *self, int i);

#endif