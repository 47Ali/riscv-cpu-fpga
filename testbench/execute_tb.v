`timescale 1ns / 1ps

module execute_tb;

    // Inputs to the execute module
    reg clk, reset, we, alu_src;
    reg [1:0] alu_op;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] instr;
    reg [2:0] funct3;
    reg funct7_5;

    // Outputs from the execute module
    wire [31:0] alu_result, rd1, rd2;
    wire zero;

    // Instantiate the execution stage
    execute uut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .alu_op(alu_op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .instr(instr),
        .alu_src(alu_src),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .alu_result(alu_result),
        .zero(zero),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $dumpfile("sim/execute.vcd");
        $dumpvars(0, execute_tb);

        // Initial control setup
        reset = 1;
        we = 1;
        alu_op = 2'b10;        // R-type
        alu_src = 0;           // ALU source = register
        funct3 = 3'b000;       // ADD
        funct7_5 = 0;
        instr = 32'h002082b3;  // add x5, x1, x2

        // Initialise x1 = 10 and x2 = 15
        uut.rf.regs[1] = 32'd10;
        uut.rf.regs[2] = 32'd15;

        // Release reset after one cycle
        @(posedge clk);
        reset = 0;

        #5;
        rs1 = 5'd1;
        rs2 = 5'd2;
        rd  = 5'd5;

        #20;
        $display("x1 = %d, x2 = %d, ALU result = %d", uut.rf.regs[1], uut.rf.regs[2], uut.rf.regs[5]);
        $finish;
    end

endmodule
