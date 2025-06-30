`timescale 1ns / 1ps

module cpu_tb;
    reg clk, reset;
    wire [31:0] cycle_count;

    cpu uut (
        .clk(clk),
        .reset(reset),
        .cycle_count(cycle_count)
    );

    initial begin
        $dumpfile("sim/cpu.vcd");
        $dumpvars(0, cpu_tb);
        clk = 0; reset = 1;
        #10 reset = 0;
        #100 begin
            $display("Cycle count: %d", cycle_count);
            $finish;
        end
    end

    always #5 clk = ~clk;
endmodule
