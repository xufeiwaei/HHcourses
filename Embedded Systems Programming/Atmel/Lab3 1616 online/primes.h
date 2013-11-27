#ifndef PRIMES_H
#define PRIMES_H
typedef struct{
  Object super;
  LCD *lcd;
} PrimeCalculator;

#define initPrimeCalculator(device)  {initObject(),device}

int primes(PrimeCalculator *self, int x);
#endif