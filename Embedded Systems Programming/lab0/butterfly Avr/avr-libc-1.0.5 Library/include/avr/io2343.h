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

/* $Id: io2343.h,v 1.4 2003/01/08 11:14:10 joerg_wunsch Exp $ */

/* avr/io2343.h - definitions for AT90S2343 */

#ifndef _AVR_IO2343_H_
#define _AVR_IO2343_H_ 1

/* This file should only be included from <avr/io.h>, never directly. */

#ifndef _AVR_IO_H_
#  error "Include <avr/io.h> instead of this file."
#endif

#ifndef _AVR_IOXXX_H_
#  define _AVR_IOXXX_H_ "io2343.h"
#else
#  error "Attempt to include more than one <avr/ioXXX.h> file."
#endif 

/* I/O registers */

/* Input Pins, Port B */
#define PINB	_SFR_IO8(0x16)

/* Data Direction Register, Port B */
#define DDRB	_SFR_IO8(0x17)

/* Data Register, Port B */
#define PORTB	_SFR_IO8(0x18)

/* 0x1C..0x1E EEPROM */

/* Watchdog Timer Control Register */
#define WDTCR	_SFR_IO8(0x21)

/* Timer/Counter 0 */
#define TCNT0	_SFR_IO8(0x32)

/* Timer/Counter 0 Control Register */
#define TCCR0	_SFR_IO8(0x33)

/* MCU Status Register */
#define MCUSR	_SFR_IO8(0x34)

/* MCU general Control Register */
#define MCUCR	_SFR_IO8(0x35)

/* Timer/Counter Interrupt Flag register */
#define TIFR	_SFR_IO8(0x38)

/* Timer/Counter Interrupt MaSK register */
#define TIMSK	_SFR_IO8(0x39)

/* General Interrupt Flag register */
#define GIFR	_SFR_IO8(0x3A)

/* General Interrupt MaSK register */
#define GIMSK	_SFR_IO8(0x3B)

/* 0x3D..0x3E SP */

/* 0x3F SREG */

/* Interrupt vectors */

#define SIG_INTERRUPT0		_VECTOR(1)
#define SIG_OVERFLOW0		_VECTOR(2)

#define _VECTORS_SIZE 6

/*
   The Register Bit names are represented by their bit number (0-7).
 */

/* General Interrupt MaSK register */
#define    INT0    6
#define    INTF0   6

/* General Interrupt Flag Register */
#define    TOIE0   1
#define    TOV0    1

/* MCU general Control Register */
#define    SE      5
#define    SM      4
#define    ISC01   1
#define    ISC00   0

/* Timer/Counter 0 Control Register */
#define    CS02    2
#define    CS01    1
#define    CS00    0

/* Watchdog Timer Control Register */
#define    WDTOE   4
#define    WDE     3
#define    WDP2    2
#define    WDP1    1
#define    WDP0    0

/*
   PB3 = CLOCK
   PB2 = SCK/T0
   PB1 = MISO/INT0
   PB0 = MOSI
 */

/* Data Register, Port B */
#define    PB4     4
#define    PB3     3
#define    PB2     2
#define    PB1     1
#define    PB0     0

/* Data Direction Register, Port B */
#define    DDB4    4
#define    DDB3    3
#define    DDB2    2
#define    DDB1    1
#define    DDB0    0

/* Input Pins, Port B */
#define    PINB4   4
#define    PINB3   3
#define    PINB2   2
#define    PINB1   1
#define    PINB0   0

/* Constants */
#define    RAMEND    0xDF
#define    XRAMEND   0xDF
#define    E2END     0x7F
#define    FLASHEND  0x07FF

#endif /* _AVR_IO2343_H_ */
