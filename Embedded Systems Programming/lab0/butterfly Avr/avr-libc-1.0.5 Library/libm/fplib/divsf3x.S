 ;----------------------------------------------------------------------------------------------
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
    divsf3x.S is part of     FPlib V 0.3.0       ported to avr-as
    for details see readme.fplib

 *----------------------------------------------------------------------------------------
 *
 *--- division kernel : used by other high level functions (?)
 * divides two extended numbers RX = AX / BX
 * sign not considered, resulting stored in T by ___divsf3
 * AX  rA3 : rA2:rA1:rA0:rAE
 * BX  rB3 : rB2:rB1:rB0:rBE
 * RX  rA3 : rA2:rA1:rA0:rAE
 */

#include "gasava.inc"
#include "fplib.inc"

          TEXT_SEG(fplib, __divsf3x)
          FUNCTION(__divsf3x)

GLOBAL(__divsf3x)
    TST     rB3
    BREQ    ___divsf3x_INF         ; even 0/0
    TST     rA3
    BREQ    ___divsf3x_ZERO        ; 0/x = 0

    ;calculate new exponent & check for overflow underflow
    ; rA3 = rA3-rB3+0x7F

 ___divsf3x_10:
    SUBI    rA3,0x7F          ; both exponents signed char now
    SUBI    rB3,0x7F          ; both exponents signed char now
    SUB     rA3,rB3           ; calcualte new exponent
    BRVC    ___divsf3x_100    ; no signed overflow?
    BRPL    ___divsf3x_ZERO   ; underflow
    CPI     rA3,0x80          ; if exp(A) - exp(B) = exp(R) ==  0x80
    BRNE    ___divsf3x_INF    ; and mant(A) < mant(B) exp(R) will be dec

    SUBI    rA3,0x81          ;
    RJMP    ___divsf3x_110    ;
 ___divsf3x_INF:
    RJMP    _U(__fp_nanx)     ; returns to ___mulsf3 or a high level function : rT1c ok

 ___divsf3x_100:
    SUBI    rA3,0x81          ; add 0x7F
    CPI     rA3,0xFF          ;
    BRNE    ___divsf3x_110    ; underflow?
 ___divsf3x_ZERO:
    RJMP    _U(__fp_zerox)

 ___divsf3x_110:
    CLR     rAE            ; high extention
    CLR     rT1c           ; for comparison
                           ; (some functions call ___divsf3x directely
                           ;  with maybe nonzero rT1c)

    ; now divide mantissa A[rAE:rA2:rA1:rA0] / B[rBE:rB2:rB1:rB0]
    ; result : [push:push:rT0:rBE]

    CP      rA0,rB0
    CPC     rA1,rB1
    CPC     rA2,rB2
    ; CPC     rAE,rBE      ; upper extention, both cleared (?)
    BRCC    ___divsf3x_140
                           ; if A < B the result would be < 1.0 ->
                           ; assure we have 25 bits of precision in the end
    ADD     rA0,rA0
    adc     rA1,rA1
    adc     rA2,rA2
    adc     rAE,rAE
    SUBI    rA3,1
    BRCS    ___divsf3x_ZERO
 ___divsf3x_140:
    ; AM >= BM
    RCALL    ___divsf3x_loop200
    PUSH     rT0
    RCALL    ___divsf3x_loop200
    PUSH     rT0
    RCALL    ___divsf3x_loop200

 ___divsf3x_300:
 ; division done : if AM(rest) >  BM the next digit would be set and more -> round up
 ;                 if AM(rest) == BM exactely the next digit would be set -> round to LSB zero
 ;                 else do not round up
    LDI     rBE,0x80 ; preload : round to to LSB zero (even)
    CP      rB0,rA0
    CPC     rB1,rA1
    CPC     rB2,rA2
    CPC     rT1c,rAE      ;
    BREQ    ___divsf3x_310 ; AM == BM round to LSB zero
    SBCI    rBE,0x80     ; if AM > BM c is set

 ___divsf3x_310:
    MOV     rAE,rBE
    MOV     rA0,rT0
    POP     rA1
    POP     rA2
    CLR     rT0          ;
    RET

  ___divsf3x_loop200:
    LDI     rBE,0x80
    CLR     rT0             ; result holder
 ___divsf3x_loop210:
    CP      rA0,rB0
    CPC     rA1,rB1
    CPC     rA2,rB2
    CPC     rAE,rT1c
    BRCS    ___divsf3x_loop211
    SUB     rA0,rB0
    SBC     rA1,rB1
    SBC     rA2,rB2
    SBC     rAE,rT1c
    OR      rT0,rBE
 ___divsf3x_loop211:
    ADD     rA0,rA0   ;
    adc     rA1,rA1   ;
    adc     rA2,rA2   ;
    adc     rAE,rAE   ;
    LSR     rBE
    BRNE    ___divsf3x_loop210
    RET

          ENDFUNC


