`timescale 1ns / 1ps

module cpu_jump_tb;
    reg clk = 0;
    reg reset;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/jump.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_jump_tb.vcd");
        $dumpvars(0, cpu_jump_tb);
        $display("=== Jump Instruction Test ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        // jal to label1
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[1] === 32'd4 && uut.pc_out === 32'd8) begin
            $display("PASS: JAL link and PC correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: JAL results wrong (x1=%0d pc=%0d)", uut.exec_unit.rf.regs[1], uut.pc_out);
            fail_count = fail_count + 1;
        end

        // ebreak skipped, execute addi x2,5
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[2] === 32'd5) begin
            $display("PASS: Jumped to function");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Function not executed");
            fail_count = fail_count + 1;
        end

        // jalr back to ebreak
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'd16 && uut.pc_out === 32'd4) begin
            $display("PASS: JALR link and PC correct");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: JALR results wrong (x3=%0d pc=%0d)", uut.exec_unit.rf.regs[3], uut.pc_out);
            fail_count = fail_count + 1;
        end

        $display("\nChecks: %0d  Passed: %0d  Failed: %0d", test_count, pass_count, fail_count);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
