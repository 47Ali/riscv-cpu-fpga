module cpu_fetch #(
    parameter MEMFILE = "program.mem"
) (
    input  wire        clk,
    input  wire        reset,

    // Control signals / targets
    input  wire        jal,            // jal instruction
    input  wire        jalr,           // jalr instruction
    input  wire        branch,         // conditional branch instruction
    input  wire        branch_taken,   // result of branch comparison from ALU
    input  wire [31:0] branch_target,  // PC-relative target for jal/branch
    input  wire [31:0] jalr_target,    // Target address for jalr

    output wire [31:0] instr,
    output wire [31:0] pc_out
);
    wire [31:0] next_pc;

    // Program Counter instance
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    // Instruction Memory instance
    instr_mem #(.INIT_FILE(MEMFILE)) imem (
        .addr(pc_out),
        .instr(instr)
    );

    // Next PC generation with branch/jump handling
    wire [31:0] pc_plus4 = pc_out + 4;

    assign next_pc = jal  ? branch_target :
                     jalr ? jalr_target  :
                     (branch && branch_taken) ? branch_target :
                     pc_plus4;

endmodule
