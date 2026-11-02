# rv32-cpu

A RISC-V **RV32I** processor and microcontroller, designed from scratch in Verilog 2001
and simulated with Icarus Verilog. The target board is the Sipeed **Tang Nano 20K** (Gowin GW2AR-18).

The project is built in four stages, each one reusing the modules of the previous:

| Stage | Goal | Status |
|---|---|---|
| P1 | Single-cycle RV32I CPU, passing the official `riscv-tests` | 🚧 in progress |
| P2 | 5-stage pipeline with forwarding, hazard detection and CPI measurements | planned |
| P3 | Bus and memory-mapped peripherals: GPIO, UART, timer; C programs | planned |
| P4 | Microcontroller: CSRs, traps, interrupts, UART bootloader | planned |

## Repository layout

```
rtl/   Verilog modules of the CPU and SoC
tb/    self-checking testbenches (one per module)
sw/    test programs, riscv-tests environment, scripts, C runtime
docs/  diagrams and notes
sim/   simulation outputs (not tracked)
```

## Requirements

- Icarus Verilog and GTKWave: `sudo apt install iverilog gtkwave`
- RISC-V toolchain: `sudo apt install gcc-riscv64-unknown-elf`
- [riscv-tests](https://github.com/riscv-software-src/riscv-tests) checked out locally (default path: `~/rvsim-tools/riscv-tests`, override with `RT=...`)

## Usage

```bash
make run-tb_counter        # build and run any testbench: make run-<testbench>
gtkwave sim/tb_counter.vcd # inspect the waveform

sw/asm.sh sw/first.s       # assemble a program into sim/first.hex
make tests                 # build the rv32ui riscv-tests
make check                 # run all of them on the CPU
```

## Verification

The official `rv32ui` tests run with a minimal custom environment (`sw/env/riscv_test.h`):
each test writes its result to the magic address `0xFFFFFFF0`, which the testbench watches.
`ma_data` and `fence_i` are excluded (misaligned access and self-modifying code are outside the scope of P1).

## References

- Harris & Harris, *Digital Design and Computer Architecture: RISC-V Edition*, ch. 7
- Patterson & Hennessy, *Computer Organization and Design, RISC-V Edition*, ch. 4
- [RISC-V ISA specifications](https://github.com/riscv/riscv-isa-manual/releases)
