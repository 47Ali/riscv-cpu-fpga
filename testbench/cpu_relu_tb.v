`timescale 1ns / 1ps

module cpu_relu_tb;
    reg clk = 0;
    reg reset;
    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/relu.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_relu_tb.vcd");
        $dumpvars(0, cpu_relu_tb);
        $display("=== ReLU Benchmark ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        repeat(25) @(posedge clk); #1;
        $display("Result memory: %0d %0d %0d %0d",
                 uut.dmem.mem[0], uut.dmem.mem[1],
                 uut.dmem.mem[2], uut.dmem.mem[3]);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
