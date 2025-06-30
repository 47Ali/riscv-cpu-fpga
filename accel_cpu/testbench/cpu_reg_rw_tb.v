`timescale 1ns / 1ps

module cpu_reg_rw_tb;
    reg clk = 0;
    reg reset;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/reg_rw.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_reg_rw_tb.vcd");
        $dumpvars(0, cpu_reg_rw_tb);
        $display("=== Register Read/Write Test ===");

        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        // addi x1, x0, 10
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[1] === 32'd10) begin
            $display("PASS: x1 == 10");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x1 = %0d, expected 10", uut.exec_unit.rf.regs[1]);
            fail_count = fail_count + 1;
        end

        // add x0, x1, x1 (attempt overwrite x0)
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[0] === 32'd0) begin
            $display("PASS: x0 remains 0");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x0 changed to %0d", uut.exec_unit.rf.regs[0]);
            fail_count = fail_count + 1;
        end

        // sub x2, x1, x1 -> 0
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[2] === 32'd0) begin
            $display("PASS: x2 == 0");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x2 = %0d, expected 0", uut.exec_unit.rf.regs[2]);
            fail_count = fail_count + 1;
        end

        // add x3, x1, x2 -> 10
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'd10) begin
            $display("PASS: x3 == 10");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x3 = %0d, expected 10", uut.exec_unit.rf.regs[3]);
            fail_count = fail_count + 1;
        end

        // addi x1, x1, 5 -> 15
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[1] === 32'd15) begin
            $display("PASS: x1 updated to 15");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x1 = %0d, expected 15", uut.exec_unit.rf.regs[1]);
            fail_count = fail_count + 1;
        end

        // add x4, x1, x3 -> 25
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[4] === 32'd25) begin
            $display("PASS: x4 == 25");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x4 = %0d, expected 25", uut.exec_unit.rf.regs[4]);
            fail_count = fail_count + 1;
        end

        $display("\nChecks: %0d  Passed: %0d  Failed: %0d", test_count, pass_count, fail_count);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
