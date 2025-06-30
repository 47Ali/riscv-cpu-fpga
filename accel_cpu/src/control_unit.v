module control_unit(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [1:0] ALUOp,
    output reg  RegWrite,
    output reg  MemRead,
    output reg  MemWrite,
    output reg  Branch,
    output reg  Jump,
    output reg  ALUSrc,
    output wire alu_ctrl_relu,
    output wire alu_ctrl_matmul,
    output wire alu_ctrl_dotprod
);

    // Custom instruction detection
    wire is_custom0 = (opcode == 7'b0001011);
    assign alu_ctrl_relu    = is_custom0 && (funct3 == 3'b000);
    assign alu_ctrl_matmul  = is_custom0 && (funct3 == 3'b001);
    assign alu_ctrl_dotprod = is_custom0 && (funct3 == 3'b010);

    always @(*) begin
        // Default values
        ALUOp    = 2'b00;
        RegWrite = 0;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 0;
        Jump     = 0;
        ALUSrc   = 0;

        case (opcode)
            7'b0110011: begin // R-type
                RegWrite = 1;
                ALUOp    = 2'b10;
                ALUSrc   = 0;
            end
            7'b0010011: begin // I-type ALU
                RegWrite = 1;
                ALUOp    = 2'b11;
                ALUSrc   = 1;
            end
            7'b0000011: begin // Load
                RegWrite = 1;
                MemRead  = 1;
                ALUOp    = 2'b00;
                ALUSrc   = 1;
            end
            7'b0100011: begin // Store
                MemWrite = 1;
                ALUOp    = 2'b00;
                ALUSrc   = 1;
            end
            7'b1100011: begin // Branch
                Branch   = 1;
                ALUOp    = 2'b01;
                ALUSrc   = 0;
            end
            7'b1101111: begin // JAL
                Jump     = 1;
                RegWrite = 1;
            end
            7'b1100111: begin // JALR
                Jump     = 1;
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end
            7'b0001011: begin // custom-0
                RegWrite = 1;
                ALUOp    = 2'b10;
            end
            default: begin
            end
        endcase
    end
endmodule
