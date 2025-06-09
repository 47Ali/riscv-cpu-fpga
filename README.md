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
* [ ] `addi` instruction
* [ ] Control Unit
* [ ] Load/Store (`lw`, `sw`)
* [ ] Branch instructions
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
