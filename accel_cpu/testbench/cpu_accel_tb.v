`timescale 1ns / 1ps

module cpu_accel_tb;
    reg clk = 0;
    reg reset;
    wire [31:0] cycle_count;

    cpu #(.MEMFILE("program.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_accel_tb.vcd");
        $dumpvars(0, cpu_accel_tb);
        $display("=== Accelerator Instruction Test ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        repeat(50) @(posedge clk); #1;
        $display("ReLU(-1) = %0d", uut.exec_unit.rf.regs[2]);
        $display("ReLU(+5) = %0d", uut.exec_unit.rf.regs[4]);
        $display("Dot product = %0d", uut.exec_unit.rf.regs[7]);
        $display("MatMul results: %0d %0d %0d %0d",
                 uut.exec_unit.rf.regs[12], uut.exec_unit.rf.regs[13],
                 uut.exec_unit.rf.regs[14], uut.exec_unit.rf.regs[15]);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
