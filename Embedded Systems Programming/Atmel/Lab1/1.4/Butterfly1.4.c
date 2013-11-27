/*
 * Butterfly1.4.c
 *
 * Created: 2012/11/14 18:31:46
 *  Author: Sun Gao
 */ 


#include <avr/io.h>
#include <math.h>

#define blink_off LCDDR8=0x00
#define blink_on  LCDDR8=0x01



static int seg[]={0x1551,0x8110,0x11e1,0x11b1,0x05b0,0x14b1,0x14f1,0x1110,0x15f1,0x15b1};

long i=100000000;

void lcd_int(void)
{
	LCDCRA  = 0x80;
	LCDCRB  = 0xb7;
}

void writeChar(char ch,int pos)
{
	if(ch>=0x30&&ch<=0x39)
	{
		switch(pos)
		{
			case 0:
			{
				LCDDR0 = (LCDDR0 & 0xf0) | ((seg[ch-0x30]>>12)&0x000f);
				LCDDR5 = (LCDDR5 & 0xf0) | ((seg[ch-0x30]>>8)&0x000f);
				LCDDR10 = (LCDDR10 & 0xf0) | ((seg[ch-0x30]>>4)&0x000f);
				LCDDR15 = (LCDDR15 & 0xf0) | (seg[ch-0x30]&0x000f);
				break;
			}
			case 1:
			{
				LCDDR0 = (LCDDR0 & 0x0f) | ((seg[ch-0x30]>>8)&0x00f0);
				LCDDR5 = (LCDDR5 & 0x0f) | ((seg[ch-0x30]>>4)&0x00f0);
				LCDDR10 = (LCDDR10 & 0x0f) | ((seg[ch-0x30])&0x00f0);
				LCDDR15 = (LCDDR15 & 0x0f) | ((seg[ch-0x30]<<4)&0x00f0);
				break;
			}
			case 2:
			{
				LCDDR1 = (LCDDR1 & 0xf0) | ((seg[ch-0x30]>>12)&0x000f);
				LCDDR6 = (LCDDR6 & 0xf0) | ((seg[ch-0x30]>>8)&0x000f);
				LCDDR11 = (LCDDR11 & 0xf0) | ((seg[ch-0x30]>>4)&0x000f);
				LCDDR16 = (LCDDR16 & 0xf0) | (seg[ch-0x30]&0x000f);
				break;
			}
			case 3:
			{
				LCDDR1 = (LCDDR1 & 0x0f) | ((seg[ch-0x30]>>8)&0x00f0);
				LCDDR6 = (LCDDR6 & 0x0f) | ((seg[ch-0x30]>>4)&0x00f0);
				LCDDR11 = (LCDDR11 & 0x0f) | ((seg[ch-0x30])&0x00f0);
				LCDDR16 = (LCDDR16 & 0x0f) | ((seg[ch-0x30]<<4)&0x00f0);
				break;
			}
			case 4:
			{
				LCDDR2 = (LCDDR2 & 0xf0) | ((seg[ch-0x30]>>12)&0x000f);
				LCDDR7 = (LCDDR7 & 0xf0) | ((seg[ch-0x30]>>8)&0x000f);
				LCDDR12 = (LCDDR12 & 0xf0) | ((seg[ch-0x30]>>4)&0x000f);
				LCDDR17 = (LCDDR17 & 0xf0) | (seg[ch-0x30]&0x000f);
				break;
			}
			case 5:
			{
				LCDDR2 = (LCDDR2 & 0x0f) | ((seg[ch-0x30]>>8)&0x00f0);
				LCDDR7 = (LCDDR7 & 0x0f) | ((seg[ch-0x30]>>4)&0x00f0);
				LCDDR12 = (LCDDR12 & 0x0f) | ((seg[ch-0x30])&0x00f0);
				LCDDR17 = (LCDDR17 & 0x0f) | ((seg[ch-0x30]<<4)&0x00f0);
				break;
			}
			default:;
		}
	}
}



void writeLong(long i)
{
	unsigned char a[6],j=5,n=1,k;
	long temp=i;
	while(temp/=10) n++;
	if(n>6) n=6;
	k=n;
	while(k--)
	{
		a[j]=i%10;
		i/=10;
		j--;
	}
	j=5;
	while(n--)
	{
		writeChar(a[j]+0x30,j);
		j--;
	}
}


int is_prime(long i)
{
	long n;
	long sqrt_value;
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


void primes(void)
{
	//long i=0;
	//while(1)
	{
		while(!(is_prime(i))) i++;
		writeLong(i);
		i++;
	}
}




void disp_on(void)
{
	

	LCDDR3=0x01;
	LCDDR13=0x00;
}

void disp_off(void)
{
	
	LCDDR3=0x00;
	LCDDR13=0x01;
	
}



void button(void)
{
	//PORTB |=1<<7;
	//LCDDR13=0x01;

	//while(1)
	{
		if((PINB&(1<<7))) disp_on();
		else disp_off();
	}
}




void blink(void)
{
	{
		
		if(TCNT1<15625) blink_off;
	
		else if(TCNT1<31250)
		{
			blink_on;
		}
		
		else TCNT1=0;
	}
	
}




int main(void)
{
	PORTB |=1<<7;
	TCCR1B=0x04;
	CLKPR=0x80;
	CLKPR=0x00;
	lcd_int();
	while(1)
	{
		primes();
		button();
		blink();
	}
}