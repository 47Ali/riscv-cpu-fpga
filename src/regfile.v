module regfile (
    input wire clk,
    input wire we,                         // Write enable
    input wire [4:0] rs1, rs2, rd,         // Register addresses
    input wire [31:0] wd,                  // Write data
    output wire [31:0] rd1, rd2            // Read data outputs
);
    reg [31:0] regs [0:31];

    // Read (asynchronous)
    assign rd1 = (rs1 == 0) ? 0 : regs[rs1];
    assign rd2 = (rs2 == 0) ? 0 : regs[rs2];

    // Write (synchronous)
    always @(posedge clk) begin
        if (we && (rd != 0)) begin
            regs[rd] <= wd;
        end
    end
endmodule
