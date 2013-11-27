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

/* $Id: timer.h,v 1.4.2.2 2004/02/15 20:28:09 joerg_wunsch Exp $ */

#ifndef _AVR_TIMER_H_
#define _AVR_TIMER_H_

#include <avr/io.h>

#warning "<avr/timer.h> is deprecated, and will be removed in the next major release of avr-libc"

#if defined(__AVR_ATmega128__) || defined(__AVR_ATmega64__)
# warning "This file is known to be incorrect for your MCU type"
#endif

#ifdef __cplusplus
extern "C" {
#endif

enum {
  STOP             = 0,
  CK               = 1,
  CK8              = 2,
  CK64             = 3,
  CK256            = 4,
  CK1024           = 5,
  T0_FALLING_EDGE  = 6,
  T0_RISING_EDGE   = 7
};

static __inline__ void timer0_source (unsigned int src)
{
    TCCR0 = src;
}

/*
 * NB: this is completely bogus.
 */
static __inline__ void timer0_stop (void)
{
    TCNT0 = 0;
}

static __inline__ void timer0_start (void)
{
    TCNT0 = 1;
}

#ifdef __cplusplus
}
#endif

#endif /* _AVR_TIMER_H_ */
