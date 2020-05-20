module fsm_step_4_cache_16(// input 
    clk, rst,
    opcode_step_4, tag, index, offset, hit,
    // output
    is_write_mem, is_load_bus, control_tag, 
    control_index, control_offset, control_data_mux);
    parameter integer WIDTH = 32;
    parameter integer MEM_SIZE = 32;
    parameter integer CACHE_SIZE = 16;
    localparam INDEX_SIZE = $clog2(CACHE_SIZE);
    localparam LOG_INDEX_SIZE = $clog2(INDEX_SIZE);

    input clk;
    input rst;
    input [5:0] opcode_step_4;
    input tag;
    input [1:0] index;
    input [1:0] offset;
    input hit;
    output is_write_mem;
    output control_tag;
    output [LOG_INDEX_SIZE-1:0] control_index;
    output [INDEX_SIZE-1:0] control_offset;
    output [INDEX_SIZE-1:0] is_load_bus;
    output [CACHE_SIZE-1:0] control_data_mux;

// sw: opcode == 6'b101011
assign is_write_mem = (opcode_step_4 == 6'b101011);
assign control_tag = tag;
assign control_index = index;
assign control_offset = index * INDEX_SIZE + offset;

wire need_load;
assign need_load = is_write_mem || !(hit);

demux #(.W(1), .N(INDEX_SIZE)) _demux1(need_load, control_index, 
        is_load_bus);

demux #(.W(1), .N(CACHE_SIZE)) _demux2(is_write_mem, control_offset, 
        control_data_mux);

endmodule