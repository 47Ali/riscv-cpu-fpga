module cpu #(
    parameter MEMFILE = "program.mem"
) (
    input wire clk,
    input wire reset,
    output reg [31:0] cycle_count
);
    wire [31:0] instr;
    wire [31:0] pc_out;

    // Signals for fetch stage
    wire jal, jalr;
    wire branch_taken;
    wire [31:0] branch_target, jalr_target;

    cpu_fetch #(.MEMFILE(MEMFILE)) fetch_unit(
        .clk(clk),
        .reset(reset),
        .jal(jal),
        .jalr(jalr),
        .branch(Branch),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .jalr_target(jalr_target),
        .instr(instr),
        .pc_out(pc_out)
    );

    // Decode fields
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    // Halt detection (using the EBREAK instruction)
    wire halt = (instr == 32'h0010_0073);
    wire [4:0] rd  = instr[11:7];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];

    // Immediate generator
    wire [31:0] imm;
    imm_gen imm_unit(
        .instr(instr),
        .imm_out(imm)
    );

    // Control signals
    wire [1:0] ALUOp;
    wire RegWrite, MemRead, MemWrite, Branch, Jump, ALUSrc;

    control_unit cu(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUSrc(ALUSrc)
    );

    // Register and ALU outputs
    wire [31:0] alu_result;
    wire zero;
    wire [31:0] rd1, rd2;
    wire [31:0] write_back_data;

    // Data memory
    wire [31:0] mem_data;
    data_mem dmem(
        .clk(clk),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .addr(alu_result),
        .write_data(rd2),
        .read_data(mem_data)
    );


    execute exec_unit(
        .clk(clk),
        .we(RegWrite),
        .alu_op(ALUOp),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .instr(instr),
        .alu_src(ALUSrc),
        .funct3(funct3),
        .funct7_5(funct7[5]),
        .wb_data(write_back_data),
        .alu_result(alu_result),
        .zero(zero),
        .rd1(rd1),
        .rd2(rd2)
    );

    // PC increment
    wire [31:0] pc_plus4 = pc_out + 4;

    // Branch and jump target calculations
    assign branch_target = pc_out + imm;
    assign jalr_target   = (rd1 + imm) & 32'hffff_fffe;

    // Branch decision (only BEQ implemented)
    assign branch_taken = Branch && zero;

    // Distinguish between JAL and JALR
    assign jal  = Jump && (opcode == 7'b1101111);
    assign jalr = Jump && (opcode == 7'b1100111);

    // Writeback mux: priority Jump -> Load -> ALU
    assign write_back_data = jal | jalr ? pc_plus4 :
                              MemRead    ? mem_data  :
                              alu_result;

    // Cycle counter for benchmarking
    always @(posedge clk) begin
        if (reset)
            cycle_count <= 0;
        else if (!halt)
            cycle_count <= cycle_count + 1;
    end

    // TODO: Additional features could be added here
endmodule
