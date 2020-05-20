module cache_16(// inputs
            clk, rst, 
            in_tag, in_cache_bus, 
            // outputs
            out_cache_data, hit,
            // controls
            is_load_bus, 
            control_index, control_offset
            );
    parameter integer WIDTH = 32;
    parameter integer CACHE_SIZE = 16; // size of cache
    localparam INDEX_SIZE = $clog2(CACHE_SIZE);
    localparam LOG_INDEX_SIZE = $clog2(INDEX_SIZE);

    input clk, rst;
    input in_tag;
    input [WIDTH*CACHE_SIZE-1:0] in_cache_bus;
    output [WIDTH-1:0] out_cache_data;
    output hit;
    // controls
    input [INDEX_SIZE-1:0] is_load_bus;
    input [LOG_INDEX_SIZE-1:0] control_index;
    input [INDEX_SIZE-1:0] control_offset;

wire [INDEX_SIZE-1:0] out_valid_bus;
wire [INDEX_SIZE-1:0] out_tag_bus;
wire [WIDTH*CACHE_SIZE-1:0] out_cache_bus;

wire curr_valid;
wire curr_tag;

generate
    genvar i1;
    for(i1 = 0; i1 < INDEX_SIZE; i1 = i1 + 1)
    begin : assign_1_block
        register #(.WIDTH(1)) 
            _valid(.load(1'b1), .clk(clk), .rst(rst), 
                   .in(1'b1), 
                   .out(out_valid_bus[(INDEX_SIZE-i1)-1:INDEX_SIZE-i1-1]));
    end
endgenerate

generate
    genvar i2;
    for(i2 = 0; i2 < INDEX_SIZE; i2 = i2 + 1)
    begin : assign_2_block
        register #(.WIDTH(1)) 
            _tag(.load(is_load_bus[(INDEX_SIZE-i2)-1:INDEX_SIZE-i2-1]), 
                 .clk(clk), .rst(rst), 
                 .in(in_tag), 
                 .out(out_tag_bus[(INDEX_SIZE-i2)-1:INDEX_SIZE-i2-1]));
    end
endgenerate

generate
    genvar c0;
    for(c0 = 0; c0 < INDEX_SIZE; c0 = c0 + 1)
    begin : assign_cache_block
        register _cache0(.load(is_load_bus[3:3]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus[WIDTH*(CACHE_SIZE-c0)-1:WIDTH*(CACHE_SIZE-c0-1)]), 
                 .out(out_cache_bus[WIDTH*(CACHE_SIZE-c0)-1:WIDTH*(CACHE_SIZE-c0-1)]));
        register _cache1(.load(is_load_bus[2:2]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus[WIDTH*(CACHE_SIZE-INDEX_SIZE-c0)-1:WIDTH*(CACHE_SIZE-INDEX_SIZE-c0-1)]), 
                 .out(out_cache_bus[WIDTH*(CACHE_SIZE-INDEX_SIZE-c0)-1:WIDTH*(CACHE_SIZE-INDEX_SIZE-c0-1)]));
        register _cache2(.load(is_load_bus[1:1]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus[WIDTH*(CACHE_SIZE-(2*INDEX_SIZE)-c0)-1:WIDTH*(CACHE_SIZE-(2*INDEX_SIZE)-c0-1)]), 
                 .out(out_cache_bus[WIDTH*(CACHE_SIZE-(2*INDEX_SIZE)-c0)-1:WIDTH*(CACHE_SIZE-(2*INDEX_SIZE)-c0-1)]));
        register _cache3(.load(is_load_bus[0:0]), 
                 .clk(clk), .rst(rst), 
                 .in(in_cache_bus[WIDTH*(CACHE_SIZE-(3*INDEX_SIZE)-c0)-1:WIDTH*(CACHE_SIZE-(3*INDEX_SIZE)-c0-1)]), 
                 .out(out_cache_bus[WIDTH*(CACHE_SIZE-(3*INDEX_SIZE)-c0)-1:WIDTH*(CACHE_SIZE-(3*INDEX_SIZE)-c0-1)]));
    end
endgenerate

mux #(.W(WIDTH), .N(CACHE_SIZE)) 
    _data_mux(out_cache_bus, control_offset, out_cache_data);

mux #(.W(1), .N(INDEX_SIZE)) 
    _valid_mux(out_valid_bus, control_index, curr_valid);

mux #(.W(1), .N(INDEX_SIZE)) 
    _tag_mux(out_tag_bus, control_index, curr_tag);

assign hit = (curr_valid) && (in_tag == curr_tag);

endmodule