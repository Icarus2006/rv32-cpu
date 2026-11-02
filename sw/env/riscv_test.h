#ifndef _ENV_HW_H
#define _ENV_HW_H
// Απλό env για τον δικό σου CPU: χωρίς CSR, χωρίς traps.
// PASS/FAIL = εγγραφή στη "μαγική" διεύθυνση 0xFFFFFFF0.
#define RVTEST_RV32U
#define RVTEST_RV64U
#define TESTNUM gp

#define RVTEST_CODE_BEGIN      \
        .section .text.init;   \
        .align 2;              \
        .globl _start;         \
_start:                        \
        li TESTNUM, 0;

#define RVTEST_CODE_END        \
1:      j 1b;

#define RVTEST_PASS            \
        li  t0, 0xFFFFFFF0;    \
        li  t1, 1;             \
        sw  t1, 0(t0);         \
1:      j 1b;

#define RVTEST_FAIL            \
        li  t0, 0xFFFFFFF0;    \
        slli TESTNUM, TESTNUM, 1; \
        ori TESTNUM, TESTNUM, 1;  \
        sw  TESTNUM, 0(t0);    \
1:      j 1b;

#define EXTRA_DATA
#define RVTEST_DATA_BEGIN EXTRA_DATA .align 4;
#define RVTEST_DATA_END
#endif
