    .globl _start
_start:
    addi x1, x0, 5
    addi x2, x0, 12
    add  x3, x1, x2
    sub  x4, x2, x1
    and  x5, x1, x2
    or   x6, x1, x2
    slt  x7, x1, x2
    sw   x3, 0x100(x0)
    lw   x8, 0x100(x0)
    beq  x8, x3, skip
    addi x9, x0, 99
skip:
    jal  x10, done
    addi x11, x0, 99
done:
    addi x11, x0, 42
end:
    beq  x0, x0, end
