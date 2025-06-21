`timescale 1ns / 1ps

module cpu_full_tb;
    reg clk = 0;
    reg reset;

    // Symbolic register indices for readability
    localparam X1  = 1;
    localparam X2  = 2;
    localparam X3  = 3;
    localparam X4  = 4;
    localparam X5  = 5;
    localparam X6  = 6;
    localparam X9  = 9;
    localparam X10 = 10;

    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("test_mem/full.mem")) uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    // 10ns clock
    always #5 clk = ~clk;

    task check;
        input condition;
        input [255:0] msg;
        begin
            test_count = test_count + 1;
            if (condition) begin
                $display("PASS: %s", msg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: %s", msg);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sim/cpu_full_tb.vcd");
        $dumpvars(0, cpu_full_tb);
        $display("=== Full CPU Testbench ===");

        // Reset
        reset = 1;
        repeat(2) @(posedge clk);
        reset = 0;

        // ----- Immediate/Bitwise segment -----
        repeat(9) @(posedge clk); #1;
        check(uut.exec_unit.rf.regs[X9] === -32'sd8, "srai result");

        // ----- Memory segment -----
        repeat(10) @(posedge clk); #1;
        check(uut.exec_unit.rf.regs[X3] === 32'd5, "lw x3 == 5");
        check(uut.exec_unit.rf.regs[X4] === 32'd10, "lw x4 == 10");
        check(uut.exec_unit.rf.regs[X5] === 32'd5, "lw x5 == 5");
        check(uut.exec_unit.rf.regs[X6] === 32'd10, "lw x6 == 10");

        // ----- Branch segment -----
        repeat(13) @(posedge clk); #1;
        check(uut.exec_unit.rf.regs[X3] === 32'd5, "branch x3 == 5");
        check(uut.exec_unit.rf.regs[X4] === 32'd6, "branch x4 == 6");
        check(uut.exec_unit.rf.regs[X6] === 32'd9, "branch x6 == 9");

        // ----- Jump segment -----
        repeat(6) @(posedge clk); #1;
        check(uut.exec_unit.rf.regs[X2] === 32'd5, "jal/jalr x2 == 5");
        check(uut.exec_unit.rf.regs[X3] === 32'd6, "jal/jalr x3 == 6");

        // ----- Register RW segment -----
        repeat(6) @(posedge clk); #1;
        check(uut.exec_unit.rf.regs[X2] === 32'd0, "sub result x2 == 0");
        check(uut.exec_unit.rf.regs[X4] === (uut.exec_unit.rf.regs[X1] + uut.exec_unit.rf.regs[X3]), "add x4 correct");

        // Final ebreak
        @(posedge clk);
        $display("\n✅ EBREAK encountered. Tests complete.\n");

        $display("Total checks : %0d", test_count);
        $display("Passed       : %0d", pass_count);
        $display("Failed       : %0d", fail_count);
        $display("Cycles       : %0d", cycle_count);
        $finish;
    end
endmodule
