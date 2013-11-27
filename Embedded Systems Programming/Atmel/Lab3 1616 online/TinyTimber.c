// The Timber compiler <timber-lang.org>
// 
// Copyright 2008-2012 Johan Nordlander <nordland@csee.ltu.se>
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 
// 3. Neither the names of the copyright holder and any identified
//    contributors, nor the names of their affiliations, may be used to 
//    endorse or promote products derived from this software without 
//    specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTORS ``AS IS'' AND ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

/*
 * 
 * TinyTimber.c
 *
 */

#include "TinyTimber.h"

void DUMPC(char);

void DUMP(char *s) {
  while (*s)
    DUMPC(*s++);
}

char hex[] = "0123456789ABCDEF";

void DUMPH(unsigned int val) {
    char buf[8];
    int i = 0;
    do {
        buf[i++] = hex[val & 0x0F];
        val = val >> 4;
    } while (val);
    while (i)
        DUMPC(buf[--i]);
}


#if defined(__AVR_ATmega169__) || defined(__AVR_ATmega169P__) // AVR ATmega169 Butterfly dependencies

#include <setjmp.h>
#include <avr/io.h>
#include <avr/interrupt.h>


#define STACKSIZE       96
#define NMSGS           15
#define NTHREADS        4

#define STATUS()        (SREG & 0x80)
#define DISABLE(s)      { s = STATUS(); cli(); }
#define ENABLE(s)       if (s) sei();
#define SLEEP()         { SMCR = 0x01; __asm__ __volatile__ ("sleep" ::); }
#define PANIC()         { LCDDR0 = 0xFF; LCDDR1 = 0xFF; LCDDR2 = 0xFF; while (1) SLEEP(); }
                        // Light up the display...
#define SETSTACK(buf,a) { *((unsigned int *)(buf)+8) = (unsigned int)(a) + STACKSIZE - 4; \
                          *((unsigned int *)(buf)+9) = (unsigned int)(a) + STACKSIZE - 4; }
#define SETPC(buf, a)   *((unsigned int *)((unsigned char *)(buf) + 21)) = (unsigned int)(a)

#define TIMER_INIT()    { CLKPR = 0x80; CLKPR = 0x00; \
                          TCNT1 = 0x0000; TCCR1B = 0x04; TIMSK1 = 0x01; }
                        // No system clock prescaling
                        // Normal mode, clk/256 prescaling, enable timer overflow interrupts
#define TIMER_OCLR()    // No timer overflow interrupt clear necessary
#define TIMER_CCLR()    // No timer compare interrupt clear necessary
#define TIMERGET(x)     (x) = ((Time)overflows << 16) | (unsigned int)TCNT1; \
                        if (TIFR1 & 0x01) (x) = ((Time)(overflows+1) << 16) | (unsigned int)TCNT1;
#define TIMERSET(x)     { if ((x) && (HIGH16((x)->baseline) == overflows)) { \
                             OCR1A = MAX(LOW16((x)->baseline), (unsigned int)TCNT1+1); \
                             TIMSK1 |= 0x02; \
                          } else \
                             TIMSK1 &= ~0x02; \
                        }
#define HIGH16(x)       (int)((x) >> 16)
#define LOW16(x)        (unsigned int)((x) & 0xffff)
#define MAX(a,b)        ( (a)-(b) <= 0 ? (b) : (a) )
#define INFINITY        0x7fffffffL
#define INF(a)          ( (a)==0 ? INFINITY : (a) )

void DUMP_INIT() {

}

void DUMPC(char c) {
    
}

#elif defined(__AVR_ATmega32__)    // AVR ATmega32 dependencies -------------------------------

#include <setjmp.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#define STACKSIZE       130
#define NMSGS           20
#define NTHREADS        5

#define STATUS()        (SREG & 0x80)
#define DISABLE(s)      { s = STATUS(); cli(); }
#define ENABLE(s)       if (s) sei();
#define SLEEP()         { MCUCR = 0x80; __asm__ __volatile__ ("sleep" ::); }
#define PANIC()         { while (1) SLEEP(); }

