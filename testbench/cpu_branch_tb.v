`timescale 1ns / 1ps

module cpu_branch_tb;
    reg clk = 0;
    reg reset;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/branch.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_branch_tb.vcd");
        $dumpvars(0, cpu_branch_tb);
        $display("=== Branching Logic Test ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        // addi x1,1
        @(posedge clk);
        // addi x2,1
        @(posedge clk);
        // beq -> taken to label1
        @(posedge clk);
        // addi x3,0xFF (skipped)
        @(posedge clk);
        // label1: addi x3,5
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'd5) begin
            $display("PASS: BEQ branch taken");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: BEQ not taken");
            fail_count = fail_count + 1;
        end

        // bne -> not taken
        @(posedge clk);
        // addi x4,6
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[4] === 32'd6) begin
            $display("PASS: BNE not taken");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: BNE branch incorrect");
            fail_count = fail_count + 1;
        end

        // addi x2,x2,1
        @(posedge clk);
        // blt -> taken
        @(posedge clk);
        // addi x5,0xFF (skipped)
        @(posedge clk);
        // bge -> taken
        @(posedge clk);
        // addi x6,0xFF (skipped)
        @(posedge clk);
        // addi x6,9
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[6] === 32'd9) begin
            $display("PASS: Branches behaved correctly");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Final branch result wrong");
            fail_count = fail_count + 1;
        end

        $display("\nChecks: %0d  Passed: %0d  Failed: %0d", test_count, pass_count, fail_count);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
