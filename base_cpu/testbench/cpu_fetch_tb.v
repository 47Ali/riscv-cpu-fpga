`timescale 1ns / 1ps

module cpu_fetch_tb;

    reg clk, reset;
    reg jal, jalr, branch, branch_taken;
    reg [31:0] branch_target, jalr_target;
    wire [31:0] instr, pc_out;

    cpu_fetch uut (
        .clk(clk),
        .reset(reset),
        .jal(jal),
        .jalr(jalr),
        .branch(branch),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .jalr_target(jalr_target),
        .instr(instr),
        .pc_out(pc_out)
    );

    initial begin
        $dumpfile("sim/fetch.vcd");
        $dumpvars(0, cpu_fetch_tb);

        clk = 0; reset = 1;
        jal = 0; jalr = 0; branch = 0; branch_taken = 0;
        branch_target = 0; jalr_target = 0;

        #10 reset = 0;
        // Test jal jump at time 20
        #10 branch_target = 32'h00000020; jal = 1;
        #10 jal = 0;

        // Test jalr jump
        #10 jalr_target = 32'h00000040; jalr = 1;
        #10 jalr = 0;

        // Test conditional branch taken
        #10 branch = 1; branch_taken = 1; branch_target = 32'h00000060;
        #10 branch = 0; branch_taken = 0;

        #50 $finish;
    end

    always #5 clk = ~clk;

endmodule
