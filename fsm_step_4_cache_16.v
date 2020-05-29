module fsm_step_4_cache_16(// input 
    clk, rst,
    opcode_step_4, tag, index, offset, 
    hit, hit_0, hit_1,
    // output
    is_write_mem, is_load_bus, control_tag, 
    control_index, control_offset, 
    control_data_mux, control_word_cache);
    
    parameter integer WIDTH = 32;
    parameter integer MEM_SIZE = 32;
    parameter integer CACHE_SIZE = 16;
    localparam HALF_CACHE_SIZE = 8;
    localparam INDEX_SIZE = $clog2(CACHE_SIZE);
    localparam LOG_INDEX_SIZE = $clog2(INDEX_SIZE);

    input clk;
    input rst;
    input [5:0] opcode_step_4;
    input [1:0] tag;
    input index;
    input [1:0] offset;
    input hit, hit_0, hit_1;
    output is_write_mem;
    output [1:0] control_tag;
    output control_index;
    output [2:0] control_offset;
    output [3:0] is_load_bus;
    output [HALF_CACHE_SIZE-1:0] control_data_mux;
    output reg control_word_cache;

// sw: opcode == 6'b101011
assign is_write_mem = (opcode_step_4 == 6'b101011);
assign control_tag = tag;
assign control_index = index;
assign control_offset = index * 4 + offset;

wire need_load;
assign need_load = is_write_mem || !(hit);
wire [1:0] index_load_bus;
wire write_hit;
assign write_hit = (is_write_mem && hit_1) || !(hit);

demux #(.W(1), .N(2)) 
    _demux0(need_load, control_index, 
            index_load_bus);

demux #(.W(1), .N(2)) 
    _demux1(index_load_bus[1:1], write_hit, 
            {is_load_bus[3:3], is_load_bus[1:1]});

demux #(.W(1), .N(2)) 
    _demux2(index_load_bus[0:0], write_hit, 
            {is_load_bus[2:2], is_load_bus[0:0]});

demux #(.W(1), .N(HALF_CACHE_SIZE)) 
    _demux_data(is_write_mem, control_offset, 
                control_data_mux);

always @(*) begin
    if (hit_1) begin
        control_word_cache = 1'b1;
    end
    else begin
        control_word_cache = 1'b0;
    end
end

endmodule