#define SETSTACK(buf,a) { *((unsigned int *)(buf)+8) = (unsigned int)(a) + STACKSIZE - 4; \
                          *((unsigned int *)(buf)+9) = (unsigned int)(a) + STACKSIZE - 4; }
#define SETPC(buf, a)   *((unsigned int *)((unsigned char *)(buf) + 21)) = (unsigned int)(a)

#define TIMER_INIT()    { TCNT1 = 0x0000; TCCR1B = 0x02; TIMSK = 0x04; }
                        // Normal mode, clk/8 prescaling, enable timer overflow interrupts
#define TIMER_OCLR()    // No timer overflow interrupt clear necessary
#define TIMER_CCLR()    // No timer compare interrupt clear necessary
#define TIMERGET(x)     (x) = ((Time)overflows << 16) | (unsigned int)TCNT1; \
                        if (TIFR & 0x04) (x) = ((Time)(overflows+1) << 16) | (unsigned int)TCNT1;
#define TIMERSET(x)     { if ((x) && (HIGH16((x)->baseline) == overflows)) { \
                             OCR1A = MAX(LOW16((x)->baseline), (unsigned int)TCNT1+1); \
                             TIMSK |= 0x10; \
                          } else \
                             TIMSK &= ~0x10; \
                        }
#define HIGH16(x)       (int)((x) >> 16)
#define LOW16(x)        (unsigned int)((x) & 0xffff)
#define MAX(a,b)        ( (a)-(b) <= 0 ? (b) : (a) )
#define INFINITY        0x7fffffffL
#define INF(a)          ( (a)==0 ? INFINITY : (a) )

void DUMP_INIT() {

}

void DUMPC(char c) {
    
}

#elif defined(__HCS12__)    // Freescale HCS112 dependencies -----------------------------

#include <setjmp.h>
#include <machine/hcs12/ect.h>
                        
#define ECT             ((Ect *) 0x0040)
                        
#define STACKSIZE       1000
#define NMSGS           30
#define NTHREADS        4

void sei( void )        { __asm( " sei" );	}
void cli( void )        { __asm( " cli" ); }
char ccr( void )        { __asm( " tfr ccr,b" ); }

#define STATUS()        (!(ccr() & 0x10))
#define DISABLE(s)      { s = STATUS(); sei(); }
#define ENABLE(s)	    { if (s) cli(); }
#define SLEEP()         { __asm(" wai"); }


#define PANIC()         { DUMP("PANIC!!!"); while (1) SLEEP(); }

#define SETSTACK(buf,a) { *((unsigned short int *)(buf)) = (unsigned short int)(a) + STACKSIZE - 4; \
                          *((unsigned short int *)((unsigned char *)(buf) + 5 )) = \
                          (unsigned short int)(a) + STACKSIZE - 4; }
#ifdef __LARGE
#define SETPC(buf, a)   { *((unsigned short int *)(buf) + 1) = (unsigned short int)(a); \
			              *((unsigned char *)(buf) + 4) = (unsigned char)(0x30);}
#else
#define SETPC(buf, a)   *((unsigned short int *)(buf) + 1) = (unsigned short int)(a)
#endif

#define TIMER_INIT()    { ECT->tscr1 = 0x80; ECT->tscr2 = 0x84; ECT->tios = 0x01; } 
                        // tcsr1 = 0x80: timer enable, 
			// tcsr2 = 0x84: enable timer overflow interrupt, clk/16 prescaling
                        //         1/(24 000 000 / 16) = 2/3 us period, 65535*2/3 us = 2/3*65.53 ms
			// tios =  0x01: enable output compare on timer channel 0

#define TIMER_OCLR()    { ECT->tflg2 = 0x80; }  // Timer overflow interrupt clear

#define TIMER_CCLR()    { ECT->tflg1 = 0x01; }  // Timer compare interrupt clear

#define TIMERGET(x)	{ \
			    *((short int *)(&(x))) = ECT->tflg2 & 0x80 ? overflows+1 : overflows; \
                            *(((short int *)&(x))+1) = ECT->tcnt; \
                            if (ECT->tflg2 & 0x80) { \
                                *((short int *)(&(x))) = overflows+1; \
                                *(((short int *)&(x))+1) = ECT->tcnt; \
                            } \
                        }
				
