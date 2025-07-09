# RISC-V CPU (RV32I)

This repository hosts a custom 32‑bit RISC‑V CPU designed in Verilog. The project began as a master’s dissertation and now acts as a playground for exploring new instruction set extensions and benchmarking techniques.

---

## ✨ Features

- Program counter and instruction fetch logic
- Register file with 32 general purpose registers
- ALU and control unit
- Immediate generation and branching
- Data memory with load/store instructions
- Comprehensive testbenches for each module and full CPU integration
- New `mul` instruction using opcode `0x33` with `funct7=0x01`

---

## 📁 Repository Layout

```
riscv-cpu/
├── base_cpu/   # RV32I CPU without ML instructions
├── accel_cpu/  # Extended CPU with ReLU, Dot, and MatMul accelerators
└── README.md
```

## 🔀 Versions
- [`base_cpu/`](./base_cpu): RV32I CPU without ML instructions
- [`accel_cpu/`](./accel_cpu): Extended CPU with ReLU, Dot, and MatMul accelerators


---

## 💻 Usage

All tests are executed via the `sim/run.sh` script inside each CPU folder. Ensure **Icarus Verilog** and **Surfer** are installed and accessible from your `PATH`.

```bash
# Run a simple program counter test
bash sim/run.sh pc_tb

# Execute the full CPU integration test
bash sim/run.sh cpu_integration_tb
```

## 🧪 Testbenches

Use `sim/run.sh` with one of the following targets:

| Testbench           | Description                          |
|---------------------|--------------------------------------|
| `pc_tb`             | Program counter logic                |
| `instr_mem_tb`      | Instruction memory                   |
| `cpu_arith_tb`      | Arithmetic instruction paths         |
| `cpu_reg_rw_tb`     | Register file reads and writes       |
| `cpu_imm_bitwise_tb`| Immediate and bitwise operations     |
| `cpu_mem_tb`        | Memory access instructions           |
| `cpu_branch_tb`     | Branching logic                      |
| `cpu_jump_tb`       | Jump instructions                    |
| `cpu_integration_tb`| Full CPU with all components         |
| `cpu_full_tb`       | Complete test suite                  |
| `cpu_mul_tb`        | Test MUL instruction                 |
| `cpu_relu_tb`       | ReLU benchmark                       |
| `cpu_matmul_tb`     | 2x2 matrix multiplication benchmark  |
| `cpu_dotprod_tb`    | Dot product benchmark                |

Run any of the above using:

```bash
bash sim/run.sh <testbench_name>
```

---

## 🔠 Example

The `program.mem` file contains hex-encoded RISC‑V instructions. Here's a simple example that performs basic arithmetic:

### 🧾 Assembly

```assembly
addi x1, x0, 5     # x1 = 5
addi x2, x0, 3     # x2 = 3
add  x3, x1, x2    # x3 = x1 + x2 = 8
sub  x4, x3, x1    # x4 = x3 - x1 = 3
ebreak             # End of program
```

### 💾 Hex Format (`program.mem`)

```text
00500093  # addi x1, x0, 5
00300113  # addi x2, x0, 3
002081B3  # add  x3, x1, x2
40118233  # sub  x4, x3, x1
00100073  # ebreak
```

### 📤 Output (Simulation Logs)

```text
=== RISC-V CPU Arithmetic Instruction Test ===
✓ PASS: x1 == 5
✓ PASS: x2 == 3
✓ PASS: x3 == 8
✓ PASS: x4 == 3
✓ PASS: ebreak executed, halting simulation
```

This confirms that the CPU correctly executes instructions and updates register values as expected.

## 🏁 ML Benchmarks

The `test_mem` folder contains small programs for benchmarking basic ML operations. Run them with:

```bash
bash sim/run.sh cpu_relu_tb      # ReLU on a 4-element array
bash sim/run.sh cpu_matmul_tb    # 2x2 matrix multiplication
bash sim/run.sh cpu_dotprod_tb   # Dot product
```

## 🔜 Next Steps

1. Extend the core with machine learning focused instructions.
2. Benchmark the CPU using representative workloads.
3. Synthesize and deploy the design to an FPGA board.

## 🎛 Basys3 FPGA Example

The `basys3` folder now includes a Vivado wrapper that slows the CPU clock so the board's LEDs and seven‑segment display update at a visible rate. `program.mem` contains a tiny loop that increments register `x5` from 0–9. The LEDs still show the high bits of the cycle counter, while the 7‑segment display shows the value of `x5`.
=======
The `basys3` folder contains a simple wrapper and constraint file for the Digilent Basys3 board. Add the RTL sources from `base_cpu/src/` together with `basys3/basys3_top.v` and `basys3/program.mem` to a new Vivado project. Apply the pin constraints from `basys3/basys3.xdc`, then synthesize and program the board. The board LEDs will display the lower 16 bits of the CPU's cycle counter.

---

## 💌 Author

Ali Alsarraf – [alialsarraf22@gmail.com](mailto:alialsarraf22@gmail.com)
