#!/bin/bash
# Μεταγλωττίζει τα rv32ui riscv-tests με το απλό env (Μέρος Ι, κεφ. 1.9).
set -e
RT=${RT:-$HOME/rvsim-tools/riscv-tests}
OUT=sim/tests
mkdir -p $OUT
for f in $RT/isa/rv32ui/*.S; do
    n=$(basename "$f" .S)
    case $n in ma_data|fence_i) continue ;; esac
    riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -static -nostdlib -nostartfiles \
        -I sw/env -I $RT/isa/macros/scalar -T sw/link.ld "$f" -o $OUT/$n.elf
    riscv64-unknown-elf-objcopy -O binary $OUT/$n.elf $OUT/$n.bin
    python3 sw/bin2hex.py $OUT/$n.bin > $OUT/$n.hex
    riscv64-unknown-elf-objdump -d $OUT/$n.elf > $OUT/$n.dump
done
echo "Built $(ls $OUT/*.hex | wc -l) tests"
