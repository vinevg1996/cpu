module cpu_step_2(// input
                clk, rst,
                instr_step_2, wnum_step_5, wdata_step_5,
                // output
                rdata1_step_2, rdata2_step_2,
                ext_IMM_step_2, ext_ADDR_step_2,
                opcode_step_2, funct_step_2,
                out_rt_rd_mux_step_2,
                // control
                is_write_reg, control_mux_for_rt_rd,
                control_mux_for_wnum);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    
    input clk;
    input rst;
    input [WIDTH-1:0] instr_step_2;
    input [4:0] wnum_step_5;
    input [WIDTH-1:0] wdata_step_5;
    output [WIDTH-1:0] rdata1_step_2;
    output [WIDTH-1:0] rdata2_step_2;
    output [WIDTH-1:0] ext_IMM_step_2; 
    output [WIDTH-1:0] ext_ADDR_step_2;
    output [5:0] opcode_step_2;
    output [5:0] funct_step_2;
    output [4:0] out_rt_rd_mux_step_2;
    // control
    input is_write_reg;
    input control_mux_for_rt_rd;
    input control_mux_for_wnum;


wire [4:0] rs, rt, rd;
wire [4:0] out_mux_for_wnum_mux;
wire [4:0] shamt;
wire [25:0] ADDR;
wire [15:0] IMM;
wire [4:0] wnum;

assign opcode_step_2 = instr_step_2[31:26];
assign rs = instr_step_2[25:21];
assign rt = instr_step_2[20:16];
assign rd = instr_step_2[15:11];
assign shamt = instr_step_2[10:6];
assign funct_step_2 = instr_step_2[5:0];
assign IMM = instr_step_2[15:0];
assign ADDR = instr_step_2[25:0];

mux #(.W(5), .N(2)) 
    _mux_for_rt_rd({rd, rt}, 
                 control_mux_for_rt_rd, out_rt_rd_mux_step_2);

mux #(.W(5), .N(2)) 
    _mux_for_wnum({out_rt_rd_mux_step_2, wnum_step_5}, 
                 control_mux_for_wnum, wnum);

registers _regs(.clk(clk), .rst(rst), .rnum1(rs), .rnum2(rt), .wnum(wnum), 
                .write(is_write_reg), .wdata(wdata_step_5), 
                .rdata1(rdata1_step_2), .rdata2(rdata2_step_2));

assign ext_IMM_step_2 = {16'b0, IMM};

assign ext_ADDR_step_2 = {6'b000000, ADDR};

endmodule