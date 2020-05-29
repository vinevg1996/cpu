module cache_16(// inputs
            clk, rst, 
            in_tag, in_cache_bus, 
            // outputs
            out_cache_data, 
            hit, hit_0, hit_1,
            // controls
            is_load_bus, 
            control_index, control_offset,
            control_word_cache
            );
    parameter integer WIDTH = 32;
    parameter integer CACHE_SIZE = 16; // size of cache
    localparam HALF_CACHE_SIZE = 8;
    localparam INDEX_SIZE = $clog2(CACHE_SIZE);
    localparam LOG_INDEX_SIZE = $clog2(INDEX_SIZE);

    input clk, rst;
    input [1:0] in_tag;
    input [WIDTH*HALF_CACHE_SIZE-1:0] in_cache_bus;
    output [WIDTH-1:0] out_cache_data;
    output hit, hit_0, hit_1;
    // controls
    input [3:0] is_load_bus;
    input control_index;
    input [2:0] control_offset;
    input control_word_cache;

// cache_0
wire [1:0] out_valid_bus_0;
wire [3:0] out_tag_bus_0;
wire [WIDTH*HALF_CACHE_SIZE-1:0] out_cache_bus_0;
wire [WIDTH-1:0] out_cache_data_0;
wire curr_valid_0;
wire [1:0] curr_tag_0;

register #(.WIDTH(1)) 
    _valid_0(.load(is_load_bus[3:3]), .clk(clk), .rst(rst), 
             .in(1'b1), 
             .out(out_valid_bus_0[1:1]));

register #(.WIDTH(1)) 
    _valid_1(.load(is_load_bus[2:2]), .clk(clk), .rst(rst), 
             .in(1'b1), 
             .out(out_valid_bus_0[0:0]));

register #(.WIDTH(2)) 
    _tag_0(.load(is_load_bus[3:3]), .clk(clk), .rst(rst), 
           .in(in_tag), 
           .out(out_tag_bus_0[3:2]));

register #(.WIDTH(2)) 
    _tag_1(.load(is_load_bus[2:2]), .clk(clk), .rst(rst), 
           .in(in_tag), 
           .out(out_tag_bus_0[1:0]));

generate
    genvar c0;
    for(c0 = 0; c0 < 4; c0 = c0 + 1)
    begin : assign_cache_0_block_1
        register _cache_0(.load(is_load_bus[3:3]), 
                  .clk(clk), .rst(rst), 
                  .in(in_cache_bus[WIDTH*(HALF_CACHE_SIZE-c0)-1:WIDTH*(HALF_CACHE_SIZE-c0-1)]), 
                  .out(out_cache_bus_0[WIDTH*(HALF_CACHE_SIZE-c0)-1:WIDTH*(HALF_CACHE_SIZE-c0-1)]));
        register _cache_1(.load(is_load_bus[2:2]), 
                  .clk(clk), .rst(rst), 
                  .in(in_cache_bus[WIDTH*(4-c0)-1:WIDTH*(4-c0-1)]), 
                  .out(out_cache_bus_0[WIDTH*(4-c0)-1:WIDTH*(4-c0-1)]));
    end
endgenerate

mux #(.W(WIDTH), .N(HALF_CACHE_SIZE)) 
    _data_mux_0(out_cache_bus_0, control_offset, out_cache_data_0);

mux #(.W(1), .N(2)) 
    _valid_mux_0(out_valid_bus_0, control_index, curr_valid_0);

mux #(.W(2), .N(2)) 
    _tag_mux_0(out_tag_bus_0, control_index, curr_tag_0);

assign hit_0 = (curr_valid_0) && (in_tag == curr_tag_0);


// cache_1
wire [1:0] out_valid_bus_1;
wire [3:0] out_tag_bus_1;
wire [WIDTH*HALF_CACHE_SIZE-1:0] out_cache_bus_1;
wire [WIDTH-1:0] out_cache_data_1;
wire curr_valid_1;
wire [1:0] curr_tag_1;

register #(.WIDTH(1)) 
    _valid_2(.load(is_load_bus[1:1]), .clk(clk), .rst(rst), 
             .in(1'b1), 
             .out(out_valid_bus_1[1:1]));

register #(.WIDTH(1)) 
    _valid_3(.load(is_load_bus[0:0]), .clk(clk), .rst(rst), 
             .in(1'b1), 
             .out(out_valid_bus_1[0:0]));

register #(.WIDTH(2)) 
    _tag_2(.load(is_load_bus[1:1]), .clk(clk), .rst(rst), 
           .in(in_tag), 
           .out(out_tag_bus_1[3:2]));

register #(.WIDTH(2)) 
    _tag_3(.load(is_load_bus[0:0]), .clk(clk), .rst(rst), 
           .in(in_tag), 
           .out(out_tag_bus_1[1:0]));

generate
    genvar c1;
    for(c1 = 0; c1 < 4; c1 = c1 + 1)
    begin : assign_cache_1_block_1
        register _cache_2(.load(is_load_bus[1:1]), 
                  .clk(clk), .rst(rst), 
                  .in(in_cache_bus[WIDTH*(HALF_CACHE_SIZE-c1)-1:WIDTH*(HALF_CACHE_SIZE-c1-1)]), 
                  .out(out_cache_bus_1[WIDTH*(HALF_CACHE_SIZE-c1)-1:WIDTH*(HALF_CACHE_SIZE-c1-1)]));
        register _cache_3(.load(is_load_bus[0:0]), 
                  .clk(clk), .rst(rst), 
                  .in(in_cache_bus[WIDTH*(4-c1)-1:WIDTH*(4-c1-1)]), 
                  .out(out_cache_bus_1[WIDTH*(4-c1)-1:WIDTH*(4-c1-1)]));
    end
endgenerate

mux #(.W(WIDTH), .N(HALF_CACHE_SIZE)) 
    _data_mux_1(out_cache_bus_1, control_offset, out_cache_data_1);

mux #(.W(1), .N(2)) 
    _valid_mux_1(out_valid_bus_1, control_index, curr_valid_1);

mux #(.W(2), .N(2)) 
    _tag_mux_1(out_tag_bus_1, control_index, curr_tag_1);

assign hit_1 = (curr_valid_1) && (in_tag == curr_tag_1);

// cache

mux #(.W(WIDTH), .N(2)) 
    _data_mux({out_cache_data_0, out_cache_data_1},
              control_word_cache, 
              out_cache_data);

assign hit = hit_0 || hit_1;


endmodule