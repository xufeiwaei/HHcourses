#ifndef PIEZO_H
#define PIEZO_H
#include <avr/io.h> 
typedef struct{
  Object super;
} Piezo;


#define initPiezo()  {initObject()}
#define ENPIEZO DDRB|=1<<5

int  PiezoOn(Piezo *self, int nothing);
int  PiezoOff(Piezo *self, int nothing);
#endif
