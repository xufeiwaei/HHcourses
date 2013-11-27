/*
 * primes.c
 *
 * Created: 2012/11/27 9:33:29
 *  Author: xufei
 */ 

#include <avr/io.h>
#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"

int is_prime(int i)
{
	int loop;
	loop = sqrt(i);
	int j = 0;
	int amount = 0;
	for (j=2; j<=loop+1; j++)
	{
		if (i%j == 0)
		{
			amount++;
		}
	}
	if (amount != 0)
	{
		return 0;
	}
	else
	return 1;
}

int primes(PrimeCalculator *self, int x)
{
	while (!(is_prime(x)))
	{
		if (x==32767) x=0;
		else
		x++;
	}
	SYNC(self->driver,writeInt,x);
	x++;
	AFTER(MSEC(100),self, primes, x++);
}