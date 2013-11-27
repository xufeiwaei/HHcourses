/*
 * chebit.c
 *
 *  Created on: Nov 9, 2012
 *      Author: xufeiwaei
 */
#include <stdio.h>

int isSet(int x, int n){
	int i;
	i=1;
	i=i<<n;
	x=x&i;
	if(x==0)
		return 0;
	else
		return 1;
}


int isClr(int x, int n){
	/*int size1 = sizeof(int)*8;
		int bit[size1];
		int i;
		for(i=0;i<size1;i++)
		{
			bit[i]=x%(10^i);
		}
		if(bit[n]==0)
			return 1;
		else
			return 0;*/
	int i;
		i=1;
		i=i<<n;
		x=x&i;
		if(x==0)
			return 1;
		else
			return 0;
}

int set(int x, int n){
	int i;
	i=1;
	i=i<<n;
	x=x|i;
	return x;
}


int clr(int x, int n){
	int i;
	i=1;
	i=i<<n;
	i=~i;
	x=x&i;
	return x;
}

/*
many tests (ask if you do not understand!)
*/
/*int main(){
  int size = sizeof(int)*8;
  int i,j;

  for(j=0;j<300;j++){
    printf("%d\n",j);
    for(i = 0; i < size; i++)
      printf("%d",isSet(j,i));
    printf("\n");
    for(i = 0; i < size; i++)
      printf("%d",isClr(j,i));

    printf("\n");
  }

  printf("\n\n\n");

  printf("%d\n",65535);
  for(i = 0; i < size; i++)
    printf("%d",isSet(65535,i));
  printf("\n");
  for(i = 0; i < size; i++)
    printf("%d",isClr(65535,i));

  printf("\n");


  printf("\n\n\n");
  for(i = 0; i < size; i++)
    printf("%d",isSet(set(0,5),i));
  printf("\n");

  for(i = 0; i < size; i++)
    printf("%d",isSet(set(10,31),i));
  printf("\n");


  for(i = 0; i < size; i++)
    printf("%d",isSet(clr(1,0),i));
  printf("\n");

  for(i = 0; i < size; i++)
    printf("%d",isSet(clr(255,3),i));
  printf("\n");
}/*