#define TIMERSET(x)     { if ((x) && (HIGH16((x)->baseline) == overflows)) { \
                            unsigned int low16 = LOW16((x)->baseline); \
                            unsigned int tcnt1 = ECT->tcnt+4; \
                            if ((low16 < tcnt1) || (ECT->tflg2 & 0x80)) low16 = tcnt1; \
                            ECT->tc0 = low16; \
                            ECT->tier |= 0x1; \
                          } else \
                            ECT->tier &= ~0x1; \
                        }
                        
#define HIGH16(x)       *((short int*)&(x))
#define LOW16(x)        ((short int)x & 0xffff )
#define MAX(a,b)        ( (a)-(b) <= 0 ? (b) : (a) )
#define INFINITY        0x7fffffffL
#define INF(a)          ( (a)==0 ? INFINITY : (a) )

#include <machine/hcs12.h>
#include <machine/hcs12/sci.h>

#define	SCI_PORT	((volatile SCI*)SCI0BD)

void DUMP_INIT() {
    SCI_PORT->scicr2 = 0;
    SCI_PORT->scibd = 156;                // BAUD rate 9600 at 24 MHz
    SCI_PORT->scicr2 = TE;                // Enable transmitt
}

void DUMPC(char c) {
    /* output character to SCI0 */
    while ((SCI_PORT->scisr1 & TDRE) == 0)
        ; /* spin for TDRE==1 */
    SCI_PORT->scidrl = (unsigned char)c;
}


#endif  // Target dependencies ---------------------------------------------------------------


typedef struct thread_block *Thread;

#define INSTALLED_TAG (Thread)1

struct msg_block {
    Msg next;                // for use in linked lists
    Time baseline;           // event time reference point
    Time deadline;           // absolute deadline (=priority)
    Object *to;              // receiving object
    Method method;           // code to run
    int arg;                 // argument to the above
};

struct thread_block {
    Thread next;             // for use in linked lists
    Msg msg;                 // message under execution
    Object *waitsFor;        // deadlock detection link
    jmp_buf context;         // machine state
};

struct stack {
    unsigned char stack[STACKSIZE];
};

struct msg_block    messages[NMSGS];
struct thread_block threads[NTHREADS];
struct stack        stacks[NTHREADS];

struct thread_block thread0;

Msg msgPool         = messages;
Msg msgQ            = NULL;
Msg timerQ          = NULL;
Time timestamp      = 0;
int overflows       = 0;

Thread threadPool   = threads;
Thread activeStack  = &thread0;
Thread current      = &thread0;

Method  mtable[N_VECTORS];
Object *otable[N_VECTORS];

static void schedule(void);

#if defined(__AVR_ATmega169__) || defined(__AVR_ATmega169P__) // AVR ATmega169 Butterfly dependencies 


#define TIMER_COMPARE_INTERRUPT  ISR(TIMER1_COMPA_vect)
#define TIMER_OVERFLOW_INTERRUPT ISR(TIMER1_OVF_vect)

#define IRQ(n,v) ISR(v) { TIMERGET(timestamp); if (mtable[n]) mtable[n](otable[n],n); schedule(); }

IRQ(IRQ_INT0,            INT0_vect);
IRQ(IRQ_PCINT0,          PCINT0_vect);
IRQ(IRQ_PCINT1,          PCINT1_vect);
IRQ(IRQ_TIMER2_COMP,     TIMER2_COMP_vect);
IRQ(IRQ_TIMER2_OVF,      TIMER2_OVF_vect);
IRQ(IRQ_TIMER0_COMP,     TIMER0_COMP_vect);
IRQ(IRQ_TIMER0_OVF,      TIMER0_OVF_vect);
IRQ(IRQ_SPI_STC,         SPI_STC_vect);
IRQ(IRQ_USART0_RX,       USART0_RX_vect);
IRQ(IRQ_USART0_UDRE,     USART0_UDRE_vect);
IRQ(IRQ_USART0_TX,       USART0_TX_vect);
IRQ(IRQ_USI_START,       USI_START_vect);
IRQ(IRQ_USI_OVERFLOW,    USI_OVERFLOW_vect);
IRQ(IRQ_ANALOG_COMP,     ANALOG_COMP_vect);
IRQ(IRQ_ADC,             ADC_vect);
IRQ(IRQ_EE_READY,        EE_READY_vect);
IRQ(IRQ_SPM_READY,       SPM_READY_vect);
IRQ(IRQ_LCD,             LCD_vect);


