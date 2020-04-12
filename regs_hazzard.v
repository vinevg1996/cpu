module regs_hazzard(clk, rst, rnum1, rnum2, wnum,
                    is_write_reg, is_nop,
                    // output
                    is_full_rnum1, is_full_rnum2);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    input clk, rst;
    input [ADDR_WIDTH-1:0] rnum1, rnum2, wnum;
    input is_write_reg;
    input is_nop;
    output is_full_rnum1, is_full_rnum2;

//reg is_full_regs[0:3];
wire [ADDR_WIDTH-1:0] prev_wnum;
wire is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3;

demux #(.W(1), .N(4)) _demux(is_write_reg, prev_wnum[1:0], 
        {is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3});

mux #(.W(1), .N(4)) 
    _mux_rnum1({is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3}, 
         rnum1[1:0], is_full_rnum1);

mux #(.W(1), .N(4)) 
    _mux_rnum2({is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3}, 
         rnum2[1:0], is_full_rnum2);

register #(.WIDTH(ADDR_WIDTH))
    _reg(.in(wnum), .out(prev_wnum), .clk(clk), .rst(rst),
         //.load(1'b1));
         .load(!is_nop));

endmodule