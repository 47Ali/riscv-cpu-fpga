`timescale 1ns / 1ps

module regfile_tb;

    reg clk, we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    regfile uut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    initial begin
        $dumpfile("sim/regfile.vcd");
        $dumpvars(0, regfile_tb);

        clk = 0; we = 0;
        rs1 = 0; rs2 = 0; rd = 0; wd = 0;

        #5  rd = 5; wd = 32'hAAAA_BBBB; we = 1;
        #5  clk = 1; #5 clk = 0; we = 0;

        #5  rs1 = 5; rs2 = 0;
        #5  clk = 1; #5 clk = 0;

        #5  rd = 0; wd = 32'hFFFF_FFFF; we = 1; // Should not write to x0
        #5  clk = 1; #5 clk = 0; we = 0;

        #5  rs1 = 0; rs2 = 0;
        #5  clk = 1; #5 clk = 0;

        #10 $finish;
    end

endmodule
