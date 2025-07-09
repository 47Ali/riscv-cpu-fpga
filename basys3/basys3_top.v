module basys3_top(
    input  wire        CLK100MHZ,
    input  wire        btnC,
    output wire [15:0] led,
    output wire [6:0]  seg,
    output wire [3:0]  an,
    output wire        dp
);

    // Clock divider to slow the CPU clock (~0.7s)
    reg [26:0] clk_div = 0;
    always @(posedge CLK100MHZ) begin
        clk_div <= clk_div + 1;
    end
    wire slow_clk = clk_div[26];

    wire [31:0] cycle_count;
    wire [31:0] reg5_val;

    cpu #(.MEMFILE("program.mem")) core (
        .clk   (slow_clk),
        .reset (btnC),
        .cycle_count(cycle_count),
        .reg5_val(reg5_val)
    );

    // Slow LED updates using original clock
    reg [25:0] led_cnt = 0;
    reg [15:0] led_reg = 0;
    always @(posedge CLK100MHZ) begin
        led_cnt <= led_cnt + 1;
        if (led_cnt == 0)
            led_reg <= cycle_count[31:16];
    end
    assign led = led_reg;

    // 7-segment display of register x5 (lower digit only)
    seven_seg_hex sseg(
        .value(reg5_val[3:0]),
        .seg(seg)
    );
    assign an = 4'b1110; // enable one digit
    assign dp = 1'b1;    // decimal point off
=======
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
