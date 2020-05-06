module cpu_step_1(// input 
       clk, rst,
       ext_ADDR_step_4, pc_plus_one_plus_IMM_step_4,
       // output
       pc_plus_one_step_1, instr_step_1,
       // control
       is_load_PC, control_mux_for_PC);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 16;
    
    input clk;
    input rst;
    input [WIDTH-1:0] ext_ADDR_step_4;
    input [WIDTH-1:0] pc_plus_one_plus_IMM_step_4;
    output [WIDTH-1:0] pc_plus_one_step_1;
    output [WIDTH-1:0] instr_step_1;
    // control
    input is_load_PC;
    input [1:0] control_mux_for_PC;

wire [WIDTH-1:0] pc_out;
wire [WIDTH-1:0] out_mux_for_PC;

mux #(.W(WIDTH), .N(3)) 
    _mux_for_PC({pc_plus_one_step_1, pc_plus_one_plus_IMM_step_4, ext_ADDR_step_4}, 
                 control_mux_for_PC, out_mux_for_PC);

adder _adder_plus_one(.clk(clk), .rst(rst),
                      .x(pc_out), .y(32'b1), .out(pc_plus_one_step_1));

PC _PC(.load(is_load_PC), .clk(clk), .rst(rst), 
       .in(out_mux_for_PC), .out(pc_out));

instractions #(.INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
              _inst(.rst(rst), .curr_command(pc_out), 
              .out_data(instr_step_1));

endmodule