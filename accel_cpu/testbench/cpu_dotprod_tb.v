`timescale 1ns / 1ps

module cpu_dotprod_tb;
    reg clk = 0;
    reg reset;
    wire [31:0] cycle_count;
    wire [31:0] instr_count      = uut.instr_count;
    wire [31:0] mem_read_count   = uut.mem_read_count;
    wire [31:0] mem_write_count  = uut.mem_write_count;
    wire [31:0] rf_read_count    = uut.rf_read_count;
    wire [31:0] rf_write_count   = uut.rf_write_count;

    cpu #(.MEMFILE("test_mem/dotprod.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_dotprod_tb.vcd");
        $dumpvars(0, cpu_dotprod_tb);
        $display("=== Dot Product Benchmark ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        repeat(40) @(posedge clk); #1;
        $display("Dot product result: %0d", uut.exec_unit.rf.regs[8]);
        $display("Cycles       : %0d", cycle_count);
        $display("Instructions : %0d", instr_count);
        $display("Mem reads    : %0d", mem_read_count);
        $display("Mem writes   : %0d", mem_write_count);
        $display("RF reads     : %0d", rf_read_count);
        $display("RF writes    : %0d", rf_write_count);
        $finish;
    end
endmodule
