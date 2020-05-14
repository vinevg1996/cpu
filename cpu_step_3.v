module cpu_step_3(// input
       clk, rst,
       pc_plus_one_step_3,
       rdata1_step_3, rdata2_step_3, ext_IMM_step_3,
       // output
       pc_plus_one_plus_IMM_step_3,
       out_alu_step_3, is_alu_zero_step_3,
       // control
       alu_op, control_mux_for_alu);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 16;
    
    input clk;
    input rst;
    input [WIDTH-1:0] pc_plus_one_step_3;
    input [WIDTH-1:0] rdata1_step_3;
    input [WIDTH-1:0] rdata2_step_3;
    input [WIDTH-1:0] ext_IMM_step_3;
    output [WIDTH-1:0] pc_plus_one_plus_IMM_step_3;
    output [WIDTH-1:0] out_alu_step_3;
    output is_alu_zero_step_3;
    // control
    input [5:0] alu_op;
    input control_mux_for_alu;

wire [WIDTH-1:0] out_mux_for_alu;

mux #(.W(WIDTH), .N(2)) 
    _mux_for_alu({rdata2_step_3, ext_IMM_step_3}, control_mux_for_alu, out_mux_for_alu);

alu _alu(.clk(clk), .rst(rst), .in1(rdata1_step_3), .in2(out_mux_for_alu), 
         .opcode(alu_op), .zero(is_alu_zero_step_3), .out(out_alu_step_3));

adder _adder_plus_IMM(.clk(clk), .rst(rst),
                      .x(pc_plus_one_step_3), .y(ext_IMM_step_3), 
                      .out(pc_plus_one_plus_IMM_step_3));

endmodule