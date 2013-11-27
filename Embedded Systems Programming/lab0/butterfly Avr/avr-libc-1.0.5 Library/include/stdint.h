/* Copyright (c) 2002,2004 Marek Michalkiewicz
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

/* $Id: stdint.h,v 1.1.2.2 2004/09/19 19:16:11 troth Exp $ */

/*
   stdint.h

   Contributors:
     Created by Marek Michalkiewicz <marekm@linux.org.pl> (as inttypes.h)
 */

#ifndef __STDINT_H_
#define __STDINT_H_

/** \defgroup avr_stdint Standard Integer Types
    \code #include <stdint.h> \endcode

    Use [u]intN_t if you need exactly N bits.

    Since these typedefs are mandated by the C99 standard, they are preferred
    over rolling your own typedefs.

    \note If avr-gcc's \c -mint8 option is used, no 32-bit types will be
    available for all versions of GCC below 3.5.  */

#if __INT_MAX__ == 127
# define __USING_MINT8 1
#endif

/** \name 8-bit types. */

/*@{*/

/** \ingroup avr_stdint
    8-bit signed type. */

typedef signed char int8_t;

/** \ingroup avr_stdint
    8-bit unsigned type. */

typedef unsigned char uint8_t;

/* When you use the -mint8 gcc option, you get either int32_t or int64_t, but
   not both. */

#define __HAS_INT32_T__ 1
#define __HAS_INT64_T__ 1

#if __USING_MINT8

typedef long int16_t;
typedef unsigned long uint16_t;

#if (__GNUC__ > 3) || (__GNUC__ == 3 && __GNUC_MINOR__ >= 5)
#  undef __HAS_INT64_T__
typedef long long int32_t;
typedef unsigned long long uint32_t;
#else
#  undef __HAS_INT32_T__
typedef long long int64_t;
typedef unsigned long long uint64_t;
#endif

#else /* no -mint8 */

/*@}*/

/** \name 16-bit types. */

/*@{*/

/** \ingroup avr_stdint
    16-bit signed type. */

typedef int int16_t;

/** \ingroup avr_stdint
    16-bit unsigned type. */

typedef unsigned int uint16_t;

/*@}*/

/** \name 32-bit types. */

/*@{*/

/** \ingroup avr_stdint
    32-bit signed type. */

typedef long int32_t;

/** \ingroup avr_stdint
    32-bit unsigned type. */

typedef unsigned long uint32_t;

/*@}*/

/** \name 64-bit types. */

/*@{*/

/** \ingroup avr_stdint
    64-bit signed type. */

typedef long long int64_t;

/** \ingroup avr_stdint
    64-bit unsigned type. */

typedef unsigned long long uint64_t;

#endif

/*@}*/

/** \name Pointer types.
    These allow you to declare variables of the same size as a pointer. */

/*@{*/

/** \ingroup avr_stdint
    Signed pointer compatible type. */

typedef int16_t intptr_t;

/** \ingroup avr_stdint
    Unsigned pointer compatible type. */

typedef uint16_t uintptr_t;

/*@}*/

#endif
