# ML-Accelerated RISC-V CPU

This is a fork of my single-cycle RV32I CPU with additional hardware-accelerated ML instructions.

## 🧠 Custom Instructions

| Name    | Opcode  | Funct3 | Description               |
|---------|---------|-------|---------------------------|
| RELU    | 0001011 | 000   | ReLU(x) = max(0, x)       |
| MATMUL  | 0001011 | 001   | 2×2 matrix multiplication |
| DOTPROD | 0001011 | 010   | Dot product (2 elements)  |

## 🏗️ Design Changes

- ALU extended to include custom logic
- Control Unit updated to detect new instructions
- `program.mem` includes ML micro-benchmarks

## 🚀 Benchmarks

| Operation   | Base CPU Cycles | Accelerated Cycles | Speedup |
|-------------|-----------------|-------------------|---------|
| ReLU        | 3–4             | 1                 | 3–4×    |
| Dot Product | ~10             | 1                 | 10×     |
| MatMul 2x2  | ~12             | 1                 | 12×     |

