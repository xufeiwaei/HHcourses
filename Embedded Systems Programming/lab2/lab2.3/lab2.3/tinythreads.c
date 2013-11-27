#include <setjmp.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "tinythreads.h"

#define NULL            0
#define DISABLE()       cli()
#define ENABLE()        sei()
#define STACKSIZE       80
#define NTHREADS        4
#define SETSTACK(buf,a) *((unsigned int *)(buf)+8) = (unsigned int)(a) + STACKSIZE - 4; \
                        *((unsigned int *)(buf)+9) = (unsigned int)(a) + STACKSIZE - 4

struct thread_block {
    void (*function)(int);   // code to run
    int arg;                 // argument to the above
    thread next;             // for use in linked lists
    jmp_buf context;         // machine state
    char stack[STACKSIZE];   // execution stack space
};

struct thread_block threads[NTHREADS];

struct thread_block initp;

thread freeQ   = threads;
thread readyQ  = NULL;
thread current = &initp;

int initialized = 0;

static void initialize(void) {
    int i;
	PORTB = 0x80;		
	EIMSK = 0x80;
	PCMSK1 = 0x80;
	
	TCNT1 = 0;
	TCCR1B = 0x04;
	OCR1A = 0x3D09;	;//change the time slicing
    /*TCCR1B = 0x1D;
	ICR1 = 0x0186;*/

	// initialize of timer
	TIMSK2 = 0x00;
	ASSR   = 0x08;
	TCNT2  = 0x00;
	OCR2A  = 50;
	TCCR2A = 0x0B;
	
	while(0x07 & ASSR);
	
	TIFR2  = 0x00;
	TIMSK2 = 0x02;
	
	LCDCRA  = 0x80;
	LCDCRB  = 0xB7;
    for (i=0; i<NTHREADS-1; i++)
        threads[i].next = &threads[i+1];
    threads[NTHREADS-1].next = NULL;
    initialized = 1;
}

static void enqueue(thread p, thread *queue) {
    p->next = NULL;
    if (*queue == NULL) {
        *queue = p;
    } else {
        thread q = *queue;
        while (q->next)
            q = q->next;
        q->next = p;
    }
}

static thread dequeue(thread *queue) {
    thread p = *queue;
    if (*queue) {
        *queue = (*queue)->next;
    } else {
        // Empty queue, kernel panic!!!
        while (1) ;  // not much else to do...
    }
    return p;
}

static void dispatch(thread next) {
    if (setjmp(current->context) == 0) {
        current = next;
        longjmp(next->context,1);
    }
}

void spawn(void (* function)(int), int arg) {
   thread newp;

   DISABLE();
   if (!initialized) initialize();

   newp = dequeue(&freeQ);
   newp->function = function;
   newp->arg = arg;
   newp->next = NULL;
   if (setjmp(newp->context) == 1) {
	   ENABLE();
	   current->function(current->arg);
	   DISABLE();
	   enqueue(current, &freeQ);
	   dispatch(dequeue(&readyQ));
   }
   SETSTACK(&newp->context, &newp->stack);

   enqueue(newp, &readyQ);
   ENABLE();
}

ISR(SIG_PIN_CHANGE1){
	if ((PINB&PORTB)!=PORTB)
	{
		yield();
	}
}

ISR(SIG_OUTPUT_COMPARE2){
	yield();
}

void yield(void) {
	enqueue(current, &readyQ);
	dispatch(dequeue(&readyQ));
}

void lock(mutex *m)
{
}

void unlock(mutex *m)
{
}
