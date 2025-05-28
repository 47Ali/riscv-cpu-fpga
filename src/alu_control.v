module alu_control (
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire funct7_5, // bit 30 from funct7
    output reg [3:0] alu_control
);
    always @(*) begin
        case (ALUOp)
            2'b00: alu_control = 4'b0010;  // lw, sw → ADD
            2'b01: alu_control = 4'b0110;  // branch → SUB
            2'b10: begin  // R-type
                case ({funct7_5, funct3})
                    4'b0000: alu_control = 4'b0010; // ADD
                    4'b1000: alu_control = 4'b0110; // SUB
                    4'b0001: alu_control = 4'b0100; // SLL
                    4'b0010: alu_control = 4'b0111; // SLT
                    4'b0011: alu_control = 4'b1000; // SLTU
                    4'b0100: alu_control = 4'b0011; // XOR
                    4'b0101: alu_control = 4'b0101; // SRL
                    4'b1101: alu_control = 4'b1101; // SRA
                    4'b0110: alu_control = 4'b0001; // OR
                    4'b0111: alu_control = 4'b0000; // AND
                    default: alu_control = 4'b1111; // INVALID
                endcase
            end
            2'b11: begin  // I-type ALU ops
                case (funct3)
                    3'b000: alu_control = 4'b0010; // ADDI
                    3'b010: alu_control = 4'b0111; // SLTI
                    3'b011: alu_control = 4'b1000; // SLTIU
                    3'b100: alu_control = 4'b0011; // XORI
                    3'b110: alu_control = 4'b0001; // ORI
                    3'b111: alu_control = 4'b0000; // ANDI
                    3'b001: alu_control = 4'b0100; // SLLI
                    3'b101: alu_control = (funct7_5) ? 4'b1101 : 4'b0101; // SRAI / SRLI
                    default: alu_control = 4'b1111;
                endcase
            end
            default: alu_control = 4'b1111;
        endcase
    end
endmodule
