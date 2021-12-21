# Copyright (c) 2019 Mamy André-Ratsimbazafy
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

# A wrapper for linux futex.

type
  FutexOp* = distinct cint

var NR_Futex* {.importc: "__NR_futex", header: "<sys/syscall.h>".}: cint
var FutexWaitPrivate* {.importc:"FUTEX_WAIT_PRIVATE", header: "<linux/futex.h>".}: FutexOp
var FutexWakePrivate* {.importc:"FUTEX_WAKE_PRIVATE", header: "<linux/futex.h>".}: FutexOp

proc syscall*(sysno: clong): cint {.header:"<unistd.h>", varargs.}

proc sysFutex*(
       futex: pointer, op: FutexOp, val1: cint,
       timeout: pointer = nil, val2: pointer = nil, val3: cint = 0): cint {.inline.} =
  syscall(NR_Futex, futex, op, val1, timeout, val2, val3)