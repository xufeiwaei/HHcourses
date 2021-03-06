/*  -*- Mode: Asm -*-  */

/* Copyright (c) 2002  Michael Stumpf  <Michael.Stumpf@t-online.de>

   This file is free software; you can redistribute it and/or modify it under
   the terms of the GNU General Public License as published by the Free
   Software Foundation; either version 2, or (at your option) any later
   version.

   In addition to the permissions in the GNU General Public License, the
   author gives you unlimited permission to link the compiled version of this
   file into combinations with other programs, and to distribute those
   combinations without any restriction coming from the use of this file.
   (The General Public License restrictions do apply in other respects; for
   example, they cover modification of the file, and distribution when not
   linked into a combine executable.)

   This file is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
   more details. */

/*
    pow.S is part of     FPlib V 0.3.0       ported to avr-as
    for details see readme.fplib

 *----------------------------------------------------------------------------------------
 *
 *
 *	A = pow(x,y) = exp( log(x)*y )  | x > 0
 */

#include "gasava.inc"
#include "fplib.inc"

          TEXT_SEG(fplib, pow)
          FUNCTION(pow)

GLOBAL(pow)
   TST   rB3
   BREQ  10f		; x ^ 0 = 1.0
   TST   rA3
   BRMI  1f
   BREQ  10f

   PUSH  rB3
   PUSH  rB2
   PUSH  rB1
   PUSH  rB0
   RCALL _U(log)
   POP   rB0
   POP   rB1
   POP   rB2
   POP   rB3
   RCALL _U(__mulsf3)
   RJMP  _U(exp)

1:
	/* x < 0 -> no rational power allowed
	 *          check if B is an integer number
	 * if yes then pow(x,y) =
         */
   PUSH  rA3
   PUSH  rA2
   PUSH  rA1
   PUSH  rA0
   PUSH  rB3
   PUSH  rB2
   PUSH  rB1
   PUSH  rB0
   MOV   rA3,rB3
   MOV   rA2,rB2
   MOV   rA1,rB1
   MOV   rA0,rB0
   RCALL _U(__fixsfsi)

   RCALL _U(__subsf3)
   CP    rA3,rT1c
   CPC   rA2,rT1c
   CPC   rA1,rT1c
   CPC   rA0,rT1c
   POP   rB0
   POP   rB1
   POP   rB2
   POP   rB3
   POP   rA0
   POP   rA1
   POP   rA2
   POP   rA3
   BREQ  2f
   ANDI  rA3,0x7F
   SUBI  rB3,0x80
   RCALL 1b
   SUBI  rB3,0x80

2:
   RJMP  _U(__fp_nanEDOM)

10:
   LDI   rA3,0x3F
   LDI   rA2,0x80
   CLR   rA1
   CLR   rA0
   RET

          ENDFUNC


