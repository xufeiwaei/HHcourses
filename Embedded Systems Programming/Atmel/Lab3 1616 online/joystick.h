#ifndef JOYSTICK_H
#define JOYSTICK_H
typedef struct{
  Object super;
} Joystick;

#define initJoystick()  {initObject()}
#define CONFKEY  {PORTB=0x80;EIMSK=0x80;PCMSK1=0x80;LCDDR3=0x01;}

int detect(Joystick *self,int sig);

#endif