module regs_hazzard(clk, rst, rnum1, rnum2, wnum,
                    is_write_reg,
                    // output
                    is_full_rnum1, is_full_rnum2);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    input clk, rst;
    input [ADDR_WIDTH-1:0] rnum1, rnum2, wnum;
    input is_write_reg;
    output is_full_rnum1, is_full_rnum2;

//reg is_full_regs[0:3];
reg [1:0] curr_wnum;
wire is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3;

demux #(.W(1), .N(4)) _demux(is_write_reg, curr_wnum, 
        {is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3});

mux #(.W(1), .N(4)) 
    _mux_rnum1({is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3}, 
         rnum1[1:0], is_full_rnum1);

mux #(.W(1), .N(4)) 
    _mux_rnum2({is_full_reg_0, is_full_reg_1, is_full_reg_2, is_full_reg_3}, 
         rnum2[1:0], is_full_rnum2);

//always @(negedge clk, posedge rst) begin
always @(posedge clk, posedge rst) begin
    if (rst) begin
        curr_wnum <= 0;
    end
    else begin
        curr_wnum <= wnum[1:0];
    end
end

endmodule