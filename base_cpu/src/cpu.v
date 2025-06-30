module cpu #(
    parameter MEMFILE = "program.mem"
) (
    input wire clk,
    input wire reset,
    output reg [31:0] cycle_count
);
    wire [31:0] instr;
    wire [31:0] pc_out;

    // Performance counters
    reg [31:0] instr_count;
    reg [31:0] mem_read_count;
    reg [31:0] mem_write_count;
    reg [31:0] rf_read_count;
    reg [31:0] rf_write_count;

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
        .reset(reset),
        .we(RegWrite),
        .alu_op(ALUOp),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .instr(instr),
        .alu_src(ALUSrc),
        .funct3(funct3),
        .funct7(funct7),
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

    // Branch comparison helpers
    wire eq      = (rd1 == rd2);
    wire slt     = ($signed(rd1) < $signed(rd2));
    wire sltu    = (rd1 < rd2);

    // Branch decision based on funct3
    reg branch_cond;
    always @(*) begin
        case (funct3)
            3'b000: branch_cond = eq;          // BEQ
            3'b001: branch_cond = !eq;         // BNE
            3'b100: branch_cond = slt;         // BLT
            3'b101: branch_cond = !slt;        // BGE
            3'b110: branch_cond = sltu;        // BLTU
            3'b111: branch_cond = !sltu;       // BGEU
            default: branch_cond = 1'b0;
        endcase
    end

    assign branch_taken = Branch && branch_cond;

    // Distinguish between JAL and JALR
    assign jal  = Jump && (opcode == 7'b1101111);
    assign jalr = Jump && (opcode == 7'b1100111);

    // Writeback mux: priority Jump -> Load -> ALU
    assign write_back_data = jal | jalr ? pc_plus4 :
                              MemRead    ? mem_data  :
                              alu_result;

    // Cycle counter and other performance metrics
    always @(posedge clk) begin
        if (reset) begin
            cycle_count     <= 0;
            instr_count     <= 0;
            mem_read_count  <= 0;
            mem_write_count <= 0;
            rf_read_count   <= 0;
            rf_write_count  <= 0;
        end else if (!halt) begin
            cycle_count <= cycle_count + 1;
            instr_count <= instr_count + 1;

            // Memory access counters
            if (MemRead)
                mem_read_count <= mem_read_count + 1;
            if (MemWrite)
                mem_write_count <= mem_write_count + 1;

            // Register file read counters
            if ((opcode != 7'b1101111) && (rs1 != 0))
                rf_read_count <= rf_read_count + 1;
            if ((opcode == 7'b0110011 || opcode == 7'b0100011 || opcode == 7'b1100011) && (rs2 != 0))
                rf_read_count <= rf_read_count + 1;

            // Register file write counter
            if (RegWrite && rd != 0)
                rf_write_count <= rf_write_count + 1;
        end
    end

    // TODO: Power estimation hooks can be added for FPGA implementation
endmodule
