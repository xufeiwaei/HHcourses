/*
 * lcd.h
 *
 * Created: 2012/11/26 14:15:44
 *  Author: xufei
 */ 
#ifndef lcd_h
#define lcd_h
#include "TinyTimber.h"

typedef struct{
	Object super;
}LCD;

#define initLCD(){initObject()}

#define CONFLCD {LCDCRB = 0xb7; LCDFRR = 0x10; LCDCCR = 0x0f; LCDCRA = 0x80;}

int  writeDigit(LCD *self, int digitPos);
int  writeInt(LCD *self, int val);
int  segmentOn(LCD *self, int segment);
int  segmentOff(LCD *self, int segment);

#endif