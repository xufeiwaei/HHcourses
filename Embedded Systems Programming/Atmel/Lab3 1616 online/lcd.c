#include "TinyTimber.h"
#include "lcd.h"
#include <avr/io.h>

#define clrscr {LCDDR0&=0x66;LCDDR1&=0x66;LCDDR2&=0x66;LCDDR5=0x00;LCDDR6=0x00;LCDDR7=0x00;LCDDR10=0x00;LCDDR11=0x00;LCDDR12=0x00;LCDDR15=0x00;LCDDR16=0x00;LCDDR17=0x00;}

static int seg[]={0x1551,0x8110,0x11e1,0x11b1,0x05b0,0x14b1,0x14f1,0x1110,0x15f1,0x15b1};

int  writeDigit(LCD *self, int digitPos)
{
	switch(digitPos%10)
	{
		case 0:
		{
			LCDDR0 = (LCDDR0 & 0xf0) | ((seg[digitPos/10]>>12)&0x000f);
			LCDDR5 = (LCDDR5 & 0xf0) | ((seg[digitPos/10]>>8)&0x000f);
			LCDDR10 = (LCDDR10 & 0xf0) | ((seg[digitPos/10]>>4)&0x000f);
			LCDDR15 = (LCDDR15 & 0xf0) | (seg[digitPos/10]&0x000f);
			break;
		}
		case 1:
		{
			LCDDR0 = (LCDDR0 & 0x0f) | ((seg[digitPos/10]>>8)&0x00f0);
			LCDDR5 = (LCDDR5 & 0x0f) | ((seg[digitPos/10]>>4)&0x00f0);
			LCDDR10 = (LCDDR10 & 0x0f) | ((seg[digitPos/10])&0x00f0);
			LCDDR15 = (LCDDR15 & 0x0f) | ((seg[digitPos/10]<<4)&0x00f0);
			break;
		}
		case 2:
		{
			LCDDR1 = (LCDDR1 & 0xf0) | ((seg[digitPos/10]>>12)&0x000f);
			LCDDR6 = (LCDDR6 & 0xf0) | ((seg[digitPos/10]>>8)&0x000f);
			LCDDR11 = (LCDDR11 & 0xf0) | ((seg[digitPos/10]>>4)&0x000f);
			LCDDR16 = (LCDDR16 & 0xf0) | (seg[digitPos/10]&0x000f);
			break;
		}
		case 3:
		{
			LCDDR1 = (LCDDR1 & 0x0f) | ((seg[digitPos/10]>>8)&0x00f0);
			LCDDR6 = (LCDDR6 & 0x0f) | ((seg[digitPos/10]>>4)&0x00f0);
			LCDDR11 = (LCDDR11 & 0x0f) | ((seg[digitPos/10])&0x00f0);
			LCDDR16 = (LCDDR16 & 0x0f) | ((seg[digitPos/10]<<4)&0x00f0);
			break;
		}
		case 4:
		{
			LCDDR2 = (LCDDR2 & 0xf0) | ((seg[digitPos/10]>>12)&0x000f);
			LCDDR7 = (LCDDR7 & 0xf0) | ((seg[digitPos/10]>>8)&0x000f);
			LCDDR12 = (LCDDR12 & 0xf0) | ((seg[digitPos/10]>>4)&0x000f);
			LCDDR17 = (LCDDR17 & 0xf0) | (seg[digitPos/10]&0x000f);
			break;
		}
		case 5:
		{
			LCDDR2 = (LCDDR2 & 0x0f) | ((seg[digitPos/10]>>8)&0x00f0);
			LCDDR7 = (LCDDR7 & 0x0f) | ((seg[digitPos/10]>>4)&0x00f0);
			LCDDR12 = (LCDDR12 & 0x0f) | ((seg[digitPos/10])&0x00f0);
			LCDDR17 = (LCDDR17 & 0x0f) | ((seg[digitPos/10]<<4)&0x00f0);
			break;
		}
		default:;
	}
}


