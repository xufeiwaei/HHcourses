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

/* $Id: errno.h,v 1.3 2002/12/12 11:41:01 joerg_wunsch Exp $ */

#ifndef __ERRNO_H_
#define __ERRNO_H_ 1

/** \defgroup avr_errno System Errors (errno)

    \code #include <errno.h>\endcode

    Some functions in the library set the global variable \c errno when an
    error occurs. The file, \c <errno.h>, provides symbolic names for various
    error codes. 

    \warning The \c errno global variable is not safe to use in a threaded or
    multi-task system. A race condition can occur if a task is interrupted
    between the call which sets \c error and when the task examines \c
    errno. If another task changes \c errno during this time, the result will
    be incorrect for the interrupted task. */

#ifdef __cplusplus
extern "C" {
#endif

extern int errno;

#ifdef __cplusplus
}
#endif

/** \ingroup avr_errno
    \def EDOM

    Domain error. */
#define EDOM       33

/** \ingroup avr_errno
    \def ERANGE

    Range error. */
#define ERANGE     34

#endif
