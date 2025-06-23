# RISC-V CPU (RV32I) – Master's Dissertation Project

This repository contains my custom 32-bit RISC-V CPU implementation in Verilog as part of my master's dissertation at King's College London. The CPU is built from scratch and verified using simulation tools (Icarus Verilog & Surfer), with eventual deployment to a Basys3 FPGA board.

---

## ✅ Current Progress

* [x] Program Counter (PC)
* [x] Instruction Memory
* [x] Register File
* [x] ALU
* [x] ALU Control Unit
* [x] `add` instruction execution tested via simulation
* [x] `addi` instruction
* [x] Control Unit
* [x] Load/Store (`lw`, `sw`)
* [x] Branch instructions
* [ ] Pipeline (optional)

---

## 🧱 Project Structure

```
riscv_cpu/
├── src/             # All Verilog source modules
├── testbench/       # Testbenches for each module
├── sim/             # Run scripts and VCD waveform dumps
├── program.mem      # Instruction memory (hex)
└── README.md        # This file
```

---

## 🧢 Tools Used

* **VS Code** – Code editor
* **Icarus Verilog** – For simulation
* **Surfer** – For waveform analysis
* **Vivado** – For synthesis to Basys3 (coming later)

---

## 🚀 Running Tests

All module and integration tests are executed using `sim/run.sh`. Ensure
that **Icarus Verilog** and **Surfer** are installed and available in your
`PATH` before running the scripts.

```bash
# Test the program counter
bash sim/run.sh pc_tb

# Test the instruction memory
bash sim/run.sh instr_mem_tb

# Full CPU integration test
bash sim/run.sh cpu_full_tb
```

---

## 📊 Benchmark Metrics

The CPU tracks several performance counters during simulation:

* **`cycle_count`** – total cycles executed
* **`instr_count`** – number of instructions retired
* **`mem_read_count`/`mem_write_count`** – load and store operations
* **`rf_read_count`/`rf_write_count`** – register file reads and writes

These values can be inspected from any testbench (e.g. `uut.instr_count`) to
understand why a given program performs the way it does.

Running `bash sim/run.sh cpu_full_tb` will print these counters when the
program ends.

---

## 🧠 Example Instruction Tested

```
add x5, x1, x2
```

* x1 = 10
* x2 = 15
* x5 (result) = 25 ✅

---

## 💜 Next Steps

* Implement I-type ALU ops (`addi`, `ori`, etc.)
* Add memory and branching
* Integrate control logic
* Synthesize and deploy on FPGA

---

## 📬 Author

**Ali Alsarraf**
[alialsarraf22@gmail.com](mailto:alialsarraf22@gmail.com)
[github.com/47Ali](https://github.com/47Ali)
