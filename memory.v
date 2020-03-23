module memory(clk, rst, idata, write, addr, odata,
	// added_for_debug
	out_reg0, out_reg1, out_reg2, out_reg3
	);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    input [WIDTH-1:0] idata;
    input [ADDR_WIDTH-1:0] addr;
    input clk, rst, write;
    output [WIDTH-1:0] odata;
    // added_for_debug
    output [WIDTH-1:0] out_reg0;
    output [WIDTH-1:0] out_reg1;
    output [WIDTH-1:0] out_reg2;
    output [WIDTH-1:0] out_reg3;
/*
wire [WIDTH-1:0] out_reg0;
wire [WIDTH-1:0] out_reg1;
wire [WIDTH-1:0] out_reg2;
wire [WIDTH-1:0] out_reg3;
*/
wire [WIDTH-1:0] out_reg4;
wire [WIDTH-1:0] out_reg5;
wire [WIDTH-1:0] out_reg6;
wire [WIDTH-1:0] out_reg7;

wire is_load_in_reg0;
wire is_load_in_reg1;
wire is_load_in_reg2;
wire is_load_in_reg3;
wire is_load_in_reg4;
wire is_load_in_reg5;
wire is_load_in_reg6;
wire is_load_in_reg7;

demux #(.W(1), .N(8)) _demux(write, addr[2:0], 
        {is_load_in_reg0, is_load_in_reg1, is_load_in_reg2, is_load_in_reg3,
         is_load_in_reg4, is_load_in_reg5, is_load_in_reg6, is_load_in_reg7});

register _reg0(.load(is_load_in_reg0), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg0));
register _reg1(.load(is_load_in_reg1), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg1));
register _reg2(.load(is_load_in_reg2), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg2));
register _reg3(.load(is_load_in_reg3), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg3));
register _reg4(.load(is_load_in_reg4), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg4));
register _reg5(.load(is_load_in_reg5), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg5));
register _reg6(.load(is_load_in_reg6), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg6));
register _reg7(.load(is_load_in_reg7), .clk(clk), .rst(rst), 
               .in(idata), .out(out_reg7));

mux #(.W(WIDTH), .N(8)) 
    _mux({out_reg0, out_reg1, out_reg2, out_reg3, out_reg4, out_reg5, out_reg6, out_reg7}, 
         addr[2:0], odata);

endmodule