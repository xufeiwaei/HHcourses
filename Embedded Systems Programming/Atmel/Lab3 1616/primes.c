#include "TinyTimber.h"
#include "lcd.h"
#include "primes.h"
#include "blinker.h"
#include <math.h>

int is_prime(int i)
{
	int n;
	int sqrt_value;
	if(i==0||i==1) return 0;
	else if (i==2) return 1;
	else
	{
		sqrt_value=sqrt(i)+1;
		for(n=2;n<sqrt_value;n++)
		{
			if(i%n==0) return 0;
		}
		return 1;
	}
	
}


int primes(PrimeCalculator *self, int x)
{
	//while(1)
	{
		while(!(is_prime(x)))
		{
			if(x==32767) x=0;
			else x++;
		}
		SYNC(self->lcd,writeInt,x);
		x++;
	}
	AFTER(MSEC(100),self,primes,x++);
}