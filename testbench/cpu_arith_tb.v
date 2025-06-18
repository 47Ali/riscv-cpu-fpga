`timescale 1ns / 1ps

module cpu_arith_tb;
    // Clock and reset
    reg clk = 0;
    reg reset;

    // Counters for reporting
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // Expose your cycle counter
    wire [31:0] cycle_count;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_arith_tb.vcd");
        $dumpvars(0, cpu_arith_tb);

        $display("\n=== RISC-V CPU Arithmetic Instruction Test ===\n");

        // 1) Hold reset for two cycles
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        // ---- Instruction 1: addi x1, x0, 5 ----
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[1] === 32'd5) begin
            $display("✓ PASS: x1 == 5");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x1 == %0d, expected 5", uut.exec_unit.rf.regs[1]);
            fail_count = fail_count + 1;
        end

        test_count = test_count + 1;
        if (uut.pc_out === 32'd4) begin
            $display("✓ PASS: PC == 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC == 0x%h, expected 0x4", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // ---- Instruction 2: addi x2, x0, 3 ----
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[2] === 32'd3) begin
            $display("✓ PASS: x2 == 3");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x2 == %0d, expected 3", uut.exec_unit.rf.regs[2]);
            fail_count = fail_count + 1;
        end

        test_count = test_count + 1;
        if (uut.pc_out === 32'd8) begin
            $display("✓ PASS: PC == 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC == 0x%h, expected 0x8", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // ---- Instruction 3: add x3, x1, x2 ----
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'd8) begin
            $display("✓ PASS: x3 == 8");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x3 == %0d, expected 8", uut.exec_unit.rf.regs[3]);
            fail_count = fail_count + 1;
        end

        test_count = test_count + 1;
        if (uut.pc_out === 32'd12) begin
            $display("✓ PASS: PC == 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC == 0x%h, expected 0xc", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // ---- Instruction 4: sub x4, x3, x1 ----
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[4] === 32'd3) begin
            $display("✓ PASS: x4 == 3");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x4 == %0d, expected 3", uut.exec_unit.rf.regs[4]);
            fail_count = fail_count + 1;
        end

        test_count = test_count + 1;
        if (uut.pc_out === 32'd16) begin
            $display("✓ PASS: PC == 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC == 0x%h, expected 0x10", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // ---- Instruction 5: slt x5, x1, x2 ----
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[5] === 32'd0) begin
            $display("✓ PASS: x5 == 0");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x5 == %0d, expected 0", uut.exec_unit.rf.regs[5]);
            fail_count = fail_count + 1;
        end

        test_count = test_count + 1;
        if (uut.pc_out === 32'd20) begin
            $display("✓ PASS: PC == 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC == 0x%h, expected 0x14", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // ---- Instruction 6: slt x6, x2, x1 ----
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[6] === 32'd1) begin
            $display("✓ PASS: x6 == 1");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x6 == %0d, expected 1", uut.exec_unit.rf.regs[6]);
            fail_count = fail_count + 1;
        end

        test_count = test_count + 1;
        if (uut.pc_out === 32'd24) begin
            $display("✓ PASS: PC == 0x%h", uut.pc_out);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC == 0x%h, expected 0x18", uut.pc_out);
            fail_count = fail_count + 1;
        end

        // ---- Final instruction: ebreak (halt) ----
        @(posedge clk);
        $display("✅ EBREAK encountered, halting simulation\n");

        // Summary
        $display("=== Test Summary ===");
        $display("Total checks: %0d", test_count);
        $display("Passed      : %0d", pass_count);
        $display("Failed      : %0d", fail_count);
        $display("Success rate: %0.1f%%", (pass_count * 100.0) / test_count);
        $display("Total cycles: %0d\n", cycle_count);

        $finish;
    end
endmodule
