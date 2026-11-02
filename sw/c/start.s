    .section .text.start
    .globl _start
_start:
    la   sp, _stack_top        # στοίβα στο τέλος της RAM
    la   t0, _bss_start        # μηδενισμός .bss (global μεταβλητές = 0)
    la   t1, _bss_end
1:  bgeu t0, t1, 2f
    sw   zero, 0(t0)
    addi t0, t0, 4
    j    1b
2:  call main
3:  j    3b                    # η main δεν πρέπει να επιστρέψει
