`timescale 1ns / 1ps

module cpu_dotprod_tb;
    reg clk = 0;
    reg reset;
    wire [31:0] cycle_count;

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
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
