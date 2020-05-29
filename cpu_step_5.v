module cpu_step_5(// input
       clk, rst,
       out_alu_step_5, out_memory_step_5,
       // output
       out_mux_for_write_back_step_5,
       // control
       control_mux_for_write_back);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 16;
    input clk;
    input rst;
    input [WIDTH-1:0] out_alu_step_5;
    input [WIDTH-1:0] out_memory_step_5;
    output [WIDTH-1:0] out_mux_for_write_back_step_5;
    // control
    input control_mux_for_write_back;

mux #(.W(WIDTH), .N(2)) 
    _mux_for_alu({out_alu_step_5, out_memory_step_5}, 
        control_mux_for_write_back, out_mux_for_write_back_step_5);

endmodule