# Copyright (c) 2021 Shayan Habibi
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

# A wrapper for linux futex.

type
  FutexOp* = enum
    Wait = 0
    Wake = 1
    Fd = 2
    Requeue = 3
    CmpRequeue = 4
    WakeOp = 5
    LockPi = 6
    UnlockPi = 7
    TryLockPi = 8
    WaitBitset = 9
    WakeBitset = 10
    WaitRequeuePi = 11
    CmpRequeuePi = 12

    WaitPrivate = 0 or 128
    WakePrivate = 1 or 128
    RequeuePrivate = 3 or 128
    CmpRequeuePrivate = 4 or 128
    WakeOpPrivate = 5 or 128
    LockPiPrivate = 6 or 128
    UnlockPiPrivate = 7 or 128
    TryLockPiPrivate = 8 or 128
    WaitBitsetPrivate = 9 or 128
    WakeBitsetPrivate = 10 or 128
    WaitRequeuePiPrivate = 11 or 128
    CmpRequeuePiPrivate = 12 or 128

  FutexCmds* = enum
    Private = 128
    ClockRealTime = 256


var NR_Futex* {.importc: "__NR_futex", header: "<sys/syscall.h>".}: cint

proc `or`*(x, y: FutexOp): FutexOp = cast[FutexOp](cast[int](x) or cast[int](y))

proc syscall*(sysno: clong): cint {.header:"<unistd.h>", varargs.}

proc sysFutex*(
       futex: pointer, op: FutexOp, val1: cint,
       timeout: pointer = nil, val2: pointer = nil, val3: cint = 0): cint {.inline.} =
  syscall(NR_Futex, futex, cast[cint](op), val1, timeout, val2, val3)