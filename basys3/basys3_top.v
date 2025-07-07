module basys3_top(
    input wire CLK100MHZ,
    input wire btnC,
    output wire [15:0] led
);

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("program.mem")) core (
        .clk(CLK100MHZ),
        .reset(btnC),
        .cycle_count(cycle_count)
    );

    assign led = cycle_count[15:0];
endmodule
