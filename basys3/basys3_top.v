module basys3_top(
    input  wire        CLK100MHZ,
    input  wire        btnC,
    output wire [15:0] led
);

    wire [31:0] cycle_count;

    cpu #(.MEMFILE("program.mem")) core (
        .clk   (CLK100MHZ),
        .reset (btnC),
        .cycle_count(cycle_count)
    );

    // Clock divider for human visible LED updates (~0.7s)
    reg [25:0] slow_cnt = 0;
    reg [15:0] led_reg  = 0;

    always @(posedge CLK100MHZ) begin
        slow_cnt <= slow_cnt + 1;
        if (slow_cnt == 0)
            led_reg <= cycle_count[31:16];
    end

    assign led = led_reg;
endmodule
