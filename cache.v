module cache(// inputs
            clk, rst, 
            in_tag, in_index, 
            in_cache_bus_0, in_cache_bus_1, 
            // outputs
            curr_tag_0, curr_index_0, 
            out_cache_data, hit, hit_0, hit_1,
            // controls
            is_load_bus, 
            control_offset, control_cache_word
            );
    parameter integer WIDTH = 32;
    parameter integer CACHE_SIZE = 4; // size of cache
    localparam INDEX_SIZE = $clog2(CACHE_SIZE);
    localparam HALF_CACHE_SIZE = CACHE_SIZE / 2;

    input clk, rst;
    input in_tag;
    input in_index;
    input [WIDTH*HALF_CACHE_SIZE-1:0] in_cache_bus_0;
    input [WIDTH*HALF_CACHE_SIZE-1:0] in_cache_bus_1;
    output curr_tag_0;
    output curr_index_0;
    output [WIDTH-1:0] out_cache_data;
    output hit, hit_0, hit_1;
    // controls
    input [1:0] is_load_bus;
    input control_offset;
    input control_cache_word;

wire [1:0] out_valid_bus;
wire [1:0] out_tag_bus;
wire [WIDTH-1:0] out_cache_0;
wire [WIDTH-1:0] out_cache_1;
wire [WIDTH*HALF_CACHE_SIZE-1:0] out_cache_bus_0;
wire [WIDTH*HALF_CACHE_SIZE-1:0] out_cache_bus_1;

wire curr_valid_0, curr_valid_1;
wire curr_tag_1;
wire curr_index_1;

// cache_0
register #(.WIDTH(1)) 
        _valid0(.load(1'b1), .clk(clk), .rst(rst), 
              	.in(1'b1), .out(curr_valid_0));

register #(.WIDTH(1)) 
        _tag0(.load(is_load_bus[1:1]), .clk(clk), .rst(rst), 
              .in(in_tag), .out(curr_tag_0));

register #(.WIDTH(1)) 
        _index0(.load(is_load_bus[1:1]), .clk(clk), .rst(rst), 
                .in(in_index), .out(curr_index_0));

register _cache0(.load(is_load_bus[1:1]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus_0[WIDTH*(HALF_CACHE_SIZE-0)-1:WIDTH*(HALF_CACHE_SIZE-0-1)]), 
                 .out(out_cache_bus_0[WIDTH*(HALF_CACHE_SIZE-0)-1:WIDTH*(HALF_CACHE_SIZE-0-1)]));

register _cache1(.load(is_load_bus[1:1]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus_0[WIDTH*(HALF_CACHE_SIZE-1)-1:WIDTH*(HALF_CACHE_SIZE-1-1)]), 
                 .out(out_cache_bus_0[WIDTH*(HALF_CACHE_SIZE-1)-1:WIDTH*(HALF_CACHE_SIZE-1-1)]));

// cache_1
register #(.WIDTH(1)) 
        _valid1(.load(1'b1), .clk(clk), .rst(rst), 
                .in(1'b1), .out(curr_valid_1));

register #(.WIDTH(1)) 
        _tag1(.load(is_load_bus[0:0]), .clk(clk), .rst(rst), 
              .in(in_tag), .out(curr_tag_1));

register #(.WIDTH(1)) 
        _index1(.load(is_load_bus[0:0]), .clk(clk), .rst(rst), 
                .in(in_index), .out(curr_index_1));

register _cache2(.load(is_load_bus[0:0]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus_1[WIDTH*(HALF_CACHE_SIZE-0)-1:WIDTH*(HALF_CACHE_SIZE-0-1)]), 
                 .out(out_cache_bus_1[WIDTH*(HALF_CACHE_SIZE-0)-1:WIDTH*(HALF_CACHE_SIZE-0-1)]));

register _cache3(.load(is_load_bus[0:0]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus_1[WIDTH*(HALF_CACHE_SIZE-1)-1:WIDTH*(HALF_CACHE_SIZE-1-1)]), 
                 .out(out_cache_bus_1[WIDTH*(HALF_CACHE_SIZE-1)-1:WIDTH*(HALF_CACHE_SIZE-1-1)]));

/*
mux #(.W(WIDTH), .N(CACHE_SIZE)) 
    _data_mux(out_cache_bus, control_offset, out_cache_data);

mux #(.W(1), .N(2)) 
    _valid_mux(out_valid_bus, control_index, curr_valid);

mux #(.W(1), .N(2)) 
    _tag_mux(out_tag_bus, control_index, curr_tag);
*/
mux #(.W(WIDTH), .N(HALF_CACHE_SIZE)) 
    _data_mux_0(out_cache_bus_0, control_offset, out_cache_0);

mux #(.W(WIDTH), .N(HALF_CACHE_SIZE)) 
    _data_mux_1(out_cache_bus_1, control_offset, out_cache_1);

mux #(.W(WIDTH), .N(2)) 
    _data_mux({out_cache_0, out_cache_1},
              control_cache_word, 
              out_cache_data);

assign hit_0 = (curr_valid_0) && (in_tag == curr_tag_0) && (in_index == curr_index_0);
assign hit_1 = (curr_valid_1) && (in_tag == curr_tag_1) && (in_index == curr_index_1);
assign hit = hit_0 || hit_1;

endmodule