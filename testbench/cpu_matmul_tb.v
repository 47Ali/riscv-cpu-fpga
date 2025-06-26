`timescale 1ns / 1ps

module cpu_matmul_tb;
    reg clk = 0;
    reg reset;
    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/matmul.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_matmul_tb.vcd");
        $dumpvars(0, cpu_matmul_tb);
        $display("=== 2x2 Matrix Multiplication Benchmark ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        repeat(30) @(posedge clk); #1;
        $display("C00=%0d C01=%0d C10=%0d C11=%0d",
                 uut.exec_unit.rf.regs[11],
                 uut.exec_unit.rf.regs[12],
                 uut.exec_unit.rf.regs[13],
                 uut.exec_unit.rf.regs[14]);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
