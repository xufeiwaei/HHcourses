/*
 * lab2.c
 *
 * Created: 2012/11/21 10:43:02
 *  Author: xufei
 */ 

#include <setjmp.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include <math.h>
#include <util/delay.h>
#include "tinythreads.h"

#define beep_on PORTB |=1<<5
#define beep_off PORTB &=(~(1<<5))
mutex m = MUTEX_INIT;

void delay()
{
	TCNT0=0x00;
	TCCR0A=0x02;
	while(TCNT0!=0xb0);
	TCCR0A=0x00;
}


void beep()
{
	unsigned int length=50;
	unsigned char i;
	DDRB |=1<<5;
	for(i=0;i<length;i++)
	{
		beep_on;
		delay();
		beep_off;
		delay();
	}
	DDRB &=~(1<<5);
}

/*

        0      1      2      3      4      5      6      7      8      9
DR0    0001   1000   0001   0001   0000   0001   0001   0001   0001   0001
DR5    0101   0001   0001   0001   0101   0100   0100   0001   0101   0101   
DR10   0101   0001   1110   1011   1011   1011   1111   0001   1111   1011
DR15   0001   0000   0001   0001   0000   0001   0001   0000   0001   0001
       1551   8110   11E1   11B1   05B0   14B1   14F1   1110   15F1   15B1

*/
void writeChar(char ch, int pos)
{
	int n1,n2,n3,n4;
	switch(ch)
	{
		case '0': n1=1; n2=5; n3=5; n4=1;break;
		case '1': n1=8; n2=1; n3=1; n4=0;break;
		case '2': n1=1; n2=1; n3=0xE; n4=1;break;
		case '3': n1=1; n2=1; n3=0xB; n4=1;break;
		case '4': n1=0; n2=5; n3=0xB; n4=0;break;
		case '5': n1=1; n2=4; n3=0xB; n4=1;break;
		case '6': n1=1; n2=4; n3=0xF; n4=1;break;
		case '7': n1=1; n2=1; n3=0x1; n4=0;break;
		case '8': n1=1; n2=5; n3=0xF; n4=1;break;
		case '9': n1=1; n2=5; n3=0xB; n4=1;break;
	}
	switch(pos)
	{
		case 0: LCDDR0  = LCDDR0&0xf0;
		        LCDDR5  = LCDDR5&0xf0;
		        LCDDR10 = LCDDR10&0xf0;
		        LCDDR15 = LCDDR15&0xf0;
		        LCDDR0  = LCDDR0|n1;
		        LCDDR5  = LCDDR5|n2;
		        LCDDR10 = LCDDR10|n3;
		        LCDDR15 = LCDDR15|n4;
				break;
		case 1: LCDDR0  = LCDDR0&0x0f;
		        LCDDR5  = LCDDR5&0x0f;
		        LCDDR10 = LCDDR10&0x0f;
		        LCDDR15 = LCDDR15&0x0f;
		        LCDDR0  = LCDDR0|(n1<<4);
		        LCDDR5  = LCDDR5|(n2<<4);
		        LCDDR10 = LCDDR10|(n3<<4);
		        LCDDR15 = LCDDR15|(n4<<4);
				break;
		case 2: LCDDR1  = LCDDR1&0xf0;
		        LCDDR6  = LCDDR6&0xf0;
		        LCDDR11 = LCDDR11&0xf0;
		        LCDDR16 = LCDDR16&0xf0;
		        LCDDR1  = LCDDR1|n1;
		        LCDDR6  = LCDDR6|n2;
		        LCDDR11 = LCDDR11|n3;
		        LCDDR16 = LCDDR16|n4;
				break;
        case 3: LCDDR1  = LCDDR1&0x0f;
                LCDDR6  = LCDDR6&0x0f;
                LCDDR11 = LCDDR11&0x0f;
                LCDDR16 = LCDDR16&0x0f;
		        LCDDR1  = LCDDR1|(n1<<4);
                LCDDR6  = LCDDR6|(n2<<4);
                LCDDR11 = LCDDR11|(n3<<4);
                LCDDR16 = LCDDR16|(n4<<4);
				break;
		case 4: LCDDR2  = LCDDR2&0xf0;
		        LCDDR7  = LCDDR7&0xf0;
		        LCDDR12 = LCDDR12&0xf0;
		        LCDDR17 = LCDDR17&0xf0;
		        LCDDR2  = LCDDR2|n1;
	        	LCDDR7 = LCDDR7|n2;
		        LCDDR12  = LCDDR12|n3;
		        LCDDR17 = LCDDR17|n4;
				break;
		case 5: LCDDR2  = LCDDR2&0x0f;
		        LCDDR7  = LCDDR7&0x0f;
		        LCDDR12 = LCDDR12&0x0f;
		        LCDDR17 = LCDDR17&0x0f;
		        LCDDR2  = LCDDR2|(n1<<4);
		        LCDDR7 = LCDDR7|(n2<<4);
		        LCDDR12  = LCDDR12|(n3<<4);
		        LCDDR17 = LCDDR17|(n4<<4);
				break;
	}
}	

int longSize(long i)
{
	if (i%10==i)
	{
		return 1;
	}
	else if (i%100==i)
	{
		return 2;
	}
	else if (i%1000==i)
	{
		return 3;
	}
	else if (i%10000==i)
	{
		return 4;
	}
	else if (i%100000==i)
	{
		return 5;
	}
	else
	return 6;
}


void writeLong(long i)
{
	int position = 0;
	char number = '0';
	int num = 0;
	int numsize;
	numsize = longSize(i);
	int j;
	int temp=1;
	
	for (position=0; position<numsize; position++)
	{
        switch (position)
		{
			case 5: num = (i%1000000-i%100000)/100000; number = num+'0';break;
			case 4: num = (i%100000-i%10000)/10000; number = num+'0';break;
			case 3: num = (i%10000-i%1000)/1000; number = num+'0';break;
			case 2: num = (i%1000-i%100)/100; number = num+'0';break;
			case 1: num = (i%100-i%10)/10; number = num+'0';break;
			case 0: num = i%10; number = num+'0';break;
		}
		switch (position)
		{
			case 0:writeChar(number,5);break;
			case 1:writeChar(number,4);break;
			case 2:writeChar(number,3);break;
			case 3:writeChar(number,2);break;
			case 4:writeChar(number,1);break;
			case 5:writeChar(number,0);break;
		}
		
	}
}

int is_prime(long i)
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

void primes()
{
	
	long i = 0;
	for (i=2; i<1000000; i++)
	{
		if ((is_prime(i))==1)
		{
			writeLong(i);
		}
	}
}


void printAt(long num, int pos) {
	int pp = pos;
	writeChar( (num % 100) / 10 + '0', pp);
	pp++;
	writeChar( num % 10 + '0', pp);
}

void computePrimes(int pos) {
	long n;
	for(n = 1; ; n++) {
		if (is_prime(n)) {
			printAt(n, pos);
			_delay_ms(1000);
		}
	}
}

int main() {
	spawn(computePrimes,0);
	computePrimes(3);
}