#elif defined(__AVR_ATmega32__)    // AVR ATmega32 dependencies -------------------------------


#define TIMER_COMPARE_INTERRUPT  ISR(TIMER1_COMPA_vect)
#define TIMER_OVERFLOW_INTERRUPT ISR(TIMER1_OVF_vect)

#define IRQ(n,v) ISR(v) { TIMERGET(timestamp); if (mtable[n]) mtable[n](otable[n],n); schedule(); }

IRQ(IRQ_INT0,            INT0_vect);
IRQ(IRQ_INT1,            INT1_vect);
IRQ(IRQ_INT2,            INT2_vect);
IRQ(IRQ_TIMER2_COMP,     TIMER2_COMP_vect);
IRQ(IRQ_TIMER2_OVF,      TIMER2_OVF_vect);
IRQ(IRQ_TIMER0_COMP,     TIMER0_COMP_vect);
IRQ(IRQ_TIMER0_OVF,      TIMER0_OVF_vect);
IRQ(IRQ_SPI_STC,         SPI_STC_vect);
IRQ(IRQ_USART_RXC,       USART_RXC_vect);
IRQ(IRQ_USART_UDRE,      USART_UDRE_vect);
IRQ(IRQ_USART_TXC,       USART_TXC_vect);
IRQ(IRQ_ADC,             ADC_vect);
IRQ(IRQ_EE_RDY,          EE_RDY_vect);
IRQ(IRQ_ANA_COMP,        ANA_COMP_vect);
IRQ(IRQ_TWI,             TWI_vect);
IRQ(IRQ_SPM_RDY,         SPM_RDY_vect);


#elif defined(__HCS12__)   // Freescale HCS12 dependencies -------------------------------

#define IRQ(n,v) __interrupt void v (void) { \
        char status; DISABLE(status); TIMERGET(timestamp); \
        if (mtable[n]) mtable[n](otable[n],n); \
        schedule(); ENABLE(status); \
}

IRQ(IRQ_PWMEShutdown,    vect_PWMEShutdown);
IRQ(IRQ_PortPInt,        vect_PortPInt);

IRQ(IRQ_MSCAN4Tx,        vect_MSCAN4Tx);
IRQ(IRQ_MSCAN4Rx,        vect_MSCAN4Rx);
IRQ(IRQ_MSCAN4Errs,      vect_MSCAN4Errs);
IRQ(IRQ_MSCAN4WakeUp,    vect_MSCAN4WakeUp);

IRQ(IRQ_BFGen,           vect_BFGen);
IRQ(IRQ_BFSync,          vect_BFSync);
IRQ(IRQ_BFRec,           vect_BFRec);
IRQ(IRQ_BFRx,            vect_BFRx);
IRQ(IRQ_MSCAN1Tx,        vect_MSCAN1Tx);
IRQ(IRQ_MSCAN1Rx,        vect_MSCAN1Rx);
IRQ(IRQ_MSCAN1Errs,      vect_MSCAN1Errs);
IRQ(IRQ_MSCAN1WakeUp,    vect_MSCAN1WakeUp);

IRQ(IRQ_MSCAN0Tx,        vect_MSCAN0Tx);
IRQ(IRQ_MSCAN0Rx,        vect_MSCAN0Rx);
IRQ(IRQ_MSCAN0Errs,      vect_MSCAN0Errs);
IRQ(IRQ_MSCAN0WakeUp,    vect_MSCAN0WakeUp);
IRQ(IRQ_Flash,           vect_Flash);
IRQ(IRQ_EEPROM,          vect_EEPROM);
IRQ(IRQ_SPI1,            vect_SPI1);

