`timescale 1ns / 1ps

module cpu_fetch_tb;

    reg clk, reset;
    wire [31:0] instr, pc_out;

    cpu_fetch uut (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .pc_out(pc_out)
    );

    initial begin
        $dumpfile("sim/fetch.vcd");
        $dumpvars(0, cpu_fetch_tb);

        clk = 0; reset = 1;
        #10 reset = 0;
        #100 $finish;
    end

    always #5 clk = ~clk;

endmodule
