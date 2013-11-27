#ifndef LCD_H
#define LCD_H
#include <avr/io.h>
typedef struct{
  Object super;
} LCD;

#define initLCD()  {initObject()}
#define CONFLCD {LCDCRB = 0xb7; LCDFRR = 0x10; LCDCCR = 0x0f; LCDCRA = 0x80;}

int  writeDigit(LCD *self, int digitPos);
int  writeInt(LCD *self, int val);
int  segmentOn(LCD *self, int segment);
int  segmentOff(LCD *self, int segment);
#endif