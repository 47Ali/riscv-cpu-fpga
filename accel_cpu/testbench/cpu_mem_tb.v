`timescale 1ns / 1ps

module cpu_mem_tb;
    reg clk = 0;
    reg reset;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/mem_access.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_mem_tb.vcd");
        $dumpvars(0, cpu_mem_tb);
        $display("=== Memory Access Test ===");

        reset = 1;
        @(posedge clk); @(posedge clk); reset = 0;

        // addi x1, x0, 16
        @(posedge clk);
        // addi x2, x0, 5
        @(posedge clk);
        // sw x2,0(x1)
        @(posedge clk);
        // lw x3,0(x1) -> 5
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[3] === 32'd5) begin
            $display("PASS: lw returned 5");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: lw0 got %0d", uut.exec_unit.rf.regs[3]);
            fail_count = fail_count + 1;
        end

        // addi x2, x0, 10
        @(posedge clk);
        // sw x2,4(x1)
        @(posedge clk);
        // lw x4,4(x1) -> 10
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[4] === 32'd10) begin
            $display("PASS: lw returned 10");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: lw4 got %0d", uut.exec_unit.rf.regs[4]);
            fail_count = fail_count + 1;
        end

        // lw x5,0(x1) -> still 5
        @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[5] === 32'd5) begin
            $display("PASS: lw after second store still 5");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: lw0 after store got %0d", uut.exec_unit.rf.regs[5]);
            fail_count = fail_count + 1;
        end

        // sw x2,8(x1) and lw x6,8(x1)
        @(posedge clk); @(posedge clk); #1;
        test_count = test_count + 1;
        if (uut.exec_unit.rf.regs[6] === 32'd10) begin
            $display("PASS: lw8 returned 10");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: lw8 got %0d", uut.exec_unit.rf.regs[6]);
            fail_count = fail_count + 1;
        end

        $display("\nChecks: %0d  Passed: %0d  Failed: %0d", test_count, pass_count, fail_count);
        $display("Cycles: %0d", cycle_count);
        $finish;
    end
endmodule