int  writeInt(LCD *self, int val)
{
	unsigned char a[6],j=5,n=1,k;
	int temp=val;
	
	clrscr;
	
	while(temp/=10) n++;
	if(n>6) n=6;
	k=n;
	while(k--)
	{
		a[j]=val%10;
		val/=10;
		j--;
	}
	j=5;
	while(n--)
	{
		//ASYNC(self,writeDigit,a[j]*10+n);
		switch(j)
		{
			case 0:
			{
				LCDDR0 = (LCDDR0 & 0xf0) | ((seg[a[j]]>>12)&0x000f);
				LCDDR5 = (LCDDR5 & 0xf0) | ((seg[a[j]]>>8)&0x000f);
				LCDDR10 = (LCDDR10 & 0xf0) | ((seg[a[j]]>>4)&0x000f);
				LCDDR15 = (LCDDR15 & 0xf0) | (seg[a[j]]&0x000f);
				break;
			}
			case 1:
			{
				LCDDR0 = (LCDDR0 & 0x0f) | ((seg[a[j]]>>8)&0x00f0);
				LCDDR5 = (LCDDR5 & 0x0f) | ((seg[a[j]]>>4)&0x00f0);
				LCDDR10 = (LCDDR10 & 0x0f) | ((seg[a[j]])&0x00f0);
				LCDDR15 = (LCDDR15 & 0x0f) | ((seg[a[j]]<<4)&0x00f0);
				break;
			}
			case 2:
			{
				LCDDR1 = (LCDDR1 & 0xf0) | ((seg[a[j]]>>12)&0x000f);
				LCDDR6 = (LCDDR6 & 0xf0) | ((seg[a[j]]>>8)&0x000f);
				LCDDR11 = (LCDDR11 & 0xf0) | ((seg[a[j]]>>4)&0x000f);
				LCDDR16 = (LCDDR16 & 0xf0) | (seg[a[j]]&0x000f);
				break;
			}
			case 3:
			{
				LCDDR1 = (LCDDR1 & 0x0f) | ((seg[a[j]]>>8)&0x00f0);
				LCDDR6 = (LCDDR6 & 0x0f) | ((seg[a[j]]>>4)&0x00f0);
				LCDDR11 = (LCDDR11 & 0x0f) | ((seg[a[j]])&0x00f0);
				LCDDR16 = (LCDDR16 & 0x0f) | ((seg[a[j]]<<4)&0x00f0);
				break;
			}
			case 4:
			{
				LCDDR2 = (LCDDR2 & 0xf0) | ((seg[a[j]]>>12)&0x000f);
				LCDDR7 = (LCDDR7 & 0xf0) | ((seg[a[j]]>>8)&0x000f);
				LCDDR12 = (LCDDR12 & 0xf0) | ((seg[a[j]]>>4)&0x000f);
				LCDDR17 = (LCDDR17 & 0xf0) | (seg[a[j]]&0x000f);
				break;
			}
			case 5:
			{
				LCDDR2 = (LCDDR2 & 0x0f) | ((seg[a[j]]>>8)&0x00f0);
				LCDDR7 = (LCDDR7 & 0x0f) | ((seg[a[j]]>>4)&0x00f0);
				LCDDR12 = (LCDDR12 & 0x0f) | ((seg[a[j]])&0x00f0);
				LCDDR17 = (LCDDR17 & 0x0f) | ((seg[a[j]]<<4)&0x00f0);
				break;
			}
			default:;
		}
		j--;
	}
}


int  segmentOn(LCD *self, int segment)
{
	switch(segment)
	{
		case 1: LCDDR0|=0x04;break;
		case 2: LCDDR0|=0x40;break;
		case 3: LCDDR3 =0x01;break;
		case 4: LCDDR1|=0x02;break;
		case 5: LCDDR1|=0x20;break;
		case 7: LCDDR18=0x01;break;
		case 8: LCDDR18=0x01;break;
		case 9: LCDDR2|=0x04;break;
		case 10: LCDDR2|=0x40;break;
	}
}


int  segmentOff(LCD *self, int segment)
{
	switch(segment)
	{
		case 1: LCDDR0&=~0x04;break;
		case 2: LCDDR0&=~0x40;break;
		case 3: LCDDR3 = 0x00;break;
		case 4: LCDDR1&=~0x02;break;
		case 5: LCDDR1&=~0x20;break;
		case 7: LCDDR18= 0x00;break;
		case 8: LCDDR18= 0x00;break;
		case 9: LCDDR2&=~0x04;break;
		case 10: LCDDR2&=~0x40;break;
	}
}