IRQ(IRQ_IICBus,          vect_IICBus);
IRQ(IRQ_DLC,             vect_DLC);
IRQ(IRQ_SCMEVect,        vect_SCMEVect);
IRQ(IRQ_CRGLock,         vect_CRGLock);
IRQ(IRQ_PACCBOv,         vect_PACCBOv);
IRQ(IRQ_ModDnCtr,        vect_ModDnCtr);
IRQ(IRQ_PortHInt,        vect_PortHInt);
IRQ(IRQ_PortJInt,        vect_PortJInt);

IRQ(IRQ_ATD1,            vect_ATD1);
IRQ(IRQ_ATD0,            vect_ATD0);
IRQ(IRQ_VSCI1,           vect_VSCI1);
IRQ(IRQ_VSCI0,           vect_VSCI0);
IRQ(IRQ_SPI0,            vect_SPI0);
IRQ(IRQ_PACCAEdge,       vect_PACCAEdge);
IRQ(IRQ_PACCAOv,         vect_PACCAOv);

IRQ(IRQ_TimerCh7,        vect_TimerCh7);
IRQ(IRQ_TimerCh6,        vect_TimerCh6);
IRQ(IRQ_TimerCh5,        vect_TimerCh5);
IRQ(IRQ_TimerCh4,        vect_TimerCh4);
IRQ(IRQ_TimerCh3,        vect_TimerCh3);
IRQ(IRQ_TimerCh2,        vect_TimerCh2);
IRQ(IRQ_TimerCh1,        vect_TimerCh1);

IRQ(IRQ_RTI,             vect_RTI);
IRQ(IRQ_IRQ,             vect_IRQ);
IRQ(IRQ_XIRQ,            vect_XIRQ);

__interrupt void reserved_TimerCh0( void );
__interrupt void reserved_TimerOv( void );

#define TIMER_COMPARE_INTERRUPT __interrupt void reserved_TimerCh0( void ) 
#define TIMER_OVERFLOW_INTERRUPT __interrupt void reserved_TimerOv( void )

#define reserved            ((Method)0xFFFF)

#define reserved_SWI        reserved
#define reserved_Illop      reserved
#define reserved_COPFail    reserved
#define reserved_ClockFail  reserved

typedef void (*Handler)(void);

#pragma	DATA vectors
__interrupt Handler irqvecs[] = {
	vect_PWMEShutdown,      // FF8C
	vect_PortPInt,          // FF8E

	vect_MSCAN4Tx,          // FF90
	vect_MSCAN4Rx,          // FF92
	vect_MSCAN4Errs,        // FF94
	vect_MSCAN4WakeUp,      // FF96
	reserved,               // FF98
	reserved,               // FF9A
	reserved,               // FF9C
	reserved,               // FF9E

	vect_BFGen,             // FFA0
	vect_BFSync,            // FFA2
	vect_BFRec,             // FFA4
	vect_BFRx,              // FFA6
	vect_MSCAN1Tx,          // FFA8
	vect_MSCAN1Rx,          // FFAA
	vect_MSCAN1Errs,        // FFAC
	vect_MSCAN1WakeUp,      // FFAE

	vect_MSCAN0Tx,          // FFB0
	vect_MSCAN0Rx,          // FFB2
	vect_MSCAN0Errs,        // FFB4
	vect_MSCAN0WakeUp,      // FFB6
	vect_Flash,             // FFB8
	vect_EEPROM,            // FFBA
	reserved,               // FFBC
	vect_SPI1,              // FFBE

	vect_IICBus,            // FFC0
	vect_DLC,               // FFC2
	vect_SCMEVect,          // FFC4
	vect_CRGLock,           // FFC6
	vect_PACCBOv,           // FFC8
	vect_ModDnCtr,          // FFCA
	vect_PortHInt,          // FFCC
	vect_PortJInt,          // FFCE

	vect_ATD1,              // FFD0
	vect_ATD0,              // FFD2
	vect_VSCI1,             // FFD4
	vect_VSCI0,             // FFD6
	vect_SPI0,              // FFD8
	vect_PACCAEdge,         // FFDA
	vect_PACCAOv,           // FFDC
	reserved_TimerOv,       // FFDE

	vect_TimerCh7,          // FFE0
	vect_TimerCh6,          // FFE2
	vect_TimerCh5,          // FFE4
	vect_TimerCh4,          // FFE6
	vect_TimerCh3,          // FFE8
	vect_TimerCh2,          // FFEA
	vect_TimerCh1,          // FFEC
	reserved_TimerCh0,      // FFEE

	vect_RTI,               // FFF0
	vect_IRQ,               // FFF2
	vect_XIRQ,              // FFF4
	reserved_SWI,           // FFF6
	reserved_Illop,         // FFF8
	reserved_COPFail,       // FFFA
	reserved_ClockFail      // FFFC
	// reset vector handled by generic startup code
};
#pragma	DATA default

