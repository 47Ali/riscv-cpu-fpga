`timescale 1ns / 1ps

module pc_tb;

    reg clk, reset;
    reg [31:0] next_pc;
    wire [31:0] pc_out;

    // Instantiate the Program Counter
    pc uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    initial begin
        $dumpfile("sim/pc.vcd");
        $dumpvars(0, pc_tb);

        clk = 0; reset = 1; next_pc = 32'h00000000;
        #10 reset = 0; next_pc = 32'h00000004;
        #10 next_pc = 32'h00000008;
        #10 next_pc = 32'h0000000C;
        #10 $finish;
    end

    always #5 clk = ~clk;

endmodule
