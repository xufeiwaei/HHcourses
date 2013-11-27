/*
 * nibbleFor.c
 *
 *  Created on: Nov 9, 2012
 *      Author: xufeiwaei
 */


/*
 * nibbleFor.c
 *
 *  Created on: Nov 9, 2012
 *      Author: xufeiwaei
 */

#include <stdio.h>

/*
  A nibble is a sequence of 4 bits.
  We use MSB--LSB when displaying them (MSB is Most Significant Bit,
  LSB is Least Significant Bit)

  Complete the function nibbleFor(x) to do the following:

  Assuming that 0<=x<=15, print on the screen  the nibble used to represent it as a
  sequence of 4 zeros and ones. For example, the nibble for 4 is 0100.

  The function should not return a value, it should just print the nibble on
  the screen (do NOT include a new line!)

  Given that you only have to deal with 16 different values you might
  want to use the switch-statement when coding your function.

*/
void nibbleFor(int x){
  switch(x)
  {
  case 1: printf("0001");break;
  case 2: printf("0010");break;
  case 3: printf("0011");break;
  case 4: printf("0100");break;
  case 5: printf("0101");break;
  case 6: printf("0110");break;
  case 7: printf("0111");break;
  case 8: printf("1000");break;
  case 9: printf("1001");break;
  case 10: printf("1010");break;
  case 11: printf("1011");break;
  case 12: printf("1100");break;
  case 13: printf("1101");break;
  case 14: printf("1110");break;
  case 15: printf("1111");break;
  default: printf("0000");break;
  }
}

/*int main(){
  int i;
  for(i=0;i<16;i++){
    nibbleFor(i);
    printf("%s%#X",":  ",i); // shows the hexa digit too!
    printf("\n");
  }
}*/
