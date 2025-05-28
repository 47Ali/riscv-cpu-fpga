module cpu_fetch (
    input wire clk,
    input wire reset,
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
    instr_mem imem (
        .addr(pc_out),
        .instr(instr)
    );

    // PC always increments by 4 (for now, no branches)
    assign next_pc = pc_out + 4;

endmodule
