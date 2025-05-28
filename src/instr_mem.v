module instr_mem (
    input wire [31:0] addr,
    output wire [31:0] instr
);
    reg [31:0] mem [0:255];  // 1KB instruction memory (256 words)

    initial begin
        $readmemh("program.mem", mem);  // Load instructions from hex file
    end

    assign instr = mem[addr[9:2]];  // Word-aligned address (ignore bottom 2 bits)
endmodule
