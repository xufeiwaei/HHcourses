#include "TinyTimber.h"
#include "lcd.h"
#include "blinker.h"

LCD lcd = initLCD();
Blinker blinker = initBlinker(&lcd,1000,3);

int main()
{
	CONFLCD;
	return TINYTIMBER(&blinker,startblink,0);
}