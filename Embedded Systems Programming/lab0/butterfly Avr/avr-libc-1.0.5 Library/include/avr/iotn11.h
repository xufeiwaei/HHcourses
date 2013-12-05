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

/* $Id: iotn11.h,v 1.4 2003/01/08 11:14:10 joerg_wunsch Exp $ */

/* avr/iotn11.h - definitions for ATtiny10/11 */

#ifndef _AVR_IOTN11_H_
#define _AVR_IOTN11_H_ 1

/* This file should only be included from <avr/io.h>, never directly. */

#ifndef _AVR_IO_H_
#  error "Include <avr/io.h> instead of this file."
#endif

#ifndef _AVR_IOXXX_H_
#  define _AVR_IOXXX_H_ "iotn11.h"
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

/* 0x09..0x15 reserved */

/* Input Pins, Port B */
#define PINB	_SFR_IO8(0x16)

/* Data Direction Register, Port B */
#define DDRB	_SFR_IO8(0x17)

/* Data Register, Port B */
#define PORTB	_SFR_IO8(0x18)

/* 0x19..0x20 reserved */

/* Watchdog Timer Control Register */
#define WDTCR	_SFR_IO8(0x21)

/* 0x22..0x31 reserved */

/* Timer/Counter0 (8-bit) */
#define TCNT0	_SFR_IO8(0x32)

/* Timer/Counter0 Control Register */
#define TCCR0	_SFR_IO8(0x33)

/* MCU general Status Register */
#define MCUSR	_SFR_IO8(0x34)

/* MCU general Control Register */
#define MCUCR	_SFR_IO8(0x35)

/* 0x36..0x37 reserved */

/* Timer/Counter Interrupt Flag Register */
#define TIFR	_SFR_IO8(0x38)

/* Timer/Counter Interrupt MaSK Register */
#define TIMSK	_SFR_IO8(0x39)

/* General Interrupt Flag Register */
#define GIFR	_SFR_IO8(0x3A)

/* General Interrupt MaSK register */
#define GIMSK	_SFR_IO8(0x3B)

/* 0x3C..0x3E reserved */

/* 0x3F SREG */

/* Interrupt vectors */

#define SIG_INTERRUPT0		_VECTOR(1)
#define SIG_PIN			_VECTOR(2)
#define SIG_OVERFLOW0		_VECTOR(3)
#define SIG_COMPARATOR		_VECTOR(4)

#define _VECTORS_SIZE 10

/* Bit numbers */

/* GIMSK */
#define INT0	6
#define PCIE	5

/* GIFR */
#define INTF0	6
#define PCIF	5

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
#define WDTOE	4
#define WDE	3
#define WDP2	2
#define WDP1	1
#define WDP0	0

/*
   PB5 = RESET#
   PB4 = XTAL2
   PB3 = XTAL1
   PB2 = T0
   PB1 = INT0 / AIN1
   PB0 = AIN0
 */

/* PORTB */
#define PB4	4
#define PB3	3
#define PB2	2
#define PB1	1
#define PB0	0

/* DDRB */
#define DDB4	4
#define DDB3	3
#define DDB2	2
#define DDB1	1
#define DDB0	0

/* PINB */
#define PINB5	5
#define PINB4	4
#define PINB3	3
#define PINB2	2
#define PINB1	1
#define PINB0	0

/* ACSR */
#define ACD	7
#define ACO	5
#define ACI	4
#define ACIE	3
#define ACIS1	1
#define ACIS0	0

/* Last memory addresses */
#define RAMEND		0x1F
#define XRAMEND		0x0
#define E2END		0x0
#define FLASHEND	0x3FF

#endif /* _AVR_IOTN11_H_ */