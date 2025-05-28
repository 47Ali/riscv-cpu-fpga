`timescale 1ns / 1ps

module alu_control_tb;

    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg funct7_5;
    wire [3:0] alu_control;

    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .alu_control(alu_control)
    );

    initial begin
        $dumpfile("sim/alu_control.vcd");
        $dumpvars(0, alu_control_tb);

        // R-type: ADD (funct3 = 000, funct7[5] = 0)
        ALUOp = 2'b10; funct3 = 3'b000; funct7_5 = 0; #10;
        // R-type: SUB (funct3 = 000, funct7[5] = 1)
        ALUOp = 2'b10; funct3 = 3'b000; funct7_5 = 1; #10;
        // R-type: AND (funct3 = 111)
        ALUOp = 2'b10; funct3 = 3'b111; funct7_5 = 0; #10;
        // R-type: SRL (funct3 = 101, funct7[5] = 0)
        ALUOp = 2'b10; funct3 = 3'b101; funct7_5 = 0; #10;
        // R-type: SRA (funct3 = 101, funct7[5] = 1)
        ALUOp = 2'b10; funct3 = 3'b101; funct7_5 = 1; #10;

        // I-type: ADDI
        ALUOp = 2'b11; funct3 = 3'b000; funct7_5 = 0; #10;
        // I-type: SLTIU
        ALUOp = 2'b11; funct3 = 3'b011; funct7_5 = 0; #10;
        // I-type: SRLI
        ALUOp = 2'b11; funct3 = 3'b101; funct7_5 = 0; #10;
        // I-type: SRAI
        ALUOp = 2'b11; funct3 = 3'b101; funct7_5 = 1; #10;

        // Load/Store: ADD (ALUOp = 00)
        ALUOp = 2'b00; funct3 = 3'b000; funct7_5 = 0; #10;
        // Branch: SUB (ALUOp = 01)
        ALUOp = 2'b01; funct3 = 3'b000; funct7_5 = 0; #10;

        $finish;
    end

endmodule
