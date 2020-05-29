module cpu_step_4_cache_16(// input
       clk, rst,
       out_alu_step_4, rdata2_step_4,
       // output
       out_cache_step_4, hit, hit_0, hit_1,
       tag, index, offset,
       // control
       is_write_mem, is_load_bus,
       control_tag, control_index, 
       control_offset, control_data_mux, control_word_cache
       );
    parameter integer WIDTH = 32;
    parameter integer MEM_SIZE = 32;
    parameter integer CACHE_SIZE = 16;
    localparam HALF_CACHE_SIZE = 8;
    localparam INDEX_SIZE = $clog2(CACHE_SIZE);
    localparam LOG_INDEX_SIZE = $clog2(INDEX_SIZE);

    input clk;
    input rst;
    input [WIDTH-1:0] out_alu_step_4;
    input [WIDTH-1:0] rdata2_step_4;
    output [WIDTH-1:0] out_cache_step_4;
    output hit, hit_0, hit_1;
    output [1:0] tag;
    output index;
    output [1:0] offset;
    // control
    input is_write_mem;
    input [3:0] is_load_bus;
    input [1:0] control_tag;
    input control_index;
    input [2:0] control_offset;
    input [HALF_CACHE_SIZE-1:0] control_data_mux;
    input control_word_cache;

wire [WIDTH-1:0] out_memory_step_4;
wire [WIDTH*MEM_SIZE-1:0] out_mem_bus;
wire [WIDTH*HALF_CACHE_SIZE-1:0] out_mem_mux_bus;
wire [WIDTH*HALF_CACHE_SIZE-1:0] in_cache_bus;

wire [4:0] addr;
assign addr = out_alu_step_4[4:0];
assign tag = addr[4:3];
assign index = addr[2:2];
assign offset = addr[1:0];

cache_16 #(.WIDTH(WIDTH), .CACHE_SIZE(CACHE_SIZE))
    _cache(// inputs
           .clk(clk), .rst(rst), .in_tag(tag), 
           .in_cache_bus(in_cache_bus), 
           // outputs
           .out_cache_data(out_cache_step_4),
           .hit(hit), .hit_0(hit_0), .hit_1(hit_1),
           // controls
           .is_load_bus(is_load_bus), .control_index(control_index),
           .control_offset(control_offset),
           .control_word_cache(control_word_cache));

generate
    genvar k;
    for(k = 0; k < HALF_CACHE_SIZE; k = k + 1)
    begin : assign_1_block
        mux #(.W(WIDTH), .N(2)) 
        _cache_mux({out_mem_mux_bus[WIDTH*(HALF_CACHE_SIZE-k)-1:WIDTH*(HALF_CACHE_SIZE-k-1)],
                    rdata2_step_4}, 
                    control_data_mux[(HALF_CACHE_SIZE-k-1):(HALF_CACHE_SIZE-k)-1],
                    in_cache_bus[WIDTH*(HALF_CACHE_SIZE-k)-1:WIDTH*(HALF_CACHE_SIZE-k-1)]);
    end
endgenerate

generate
    genvar i;
    for(i = 0; i < HALF_CACHE_SIZE; i = i + 1)
    begin : assign_2_block
        mux #(.W(WIDTH), .N(4)) 
            _mem_mux({out_mem_bus[WIDTH*(MEM_SIZE-i)-1:WIDTH*(MEM_SIZE-i-1)], 
                      out_mem_bus[WIDTH*(MEM_SIZE-HALF_CACHE_SIZE-i)-1:WIDTH*(MEM_SIZE-HALF_CACHE_SIZE-i-1)], 
                      out_mem_bus[WIDTH*(CACHE_SIZE-i)-1:WIDTH*(CACHE_SIZE-i-1)],
                      out_mem_bus[WIDTH*(CACHE_SIZE-HALF_CACHE_SIZE-i)-1:WIDTH*(CACHE_SIZE-HALF_CACHE_SIZE-i-1)]},
                      control_tag, 
                      out_mem_mux_bus[WIDTH*(HALF_CACHE_SIZE-i)-1:WIDTH*(HALF_CACHE_SIZE-i-1)]);
    end
endgenerate

memory #(.WIDTH(WIDTH), .MEM_SIZE(MEM_SIZE)) 
    _memory_32(.clk(clk), .rst(rst), .idata(rdata2_step_4), .write(is_write_mem), 
               .addr(out_alu_step_4[4:0]), .odata(out_memory_step_4),
               .out_regs_bus(out_mem_bus));

endmodule
