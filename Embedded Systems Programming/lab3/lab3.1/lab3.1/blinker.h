/*
 * blinker.h
 *
 * Created: 2012/11/27 16:54:12
 *  Author: xufei
 */ 


#ifndef BLINKER_H_
#define BLINKER_H_

typedef struct{
	Object super;
	LCD *driver;
	int segment;
	int halfPeriod;
}Blinker;

#define initBlinker(driver,segment,halfPeriod) {initObject(),driver,segment,halfPeriod}

int blink(Blinker *self, int x);
int startBlinking(Blinker *self, int nothing);
int stopBlinking(Blinker *self, int nothing);
int setPeriod(Blinker *self, int period);

#endif