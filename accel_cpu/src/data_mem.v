module data_mem(
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] mem [0:255];

    initial begin
        // Optionally pre-load memory from file
    end

    always @(posedge clk) begin
        if (mem_write) begin
            mem[addr[9:2]] <= write_data;
        end
    end

    assign read_data = mem_read ? mem[addr[9:2]] : 32'b0;
endmodule
