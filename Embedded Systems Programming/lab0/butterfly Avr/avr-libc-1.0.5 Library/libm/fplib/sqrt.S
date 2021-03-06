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
    sqrt.S is part of     FPlib V 0.3.0       ported to avr-as
    for details see readme.fplib

 *----------------------------------------------------------------------------------------
 *
 *	A = sqrt(A)
 */

#include "gasava.inc"
#include "fplib.inc"

          TEXT_SEG(fplib, sqrt)
          FUNCTION(sqrt)

GLOBAL(sqrt)

    SBRC    rA3,7
    RJMP    _U(__fp_nanEDOM)	; sign bit is set -> argument range error

   /* A = sign(=0):(exp+7F):[1].mant = 2^(exp)*1.mant
    *   =          (LSB(exp)+7F) + (exp>>1) + (exp>>1):[1].mant = (2^(exp>>1))^2 * 2^(LSB(exp))*1.mant
    *                                                           = 2^(exp>>1)^2 * A'
    * A' = [2^0*1.0... 2^1*1.1111111] = [1.0...4.0[
    *
    * sqrt(A) = 2^(exp>>1) * sqrt( A' )
    * sqrt(A') = [1.0...2.0[  -> result of srqt(A') has definetely exponent 7F! -> exp(X0) = 7F
    *
    * the matissa of X0 is taken as ( 0.mant >> 1 )     0.0mant
    *  plus if LSB(exp)==1 [LSB(exp-7F)==0]             0.100000
    *  plus the implicit one                            1.000000
    */

    MOV     rB2,rA2		; needed later on
    TST     rA3
    BREQ    _sqrt_ZERO		; sqrt(0) = 0
    RCALL   _U(__fp_split1)	; does not return on NaN
 _sqrt_00:
    MOV     rTI0,rA3
    SUBI    rTI0,0x7F
    ASR     rTI0		; this is dExp!
    SUB     rA3,rTI0
    SUB     rA3,rTI0
    PUSH    rTI0		; exponent offset
    SUBI    rB2,0x80		; == EOR 0x80
    ROR     rB2
    CLR     rB1			; a slightly smaller X(0) than the calculated is better
    CLR     rB0			; and saves 2 right shifts
    ORI     rB2,0x80		; implicit one
    LDI     rB3,0x7F		; load exponent 7F

    CLT				; clears T

    PUSH    rS0
    PUSH    rS1
    PUSH    rS2
    PUSH    rS3			; rS3::rS0 = Abak

    PUSH    rS4
    PUSH    rS5
    PUSH    rS6
    PUSH    rS7			; rS7::rS4 = Bbak

    MOV     rS3,rA3
    MOV     rS2,rA2
    MOV     rS1,rA1
    MOV     rS0,rA0 		; Abak = A
 _sqrt_10:
    MOV     rA0,rS0		;
    MOV     rA1,rS1		;
    MOV     rA2,rS2		;
    MOV     rA3,rS3		; A = Abak

    MOV     rS7,rB3
    MOV     rS6,rB2
    MOV     rS5,rB1
    MOV     rS4,rB0		; Bbak = B

		; divsf3x does not need preset rAE,rBE
    RCALL   _U(__divsf3x)   ; FP1X = arg/xn
		; now rAE = rBE = 0 or 80 or 0xFF ,ok for addsf3x

    MOV     rB3,rS7
    MOV     rB2,rS6
    MOV     rB1,rS5
    MOV     rB0,rS4		; B = Bbak

    CLR     rT1c		; addx uses R1.7 as sign
    RCALL   _U(__addsf3x)	; FP1X = arg/xn + xn
    DEC     rA3			; div by 2 := Xn+1

    MOV     rB3,rA3
    MOV     rB2,rA2
    MOV     rB1,rA1
    MOV     rB0,rA0		;

    CP      rS4,rB0		;
    CPC     rS5,rB1		;
    CPC     rS6,rB2
    CPC     rS7,rB3		; cmp B to Bbak
    BRNE    _sqrt_10

    POP     rS7
    POP     rS6
    POP     rS5
    POP     rS4
    POP     rS3
    POP     rS2
    POP     rS1
    POP     rS0

    POP     rT0
    ADD     rA3,rT0		;
 _sqrt_100:
    CLR     rT0			; no rounding beyond rAE
    RJMP    _U(__fp_merge)
 _sqrt_ZERO:
    RET

          ENDFUNC


