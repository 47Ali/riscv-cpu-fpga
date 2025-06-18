`timescale 1ns / 1ps

module cpu_arith_tb;
    // Clock, reset
    reg clk = 0;
    reg reset;

    // Counters for test reporting
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // Wire out the cycle counter from your CPU
    wire [31:0] cycle_count;

    // Instantiate your CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    // Generate a 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        // VCD dump for waveform viewing
        $dumpfile("sim/cpu_arith_tb.vcd");
        $dumpvars(0, cpu_arith_tb);

        $display("=== RISC-V CPU Arithmetic Instruction Test ===");

        // 1) Apply reset for two clock edges
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        // 2) First instruction: addi x1, x0, 5
        @(posedge clk);
        $display("Instruction 1 fetched: 0x%h (addi x1, x0, 5)", uut.instr);
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[1] === 32'd5) begin
            $display("✓ PASS: x1 = %0d", uut.exec_unit.rf.regs[1]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x1 = %0d, expected 5", uut.exec_unit.rf.regs[1]);
            fail_count = fail_count + 1;
        end
        test_count = test_count + 1;
        if (uut.pc_out === 32'd4) begin
            $display("✓ PASS: PC = 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x4", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // 3) Second instruction: addi x2, x0, 3
        @(posedge clk);
        $display("Instruction 2 fetched: 0x%h (addi x2, x0, 3)", uut.instr);
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[2] === 32'd3) begin
            $display("✓ PASS: x2 = %0d", uut.exec_unit.rf.regs[2]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x2 = %0d, expected 3", uut.exec_unit.rf.regs[2]);
            fail_count = fail_count + 1;
        end
        test_count = test_count + 1;
        if (uut.pc_out === 32'd8) begin
            $display("✓ PASS: PC = 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x8", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // 4) Third instruction: add x3, x1, x2  (5 + 3 = 8)
        @(posedge clk);
        $display("Instruction 3 fetched: 0x%h (add x3, x1, x2)", uut.instr);
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'd8) begin
            $display("✓ PASS: x3 = %0d", uut.exec_unit.rf.regs[3]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x3 = %0d, expected 8", uut.exec_unit.rf.regs[3]);
            fail_count = fail_count + 1;
        end
        test_count = test_count + 1;
        if (uut.pc_out === 32'd12) begin
            $display("✓ PASS: PC = 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0xc", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // 5) Fourth instruction: sub x4, x3, x1  (8 - 5 = 3)
        @(posedge clk);
        $display("Instruction 4 fetched: 0x%h (sub x4, x3, x1)", uut.instr);
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[4] === 32'd3) begin
            $display("✓ PASS: x4 = %0d", uut.exec_unit.rf.regs[4]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x4 = %0d, expected 3", uut.exec_unit.rf.regs[4]);
            fail_count = fail_count + 1;
        end
        test_count = test_count + 1;
        if (uut.pc_out === 32'd16) begin
            $display("✓ PASS: PC = 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x10", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // 6) Fifth instruction: slt x5, x1, x2  (5<3?=0)
        @(posedge clk);
        $display("Instruction 5 fetched: 0x%h (slt x5, x1, x2)", uut.instr);
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[5] === 32'd0) begin
            $display("✓ PASS: x5 = %0d", uut.exec_unit.rf.regs[5]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x5 = %0d, expected 0", uut.exec_unit.rf.regs[5]);
            fail_count = fail_count + 1;
        end
        test_count = test_count + 1;
        if (uut.pc_out === 32'd20) begin
            $display("✓ PASS: PC = 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x14", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // 7) Sixth instruction: slt x6, x2, x1  (3<5?=1)
        @(posedge clk);
        $display("Instruction 6 fetched: 0x%h (slt x6, x2, x1)", uut.instr);
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[6] === 32'd1) begin
            $display("✓ PASS: x6 = %0d", uut.exec_unit.rf.regs[6]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x6 = %0d, expected 1", uut.exec_unit.rf.regs[6]);
            fail_count = fail_count + 1;
        end
        test_count = test_count + 1;
        if (uut.pc_out === 32'd24) begin
            $display("✓ PASS: PC = 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x18", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // 8) Seventh instruction: ebreak → halt
        @(posedge clk);
        $display("Instruction 7 fetched: 0x%h (ebreak)", uut.instr);
        $display("✅ EBREAK: halting simulation");

        // Final report
        $display("\n=== Test Summary ===");
        $display("Total Checks : %0d", test_count);
        $display("Passed       : %0d", pass_count);
        $display("Failed       : %0d", fail_count);
        $display("Success Rate : %0.1f%%", (pass_count * 100.0) / test_count);
        $display("Total Cycles : %0d", cycle_count);

        $finish;
    end
endmodule
