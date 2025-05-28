#!/bin/bash
# Usage: bash sim/run.sh pc_tb   # for pc_tb
#        bash sim/run.sh instr_mem_tb   # for instr_mem_tb

if [ "$1" == "instr_mem_tb" ]; then
  iverilog -o sim/instr_mem_tb.out src/instr_mem.v testbench/instr_mem_tb.v
  vvp sim/instr_mem_tb.out
  gtkwave sim/instr_mem.vcd
else
  iverilog -o sim/pc_tb.out src/pc.v testbench/pc_tb.v
  vvp sim/pc_tb.out
  gtkwave sim/pc.vcd
fi
