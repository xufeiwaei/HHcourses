/* timers.c */

#include "c6211dsk.h"
#include "c6x.h"

/*-------------------------------------------------------------------------*/
/* timer1_read() - used to read TIMER1 count                               */
/*-------------------------------------------------------------------------*/
int timer1_read(void){

	return(*(unsigned volatile int *)TIMER1_COUNT);
}

/*-------------------------------------------------------------------------*/
/* timer1_start() - used to start TIMER1                                   */
/*-------------------------------------------------------------------------*/
void timer1_start(void){

	*(unsigned volatile int *)TIMER1_CTRL &= 0xff3f;    /* hold the timer    */
	*(unsigned volatile int *)TIMER1_CTRL |= 0x200;     /* use CPU CLK/4     */   
	*(unsigned volatile int *)TIMER1_PRD  |= 0xffffffff;/* set for 32 bit cnt*/
	*(unsigned volatile int *)TIMER1_CTRL |= 0xC0;      /* start the timer   */
} 


/*-------------------------------------------------------------------------*/
/* delay_msec() - used to delay DSP by user specified time in msec         */
/*-------------------------------------------------------------------------*/
void delay_msec(short msec){
/* assume 150 MHz CPU timer period = 4/150 MHz */

  int time_start, timer_limit = (msec*9375)<<2;

  timer1_start();
  time_start = timer1_read();
  while ((timer1_read()-time_start) < timer_limit);
}


