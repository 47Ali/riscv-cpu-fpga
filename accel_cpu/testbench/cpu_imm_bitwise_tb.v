`timescale 1ns / 1ps

module cpu_imm_bitwise_tb;
    reg clk = 0;
    reg reset;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/imm_bitwise.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_imm_bitwise_tb.vcd");
        $dumpvars(0, cpu_imm_bitwise_tb);
        $display("=== Immediate & Bitwise Ops Test ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        // addi x1, x0, -1
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[1] === 32'hFFFF_FFFF) begin
            $display("PASS: x1 == -1");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: x1 = 0x%h", uut.exec_unit.rf.regs[1]);
            fail_count = fail_count + 1;
        end

        // andi x2, x1, -16 -> 0xFFFF_FFF0
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[2] === 32'hFFFF_FFF0) begin
            $display("PASS: andi result correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: andi got 0x%h", uut.exec_unit.rf.regs[2]);
            fail_count = fail_count + 1;
        end

        // ori x3, x0, 0x123 -> 0x123
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'h0000_0123) begin
            $display("PASS: ori result correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: ori got 0x%h", uut.exec_unit.rf.regs[3]);
            fail_count = fail_count + 1;
        end

        // xori x4, x3, -1 -> ~0x123
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[4] === ~32'h0000_0123) begin
            $display("PASS: xori result correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: xori got 0x%h", uut.exec_unit.rf.regs[4]);
            fail_count = fail_count + 1;
        end

        // addi x5, x0, 1
        @(posedge clk); #1;

        // slli x6, x5, 4 -> 16
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[6] === 32'd16) begin
            $display("PASS: slli result correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: slli got %0d", uut.exec_unit.rf.regs[6]);
            fail_count = fail_count + 1;
        end

        // srli x7, x6, 2 -> 4
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[7] === 32'd4) begin
            $display("PASS: srli result correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: srli got %0d", uut.exec_unit.rf.regs[7]);
            fail_count = fail_count + 1;
        end

        // addi x8, x0, -32
        @(posedge clk); #1;

        // srai x9, x8, 2 -> -8
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[9] === -32'sd8) begin
            $display("PASS: srai result correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: srai got %0d", uut.exec_unit.rf.regs[9]);
            fail_count = fail_count + 1;
        end

        $display("\nChecks: %0d  Passed: %0d  Failed: %0d", test_count, pass_count, fail_count);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
