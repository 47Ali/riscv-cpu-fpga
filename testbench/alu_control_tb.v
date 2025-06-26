`timescale 1ns / 1ps

module alu_control_tb;

    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [3:0] alu_control;

    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );

    initial begin
        $dumpfile("sim/alu_control.vcd");
        $dumpvars(0, alu_control_tb);

        // R-type: ADD (funct3 = 000, funct7 = 0000000)
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // R-type: SUB (funct3 = 000, funct7 = 0100000)
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000; #10;
        // R-type: AND (funct3 = 111)
        ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000; #10;
        // R-type: SRL (funct3 = 101, funct7 = 0000000)
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        // R-type: SRA (funct3 = 101, funct7 = 0100000)
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0100000; #10;
        // R-type: MUL (funct3 = 000, funct7 = 0000001)
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000001; #10;

        // I-type: ADDI
        ALUOp = 2'b11; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // I-type: SLTIU
        ALUOp = 2'b11; funct3 = 3'b011; funct7 = 7'b0000000; #10;
        // I-type: SRLI
        ALUOp = 2'b11; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        // I-type: SRAI
        ALUOp = 2'b11; funct3 = 3'b101; funct7 = 7'b0100000; #10;

        // Load/Store: ADD (ALUOp = 00)
        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // Branch: SUB (ALUOp = 01)
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        $finish;
    end

endmodule
