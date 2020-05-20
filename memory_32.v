module memory_32(clk, rst, idata, write, addr, 
                 odata, out_regs_bus
                 );
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer MEM_SIZE = 32;
    input [WIDTH-1:0] idata;
    input [ADDR_WIDTH-1:0] addr;
    input clk, rst;
    output [WIDTH-1:0] odata;
    output [WIDTH*MEM_SIZE-1:0] out_regs_bus;
    // control
    input write;

wire [MEM_SIZE-1:0] is_load_in_regs_bus;
wire [4:0] demux_addr;
assign demux_addr = addr[4:0];

demux #(.W(1), .N(MEM_SIZE)) _demux(write, demux_addr, 
        is_load_in_regs_bus);

generate
    genvar i;
    for(i = 0; i < MEM_SIZE; i = i + 1)
    begin : assign_block
        register _reg(.load(is_load_in_regs_bus[(MEM_SIZE-i)-1:(MEM_SIZE-i-1)]), 
                      .clk(clk), .rst(rst), 
                      .in(idata), .out(out_regs_bus[WIDTH*(MEM_SIZE-i)-1:WIDTH*(MEM_SIZE-i-1)]));
    end
endgenerate

mux #(.W(WIDTH), .N(MEM_SIZE)) 
    _mux(out_regs_bus, demux_addr, odata);

endmodule