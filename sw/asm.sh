#!/bin/bash
# sw/asm.sh sw/first.s  ->  sim/first.elf, sim/first.hex και disassembly
set -e
src=$1; n=$(basename "$src" .s); mkdir -p sim
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Ttext=0 "$src" -o sim/$n.elf
riscv64-unknown-elf-objcopy -O binary sim/$n.elf sim/$n.bin
python3 sw/bin2hex.py sim/$n.bin > sim/$n.hex
riscv64-unknown-elf-objdump -d sim/$n.elf
