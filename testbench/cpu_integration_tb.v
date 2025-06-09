`timescale 1ns / 1ps

module cpu_integration_tb;
    reg clk, reset;
    integer test_count, pass_count, fail_count;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $dumpfile("sim/cpu_integration.vcd");
        $dumpvars(0, cpu_integration_tb);
        
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        
        $display("=== RISC-V CPU Integration Test ===");
        $display("Testing complete CPU with program.mem");
        
        // Reset phase
        reset = 1;
        $display("Phase 1: Reset (PC should be 0x00000000)");
        @(posedge clk);
        @(posedge clk);
        
        // Check initial state
        test_count = test_count + 1;
        if (uut.pc_out == 32'h00000000) begin
            $display("✓ PASS: PC reset to 0x00000000");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x00000000", uut.pc_out);
            fail_count = fail_count + 1;
        end
        
        // Start execution
        reset = 0;
        $display("\nPhase 2: Instruction Execution");
        
        // Wait for first instruction to be fetched
        @(posedge clk);
        $display("Instruction 1: 0x%h (NOP - addi x0, x0, 0)", uut.instr);
        
        // Execute first instruction (NOP)
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.pc_out == 32'h00000004) begin
            $display("✓ PASS: PC incremented to 0x00000004");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x00000004", uut.pc_out);
            fail_count = fail_count + 1;
        end
        
        // Wait for second instruction
        @(posedge clk);
        $display("Instruction 2: 0x%h (addi x1, x0, 1)", uut.instr);
        
        // Execute second instruction (addi x1, x0, 1)
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.pc_out == 32'h00000008) begin
            $display("✓ PASS: PC incremented to 0x00000008");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x00000008", uut.pc_out);
            fail_count = fail_count + 1;
        end
        
        // Check if x1 was written (need to wait for register write)
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[1] == 32'd1) begin
            $display("✓ PASS: x1 = %d (expected 1)", uut.exec_unit.rf.regs[1]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x1 = %d, expected 1", uut.exec_unit.rf.regs[1]);
            fail_count = fail_count + 1;
        end
        
        // Wait for third instruction
        @(posedge clk);
        $display("Instruction 3: 0x%h (addi x2, x1, 2)", uut.instr);
        
        // Execute third instruction (addi x2, x1, 2)
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.pc_out == 32'h0000000c) begin
            $display("✓ PASS: PC incremented to 0x0000000c");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x0000000c", uut.pc_out);
            fail_count = fail_count + 1;
        end
        
        // Check if x2 was written correctly
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[2] == 32'd3) begin
            $display("✓ PASS: x2 = %d (expected 3)", uut.exec_unit.rf.regs[2]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x2 = %d, expected 3", uut.exec_unit.rf.regs[2]);
            fail_count = fail_count + 1;
        end
        
        // Wait for fourth instruction
        @(posedge clk);
        $display("Instruction 4: 0x%h (addi x3, x2, 3)", uut.instr);
        
        // Execute fourth instruction (addi x3, x2, 3)
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.pc_out == 32'h00000010) begin
            $display("✓ PASS: PC incremented to 0x00000010");
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: PC = 0x%h, expected 0x00000010", uut.pc_out);
            fail_count = fail_count + 1;
        end
        
        // Check if x3 was written correctly
        @(posedge clk);
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] == 32'd6) begin
            $display("✓ PASS: x3 = %d (expected 6)", uut.exec_unit.rf.regs[3]);
            pass_count = pass_count + 1;
        end else begin
            $display("✗ FAIL: x3 = %d, expected 6", uut.exec_unit.rf.regs[3]);
            fail_count = fail_count + 1;
        end
        
        // Wait for fifth instruction (JAL)
        @(posedge clk);
        $display("Instruction 5: 0x%h (jal x0, 0 - infinite loop)", uut.instr);
        
        // Execute JAL instruction
        @(posedge clk);
        
        // Display final register state
        $display("\n=== Final Register State ===");
        $display("x0 = %d (should always be 0)", uut.exec_unit.rf.regs[0]);
        $display("x1 = %d (should be 1)", uut.exec_unit.rf.regs[1]);
        $display("x2 = %d (should be 3)", uut.exec_unit.rf.regs[2]);
        $display("x3 = %d (should be 6)", uut.exec_unit.rf.regs[3]);
        
        // Display control signals for last instruction
        $display("\n=== Control Signals (Last Instruction) ===");
        $display("ALUOp = %b", uut.ALUOp);
        $display("RegWrite = %b", uut.RegWrite);
        $display("ALUSrc = %b", uut.ALUSrc);
        $display("Branch = %b", uut.Branch);
        $display("Jump = %b", uut.Jump);
        
        // Display ALU results
        $display("\n=== ALU Results (Last Instruction) ===");
        $display("ALU Result = %d (0x%h)", uut.alu_result, uut.alu_result);
        $display("Zero Flag = %b", uut.zero);
        
        // Test summary
        $display("\n=== Test Summary ===");
        $display("Total Tests: %d", test_count);
        $display("Passed: %d", pass_count);
        $display("Failed: %d", fail_count);
        $display("Success Rate: %.1f%%", (pass_count * 100.0) / test_count);
        
        if (fail_count == 0) begin
            $display("🎉 ALL TESTS PASSED! CPU is working correctly.");
        end else begin
            $display("❌ Some tests failed. Check the implementation.");
        end
        
        $finish;
    end

endmodule 