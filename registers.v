module registers(clk, rst, rnum1, rnum2, wnum, write, wdata, rdata1, rdata2
                );
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    input [ADDR_WIDTH-1:0] rnum1;
    input [ADDR_WIDTH-1:0] rnum2;
    input [ADDR_WIDTH-1:0] wnum;
    input [WIDTH-1:0] wdata;
    input clk, rst, write;
    output [WIDTH-1:0] rdata1;
    output [WIDTH-1:0] rdata2;

wire [WIDTH-1:0] out_reg0;
wire [WIDTH-1:0] out_reg1;
wire [WIDTH-1:0] out_reg2;
wire [WIDTH-1:0] out_reg3;

assign out_reg0 = 0;

wire is_load_in_reg0;
wire is_load_in_reg1;
wire is_load_in_reg2;
wire is_load_in_reg3;

demux #(.W(1), .N(4)) _demux(write, wnum[1:0], 
        {is_load_in_reg0, is_load_in_reg1, is_load_in_reg2, is_load_in_reg3});
/*
register _reg0(.load(is_load_in_reg0), .clk(clk), .rst(rst), 
               .in(wdata), .out(out_reg0));
*/
register _reg1(.load(is_load_in_reg1), .clk(clk), .rst(rst), 
               .in(wdata), .out(out_reg1));
register _reg2(.load(is_load_in_reg2), .clk(clk), .rst(rst), 
               .in(wdata), .out(out_reg2));
register _reg3(.load(is_load_in_reg3), .clk(clk), .rst(rst), 
               .in(wdata), .out(out_reg3));

mux #(.W(WIDTH), .N(4)) 
    _mux1({out_reg0, out_reg1, out_reg2, out_reg3}, rnum1[1:0], rdata1);

mux #(.W(WIDTH), .N(4)) 
    _mux2({out_reg0, out_reg1, out_reg2, out_reg3}, rnum2[1:0], rdata2);

endmodule