/* Copyright (c) 2002, Marek Michalkiewicz
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE. */

/* $Id: io1200.h,v 1.4 2003/01/08 11:14:10 joerg_wunsch Exp $ */

/* avr/io1200.h - definitions for AT90S1200 */

#ifndef _AVR_IO1200_H_
#define _AVR_IO1200_H_ 1

/* This file should only be included from <avr/io.h>, never directly. */

#ifndef _AVR_IO_H_
#  error "Include <avr/io.h> instead of this file."
#endif

#ifndef _AVR_IOXXX_H_
#  define _AVR_IOXXX_H_ "io1200.h"
#else
#  error "Attempt to include more than one <avr/ioXXX.h> file."
#endif 

#ifndef __ASSEMBLER__
#  warning "MCU not supported by the C compiler"
#endif

/* I/O registers */

/* 0x00..0x07 reserved */

/* Analog Comparator Control and Status Register */
#define ACSR	_SFR_IO8(0x08)

/* 0x09..0x0F reserved */

#define PIND	_SFR_IO8(0x10)
#define DDRD	_SFR_IO8(0x11)
#define PORTD	_SFR_IO8(0x12)

/* 0x13..0x15 reserved */

#define PINB	_SFR_IO8(0x16)
#define DDRB	_SFR_IO8(0x17)
#define PORTB	_SFR_IO8(0x18)

/* 0x19..0x1B reserved */

/* 0x1C..0x1E EEPROM */

/* 0x1F..0x20 reserved */

/* Watchdog Timer Control Register */
#define WDTCR	_SFR_IO8(0x21)

/* 0x22..0x31 reserved */

#define TCNT0	_SFR_IO8(0x32)
#define TCCR0	_SFR_IO8(0x33)

/* 0x34 reserved */

#define MCUCR	_SFR_IO8(0x35)

/* 0x36..0x37 reserved */

/* Timer/Counter Interrupt Flag Register */
#define TIFR	_SFR_IO8(0x38)

/* Timer/Counter Interrupt MaSK Register */
#define TIMSK	_SFR_IO8(0x39)

/* 0x3A reserved */

#define GIMSK	_SFR_IO8(0x3B)

/* 0x3C..0x3E reserved */

/* 0x3F SREG */

/* Interrupt vectors */

#define SIG_INTERRUPT0		_VECTOR(1)
#define SIG_OVERFLOW0		_VECTOR(2)
#define SIG_COMPARATOR		_VECTOR(3)

#define _VECTORS_SIZE 8

/* Bit numbers */

/* GIMSK */
#define INT0	6

/* TIMSK */
#define TOIE0	1

/* TIFR */
#define TOV0	1

/* MCUCR */
#define SE	5
#define SM	4
#define ISC01	1
#define ISC00	0

/* TCCR0 */
#define CS02	2
#define CS01	1
#define CS00	0

/* WDTCR */
#define WDE	3
#define WDP2	2
#define WDP1	1
#define WDP0	0

/* EECR */
#undef EEMWE

/*
   PB7 = SCK
   PB6 = MISO
   PB5 = MOSI
   PB1 = AIN1
   PB0 = AIN0
 */

/* PORTB */
#define PB7	7
#define PB6	6
#define PB5	5
#define PB4	4
#define PB3	3
#define PB2	2
#define PB1	1
#define PB0	0

/* DDRB */
#define DDB7	7
#define DDB6	6
#define DDB5	5
#define DDB4	4
#define DDB3	3
#define DDB2	2
#define DDB1	1
#define DDB0	0

/* PINB */
#define PINB7	7
#define PINB6	6
#define PINB5	5
#define PINB4	4
#define PINB3	3
#define PINB2	2
#define PINB1	1
#define PINB0	0

/* PORTD */
#define PD6	6
#define PD5	5
#define PD4	4
#define PD3	3
#define PD2	2
#define PD1	1
#define PD0	0

/* DDRD */
#define DDD6	6
#define DDD5	5
#define DDD4	4
#define DDD3	3
#define DDD2	2
#define DDD1	1
#define DDD0	0

/* PIND */
#define PIND6	6
#define PIND5	5
#define PIND4	4
#define PIND3	3
#define PIND2	2
#define PIND1	1
#define PIND0	0

/* ACSR */
#define ACD	7
#define ACO	5
#define ACI	4
#define ACIE	3
#define ACIS1	1
#define ACIS0	0

#undef ZH

/* Last memory addresses */
#define RAMEND		0x1F
#define XRAMEND		0x0
#define E2END		0x3F
#define FLASHEND	0x3FF

#endif  /* _AVR_IO1200_H_ */
