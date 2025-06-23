#!/bin/bash
# Usage: bash sim/run.sh pc_tb
#        bash sim/run.sh instr_mem_tb
#        bash sim/run.sh cpu_full_tb
#        bash sim/run.sh cpu_arith_tb

if [ "$1" == "instr_mem_tb" ]; then
  iverilog -o sim/instr_mem_tb.out src/instr_mem.v testbench/instr_mem_tb.v
  vvp sim/instr_mem_tb.out
  surfer sim/instr_mem.vcd
elif [ "$1" == "pc_tb" ]; then
  iverilog -o sim/pc_tb.out src/pc.v testbench/pc_tb.v
  vvp sim/pc_tb.out
  surfer sim/pc.vcd
elif [ "$1" == "cpu_integration_tb" ]; then
  echo "Compiling CPU integration testbench..."
  iverilog -o sim/cpu_integration_tb.out src/*.v testbench/cpu_integration_tb.v
  echo "Running CPU integration test..."
  vvp sim/cpu_integration_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_integration.vcd
elif [ "$1" == "cpu_arith_tb" ]; then
  echo "Compiling CPU arithmetic testbench..."
  iverilog -o sim/cpu_arith_tb.out src/*.v testbench/cpu_arith_tb.v
  echo "Running CPU arithmetic test..."
  vvp sim/cpu_arith_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_arith_tb.vcd
elif [ "$1" == "cpu_reg_rw_tb" ]; then
  echo "Compiling CPU register read/write testbench..."
  iverilog -o sim/cpu_reg_rw_tb.out src/*.v testbench/cpu_reg_rw_tb.v
  echo "Running CPU register read/write test..."
  vvp sim/cpu_reg_rw_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_reg_rw_tb.vcd
elif [ "$1" == "cpu_imm_bitwise_tb" ]; then
  echo "Compiling CPU immediate & bitwise testbench..."
  iverilog -o sim/cpu_imm_bitwise_tb.out src/*.v testbench/cpu_imm_bitwise_tb.v
  echo "Running CPU immediate & bitwise test..."
  vvp sim/cpu_imm_bitwise_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_imm_bitwise_tb.vcd
elif [ "$1" == "cpu_mem_tb" ]; then
  echo "Compiling CPU memory access testbench..."
  iverilog -o sim/cpu_mem_tb.out src/*.v testbench/cpu_mem_tb.v
  echo "Running CPU memory access test..."
  vvp sim/cpu_mem_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_mem_tb.vcd
elif [ "$1" == "cpu_branch_tb" ]; then
  echo "Compiling CPU branching testbench..."
  iverilog -o sim/cpu_branch_tb.out src/*.v testbench/cpu_branch_tb.v
  echo "Running CPU branching test..."
  vvp sim/cpu_branch_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_branch_tb.vcd
elif [ "$1" == "cpu_jump_tb" ]; then
  echo "Compiling CPU jump testbench..."
  iverilog -o sim/cpu_jump_tb.out src/*.v testbench/cpu_jump_tb.v
  echo "Running CPU jump test..."
  vvp sim/cpu_jump_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_jump_tb.vcd
elif [ "$1" == "cpu_full_tb" ]; then
  echo "Compiling full CPU testbench..."
  iverilog -o sim/cpu_full_tb.out src/*.v testbench/cpu_full_tb.v
  echo "Running full CPU test..."
  vvp sim/cpu_full_tb.out
  echo "Opening waveform in Surfer..."
  surfer sim/cpu_full_tb.vcd
else
  echo "Usage: bash sim/run.sh [pc_tb|instr_mem_tb|cpu_full_tb|cpu_arith_tb|cpu_reg_rw_tb|cpu_imm_bitwise_tb|cpu_mem_tb|cpu_branch_tb|cpu_jump_tb]"
  echo ""
  echo "Available testbenches:"
  echo "  pc_tb              - Test program counter"
  echo "  instr_mem_tb       - Test instruction memory"
  echo "  cpu_full_tb        - Run full CPU test suite"
  echo "  cpu_arith_tb       - Test CPU arithmetic instructions"
  echo "  cpu_reg_rw_tb      - Test register reads and writes"
  echo "  cpu_imm_bitwise_tb - Test immediates and bitwise/shift ops"
  echo "  cpu_mem_tb         - Test memory access"
  echo "  cpu_branch_tb      - Test branching logic"
  echo "  cpu_jump_tb        - Test jump instructions"
  exit 1
fi
