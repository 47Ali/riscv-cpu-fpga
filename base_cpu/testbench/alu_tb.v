`timescale 1ns / 1ps

module alu_tb;

    reg [31:0] a, b;
    reg [3:0] alu_control;
    wire [31:0] result;
    wire zero;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin
        $dumpfile("sim/alu.vcd");
        $dumpvars(0, alu_tb);

        // Test ADD
        a = 10; b = 5; alu_control = 4'b0010; #10;  // ADD: 15
        // Test SUB
        a = 10; b = 5; alu_control = 4'b0110; #10;  // SUB: 5
        // Test AND
        a = 32'hF0F0_F0F0; b = 32'h0F0F_0F0F; alu_control = 4'b0000; #10;  // AND: 0
        // Test OR
        a = 32'hF0F0_0000; b = 32'h0000_0F0F; alu_control = 4'b0001; #10;  // OR
        // Test XOR
        a = 32'hFF00_FF00; b = 32'h00FF_00FF; alu_control = 4'b0011; #10;  // XOR
        // Test SLL
        a = 32'h0000_0001; b = 5; alu_control = 4'b0100; #10;  // SLL: 0x20
        // Test SRL
        a = 32'h0000_0020; b = 5; alu_control = 4'b0101; #10;  // SRL: 1
        // Test SRA
        a = -32'sd32; b = 5; alu_control = 4'b1101; #10;  // SRA: sign-preserved shift
        // Test SLT (signed)
        a = -1; b = 5; alu_control = 4'b0111; #10;  // SLT: 1
        // Test SLTU (unsigned)
        a = 32'h0000_0001; b = 32'hFFFF_FFFF; alu_control = 4'b1000; #10;  // SLTU: 1
        // Test Zero flag
        a = 5; b = 5; alu_control = 4'b0110; #10;  // SUB: 0, zero=1

        $finish;
    end

endmodule
