#ifndef BLINKER_H
#define BLINKER_H
typedef struct{
  Object super;
  LCD *lcd;
  int segment;
  int period;
} Blinker;

#define initBlinker(device,segment,period)  {initObject(),device,segment,period}

int Blinking(Blinker *self, int on);
int startBlinking(Blinker *self, int nothing);
int stopBlinking(Blinker *self, int nothing);
int setPeriod(Blinker *self, int period);
#endif