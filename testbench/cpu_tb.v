`timescale 1ns / 1ps

module cpu_tb;
    reg clk, reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("sim/cpu.vcd");
        $dumpvars(0, cpu_tb);
        clk = 0; reset = 1;
        #10 reset = 0;
        #100 $finish;
    end

    always #5 clk = ~clk;
endmodule
