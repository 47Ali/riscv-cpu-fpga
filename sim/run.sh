#!/bin/bash
# Usage: bash sim/run.sh pc_tb
#        bash sim/run.sh instr_mem_tb
#        bash sim/run.sh cpu_integration_tb

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
else
  echo "Usage: bash sim/run.sh [pc_tb|instr_mem_tb|cpu_integration_tb]"
  echo ""
  echo "Available testbenches:"
  echo "  pc_tb              - Test program counter"
  echo "  instr_mem_tb       - Test instruction memory"
  echo "  cpu_integration_tb - Test complete CPU with all components"
  exit 1
fi
