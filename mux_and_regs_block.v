module mux_and_regs_block(// inputs
            clk, rst, 
            mem_values_bus, in_tag, in_data,
             // outputs
            new_tags_bus, new_cache_bus,
             // controls
            is_load_bus, control_tag,
            is_write_mem, control_data_mux
                 );
    parameter integer W = 32;
    parameter integer N = 4; // size of cache
    localparam MEM_SIZE = 2 * N; // size of mem
    localparam ADDR_WIDTH = $clog2(W);
    localparam LOG_N = $clog2(N);
    
    input clk, rst;
    input [W*MEM_SIZE-1:0] mem_values_bus;
    input in_tag;
    input [W-1:0] in_data;
    output [LOG_N-1:0] new_tags_bus;
    output [W*N-1:0] new_cache_bus;
    // controls
    input [LOG_N-1:0] is_load_bus;
    input control_tag;
    input is_write_mem;
    input [N-1:0] control_data_mux;

wire [W*N-1:0] out_mux_cache_bus;
wire [W*N-1:0] out_reg_cache_bus;

generate
    genvar k;
    for(k = 0; k < N; k = k + 1)
    begin : assign_1_block
        mux #(.W(W), .N(2)) 
        _mux_cache({mem_values_bus[W*(MEM_SIZE-k)-1:W*(MEM_SIZE-k-1)], 
                    mem_values_bus[W*(N-k)-1:W*(N-k-1)]}, 
                    control_tag, out_mux_cache_bus[W*(N-k)-1:W*(N-k-1)]);
    end
endgenerate
/*
generate
    genvar i;
    for(i = 0; i < LOG_N; i = i + 1)
        generate
            genvar j;
            for(j = 0; j < LOG_N; j = j + 1)
            integer id = i * LOG_N + j;
            begin : assign_2_block
                register _reg(.clk(clk), .rst(rst), 
                    .load(is_load_bus[(LOG_N-i)-1:(LOG_N-i-1)]),
                    .in(out_mux_cache_bus[W*(N-id)-1:W*(N-id-1)]),
                    .out(out_reg_cache_bus[W*(N-id)-1:W*(N-id-1)]));

            end
        endgenerate
endgenerate
*/

register #(.WIDTH(W)) _reg_0(.clk(clk), .rst(rst), 
    .load(is_load_bus[1:1]),
    .in(out_mux_cache_bus[W*(N)-1:W*(N-1)]),
    .out(out_reg_cache_bus[W*(N)-1:W*(N-1)]));
register #(.WIDTH(W)) _reg_1(.clk(clk), .rst(rst), 
    .load(is_load_bus[1:1]),
    .in(out_mux_cache_bus[W*(N-1)-1:W*(N-1-1)]),
    .out(out_reg_cache_bus[W*(N-1)-1:W*(N-1-1)]));
register #(.WIDTH(W)) _reg_2(.clk(clk), .rst(rst), 
    .load(is_load_bus[0:0]),
    .in(out_mux_cache_bus[W*(N-2)-1:W*(N-2-1)]),
    .out(out_reg_cache_bus[W*(N-2)-1:W*(N-2-1)]));
register #(.WIDTH(W)) _reg_3(.clk(clk), .rst(rst), 
    .load(is_load_bus[0:0]),
    .in(out_mux_cache_bus[W*(N-3)-1:W*(N-3-1)]),
    .out(out_reg_cache_bus[W*(N-3)-1:W*(N-3-1)]));

/*
generate
    genvar i;
    for(i = 0; i < LOG_N; i = i + 1)
    integer id = i * LOG_N + j;
    begin : assign_2_block
        register _reg1(.clk(clk), .rst(rst), 
            .load(is_load_bus[(LOG_N-i)-1:(LOG_N-i-1)]),
            .in(out_mux_cache_bus[W*(N-id)-1:W*(N-id-1)]),
            .out(out_reg_cache_bus[W*(N-id)-1:W*(N-id-1)]));
        register _reg2(.clk(clk), .rst(rst), 
            .load(is_load_bus[(LOG_N-i)-1:(LOG_N-i-1)]),
            .in(out_mux_cache_bus[W*(N-id)-1:W*(N-id-1)]),
            .out(out_reg_cache_bus[W*(N-id)-1:W*(N-id-1)]));
    end
endgenerate
*/
generate
    genvar k1;
    for(k1 = 0; k1 < LOG_N; k1 = k1 + 1)
    begin : assign_3_block
        register #(.WIDTH(1)) _reg(.clk(clk), .rst(rst), 
            .load(is_load_bus[(LOG_N-k1)-1:(LOG_N-k1-1)]),
            .in(in_tag),
            .out(new_tags_bus[(LOG_N-k1)-1:(LOG_N-k1-1)]));
    end
endgenerate

generate
    genvar k2;
    for(k2 = 0; k2 < N; k2 = k2 + 1)
    begin : assign_4_block
        mux #(.W(W), .N(2)) 
        _data_mux({out_reg_cache_bus[W*(N-k2)-1:W*(N-k2-1)], in_data}, 
                   control_data_mux[(N-k2)-1:(N-k2-1)], 
                   new_cache_bus[W*(N-k2)-1:W*(N-k2-1)]);
    end
endgenerate

endmodule