#endif

/* queue manager */
void enqueueByDeadline(Msg p, Msg *queue) {
    Msg prev = NULL, q = *queue;
    while (q && (q->deadline <= p->deadline)) {
        prev = q;
        q = q->next;
    }
    p->next = q;
    if (prev == NULL)
        *queue = p;
    else
        prev->next = p;
}

void enqueueByBaseline(Msg p, Msg *queue) {
    Msg prev = NULL, q = *queue;
    while (q && (q->baseline <= p->baseline )) {
        prev = q;
        q = q->next;
    }
    p->next = q;
    if (prev == NULL)
        *queue = p;
    else
        prev->next = p;
}

Msg dequeue(Msg *queue) {
    Msg m = *queue;
    if (m)
        *queue = m->next;
    else
        PANIC();  // Empty queue, kernel panic!!!
    return m;
}

void insert(Msg m, Msg *queue) {
    m->next = *queue;
    *queue = m;
}

void push(Thread t, Thread *stack) {
    t->next = *stack;
    *stack = t;
}

Thread pop(Thread *stack) {
    Thread t = *stack;
    *stack = t->next;
    return t;
}

static int remove(Msg m, Msg *queue) {
    Msg prev = NULL, q = *queue;
    while (q && (q != m)) {
        prev = q;
        q = q->next;
    }
    if (q) {
        if (prev)
            prev->next = q->next;
        else
            *queue = q->next;
        return 1;
    }
    return 0;
}

TIMER_OVERFLOW_INTERRUPT {
    TIMER_OCLR();
    overflows++;
    TIMERSET(timerQ);
}

TIMER_COMPARE_INTERRUPT {
    Time now;
    TIMER_CCLR();
    TIMERGET(now);
    while (timerQ && (timerQ->baseline - now <= 0))
        enqueueByDeadline( dequeue(&timerQ), &msgQ );
    TIMERSET(timerQ);
    schedule();
}

/* context switching */
static void dispatch( Thread next ) {
    if (setjmp( current->context ) == 0) {
        current = next;
        longjmp( next->context, 1 );
    }
}

static void run(void) {
    while (1) {
        Msg this = current->msg = dequeue(&msgQ);
        Msg oldMsg;
        char status = 1;
        
        ENABLE(status);
        SYNC(this->to, this->method, this->arg);
        DISABLE(status);
        insert(this, &msgPool);
       
        oldMsg = activeStack->next->msg;
        if (!msgQ || (oldMsg && (msgQ->deadline - oldMsg->deadline > 0))) {
            Thread t;
            push(pop(&activeStack), &threadPool);
            t = activeStack;  // can't be NULL, may be &thread0
            while (t->waitsFor) 
	            t = t->waitsFor->ownedBy;
            dispatch(t);
        }
    }
}

static void idle(void) {
    schedule();
    ENABLE(1);
    while (1) {
        SLEEP();
    }
}

static void schedule(void) {
    Msg topMsg = activeStack->msg;
    if (msgQ && threadPool && ((!topMsg) || (msgQ->deadline - topMsg->deadline < 0))) {
        push(pop(&threadPool), &activeStack);
        dispatch(activeStack);
    }
}

