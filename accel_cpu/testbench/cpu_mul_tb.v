`timescale 1ns / 1ps

module cpu_mul_tb;
    reg clk = 0;
    reg reset;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/mul.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_mul_tb.vcd");
        $dumpvars(0, cpu_mul_tb);
        $display("=== MUL Instruction Test ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        // addi x1, x0, 5
        @(posedge clk);
        // addi x2, x0, 3
        @(posedge clk);
        // mul x3, x1, x2 -> 15
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'd15) begin
            $display("PASS: x3 == 15");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x3 = %0d, expected 15", uut.exec_unit.rf.regs[3]);
            fail_count = fail_count + 1;
        end

        $display("\nChecks: %0d  Passed: %0d  Failed: %0d", test_count, pass_count, fail_count);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
