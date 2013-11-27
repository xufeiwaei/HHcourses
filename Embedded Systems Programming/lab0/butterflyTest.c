#include<avr/io.h>

int main() {
  LCDCRA  = 0x80;
  LCDCRB  = 0xb7;
  
  LCDDR0  = 0x81;
  LCDDR5  = 0x15;
  LCDDR10 = 0x15;
  LCDDR15 = 0x01;


    LCDDR1  = 0x11;
    LCDDR6  = 0x11;
    LCDDR11 = 0xBE;
    LCDDR16 = 0x11;
    
  LCDDR2  = 0x10;
  LCDDR7 = 0x45;
  LCDDR12  = 0xBB;
  LCDDR17 = 0x10;
}



