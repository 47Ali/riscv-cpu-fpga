module alu (
    input wire [31:0] a, b,
    input wire [3:0] alu_control,
    input wire alu_ctrl_relu,
    input wire alu_ctrl_matmul,
    input wire alu_ctrl_dotprod,
    output reg [31:0] result,
    output wire zero
);

    assign zero = (result == 0);

    // ReLU
    wire [31:0] relu_out = (a[31] == 1'b1) ? 32'd0 : a;

    // Packed 16-bit operands
    wire [15:0] aa = a[15:0];
    wire [15:0] bb = a[31:16];
    wire [15:0] cc = b[15:0];
    wire [15:0] dd = b[31:16];
    wire [31:0] dot_out    = $signed(aa)*$signed(cc) + $signed(bb)*$signed(dd);
    wire [31:0] matmul_out = dot_out;

    always @(*) begin
        case (1'b1)
            alu_ctrl_relu:    result = relu_out;
            alu_ctrl_matmul:  result = matmul_out;
            alu_ctrl_dotprod: result = dot_out;
            default: begin
                case (alu_control)
                    4'b0000: result = a & b;                     // AND
                    4'b0001: result = a | b;                     // OR
                    4'b0010: result = a + b;                     // ADD
                    4'b0110: result = a - b;                     // SUB
                    4'b0011: result = a ^ b;                     // XOR
                    4'b0100: result = a << b[4:0];               // SLL
                    4'b0101: result = a >> b[4:0];               // SRL
                    4'b1101: result = $signed(a) >>> b[4:0];     // SRA
                    4'b0111: result = ($signed(a) < $signed(b)) ? 1 : 0; // SLT
                    4'b1000: result = (a < b) ? 1 : 0;           // SLTU
                    4'b1001: result = a * b;                     // MUL
                    default: result = 0;
                endcase
            end
        endcase
    end
endmodule
