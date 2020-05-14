module cpu_step_4(// input
       clk, rst,
       out_alu_step_4, rdata2_step_4,
       // output
       out_memory_step_4,
       // control
       is_write_mem);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 16;
    
    input clk;
    input rst;
    input [WIDTH-1:0] out_alu_step_4;
    input [WIDTH-1:0] rdata2_step_4;
    output [WIDTH-1:0] out_memory_step_4;
    // control
    input is_write_mem;

memory _memory(.clk(clk), .rst(rst), .idata(rdata2_step_4), .write(is_write_mem), 
               .addr(out_alu_step_4[4:0]), .odata(out_memory_step_4));

endmodule