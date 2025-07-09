module execute (
    input wire clk,
    input wire reset,
    input wire we,                     // Write enable for register file
    input wire [1:0] alu_op,          // ALUOp from control unit
    input wire [4:0] rs1, rs2, rd,    // Register addresses
    input wire [31:0] instr,          // Full instruction for immediate generation
    input wire alu_src,               // Select between register or immediate
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    input wire [31:0] wb_data,        // Data to write back to register file
    output wire [31:0] alu_result,
    output wire zero,
    output wire [31:0] rd1, rd2,
    output wire [31:0] reg5
);

    wire [31:0] op2;
    wire [3:0] alu_control;
    wire [31:0] imm;

    // Register file
    regfile rf (
        .clk(clk),
        .reset(reset),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wb_data),
        .rd1(rd1),
        .rd2(rd2),
        .x5(reg5)
    );

    // ALU control
    alu_control alu_ctl (
        .ALUOp(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );

    // Immediate generator
    imm_gen imm_generator (
        .instr(instr),
        .imm_out(imm)
    );

    // ALU second operand selection
    assign op2 = (alu_src) ? imm : rd2;

    // ALU
    alu alu_core (
        .a(rd1),
        .b(op2),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

endmodule
