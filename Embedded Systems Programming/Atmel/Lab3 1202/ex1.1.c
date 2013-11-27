#include "TinyTimber.h"
#include "lcd.h"

LCD lcdDriver = initLCD(); 
int main(){
  CONFLCD;
  return TINYTIMBER(&lcdDriver,writeInt,12345);
}