/* communication primitives */
Msg async(Time bl, Time dl, Object *to, Method meth, int arg) {
    Msg m;
    Time now;
    char status;
    DISABLE(status);
    m = dequeue(&msgPool);
    m->to = to; 
    m->method = meth; 
    m->arg = arg;
    m->baseline = (status ? current->msg->baseline : timestamp) + bl;
    m->deadline = m->baseline + (dl > 0 ? dl : INFINITY);
    
    TIMERGET(now);
    if (m->baseline - now > 0) {        // baseline has not yet passed
        enqueueByBaseline(m, &timerQ);
        TIMERSET(timerQ);
    } else {                            // m is immediately schedulable
        enqueueByDeadline(m, &msgQ);
        if (status && threadPool && (msgQ->deadline - activeStack->msg->deadline < 0)) {
            push(pop(&threadPool), &activeStack);
            dispatch(activeStack);
        }
    }
    
    ENABLE(status);
    return m;
}

int sync(Object *to, Method meth, int arg) {
    Thread t;
    int result;
    char status, status_ignore;
    
    DISABLE(status);
    t = to->ownedBy;
    if (t) {                            // to is already locked
        while (t->waitsFor) 
            t = t->waitsFor->ownedBy;
        if (t == current || !status) {  // deadlock!
            ENABLE(status);
            return -1;
        }
        if (to->wantedBy)               // must be a lower priority thread
            to->wantedBy->waitsFor = NULL;
        to->wantedBy = current;
        current->waitsFor = to;
        dispatch(t);
        if (current->msg == NULL) {     // message was aborted (when called from run)
            ENABLE(status);
            return 0;
        }
    }
    to->ownedBy = current;
    ENABLE(status && (to->wantedBy != INSTALLED_TAG));
    result = meth(to, arg);
    DISABLE(status_ignore);
    to->ownedBy = NULL; 
    t = to->wantedBy;
    if (t && (t != INSTALLED_TAG)) {      // we have run on someone's behalf
        to->wantedBy = NULL; 
        t->waitsFor = NULL;
        dispatch(t);
    }
    ENABLE(status);
    return result;
}

void ABORT(Msg m) {
    char status;
    DISABLE(status);
    if (remove(m, &timerQ) || remove(m, &msgQ))
        insert(m, &msgPool);
    else {
        Thread t = activeStack;
        while (t) {
            if ((t != current) && (t->msg == m) && (t->waitsFor == m->to)) {
	            t->msg = NULL;
	            insert(m, &msgPool);
	            break;
            }
            t = t->next;
        }
    }
    ENABLE(status);
}

void T_RESET(Timer *t) {
    t->accum = STATUS() ? current->msg->baseline : timestamp;
}

Time T_SAMPLE(Timer *t) {
    return (STATUS() ? current->msg->baseline : timestamp) - t->accum;
}

Time CURRENT_OFFSET(void) {
    char status;
    Time now;
    DISABLE(status);
    TIMERGET(now);
    ENABLE(status);
    return now - (status ? current->msg->baseline : timestamp);
}

    
/* initialization */
static void initialize(void) {
    int i;

    DUMP_INIT();
    
    for (i=0; i<NMSGS-1; i++)
        messages[i].next = &messages[i+1];
    messages[NMSGS-1].next = NULL;
    
    for (i=0; i<NTHREADS-1; i++)
        threads[i].next = &threads[i+1];
    threads[NTHREADS-1].next = NULL;
    
    for (i=0; i<NTHREADS; i++) {
        setjmp( threads[i].context );
        SETSTACK( &threads[i].context, &stacks[i] );
        SETPC( &threads[i].context, run );
        threads[i].waitsFor = NULL;
    }

    thread0.next = NULL;
    thread0.waitsFor = NULL;
    thread0.msg = NULL;
    
    DUMP("\n\rTinyTimber ");
    DUMP(TINYTIMBER_VERSION);
    DUMP("\n\r");
    TIMER_INIT();
}

void install(Object *obj, Method m, enum Vector i) {
    if (i >= 0 && i < N_VECTORS) {
        char status;
        DISABLE(status);
        otable[i] = obj;
        mtable[i] = m;
        obj->wantedBy = INSTALLED_TAG;  // Mark object as subject to synchronization by interrupt disabling
        ENABLE(status);
    }
}

int tinytimber(Object *obj, Method m, int arg) {
    char status;
    DISABLE(status);
    initialize();
    ENABLE(1);
    if (m != NULL)
        m(obj, arg);
    DISABLE(status);
    idle();
    return 0;
}
