#ifndef PRIMES_H
#define PRIMES_H
typedef struct{
  Object super;
  LCD *lcd;
} PrimeCalculator;

#define initPrimeCalculator(lcd)  {initObject(),lcd}

int primes(PrimeCalculator *self, int x);
#endif