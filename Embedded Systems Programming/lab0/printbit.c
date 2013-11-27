/*
 * checkbit.c
 *
 *  Created on: Nov 9, 2012
 *      Author: xufeiwaei
 */


#include <stdio.h>
/*

  A byte is a sequence of 2 nibbles. It is easy to display them as a
  sequence of 2 hexa.  But we can also display them as a sequence of 8
  bits. We use MSB-------LSB when displaying them.

  Complete the function byteFor(x):

  Assuming that 0<=x<=255, display the byte used to represent it as a
  sequence of 8 bits. For example, number 4 gets displyed as 00000100.

  The function does not return a value, it just prints the byte on
  the screen.

*/
void nibble(int x){
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
void byteFor(int x){
	int j;
	int i;
	j=x/16;
	i=x%16;
	nibble(j);
	nibble(i);
}


/*int main(){
  int i;
  for(i=0;i < 256;i++){
    byteFor(i);
    printf("  ");
    printf("%#4.2X",i); // 4 in total, 2 after base.
    printf("\n");
 }
}*/
