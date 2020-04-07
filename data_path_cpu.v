module data_path_cpu(clk, rst, is_load_PC, is_write_reg, is_write_mem, opcode_alu,
                     is_R_type, is_I_type, is_J_type, is_write_from_mem, control_mux_for_PC,
                     opcode, funct, is_alu_zero,
                     is_full_rnum1, is_full_rnum2
                    );
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 16;
    
    input clk, rst, is_load_PC, is_write_reg, is_write_mem;
    input is_R_type, is_I_type, is_J_type, is_write_from_mem;
    input [1:0] control_mux_for_PC;
    input [5:0] opcode_alu;
    output [5:0] opcode;
    output [5:0] funct;
    output is_alu_zero;
    output is_full_rnum1, is_full_rnum2;

wire [WIDTH-1:0] curr_inst;
wire [WIDTH-1:0] inst_out_command;
wire [WIDTH-1:0] rdata1, rdata2, out_memory;
wire [WIDTH-1:0] out_from_adder_puls_one;
wire [WIDTH-1:0] out_from_adder_puls_IMM;
wire [WIDTH-1:0] out_alu;
//reg [WIDTH-1:0] in_PC;
wire [WIDTH-1:0] in_PC;

wire [4:0] rs, rt, rd;
wire [4:0] shamt;
wire [25:0] ADDR;
wire [15:0] IMM;
wire [WIDTH-1:0] IMM_plus_curr_inst;
wire [15:0] zero;
wire [WIDTH-1:0] expand_IMM;
wire [31:0] expand_ADDR;

wire [WIDTH-1:0] out_mux_for_alu, out_mux_for_wdata;
wire [ADDR_WIDTH-1:0] out_mux_for_wnum;

assign opcode = inst_out_command[31:26];
assign rs = inst_out_command[25:21];
assign rt = inst_out_command[20:16];
assign rd = inst_out_command[15:11];
assign shamt = inst_out_command[10:6];
assign funct = inst_out_command[5:0];
assign IMM = inst_out_command[15:0];
assign zero = 0;
//assign expand_IMM = {zero, IMM};
assign expand_IMM = {16'b0, IMM};
assign ADDR = inst_out_command[25:0];
assign expand_ADDR = {6'b000000, ADDR};

PC _PC(.load(is_load_PC), .clk(clk), .rst(rst), .in(in_PC), .out(curr_inst));

instractions #(.INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
              _inst(.rst(rst), .curr_command(curr_inst), 
              .out_data(inst_out_command));

mux #(.W(ADDR_WIDTH), .N(2)) 
    _mux_for_regs({rd, rt}, is_I_type, out_mux_for_wnum);

registers _regs(.clk(clk), .rst(rst), .rnum1(rs), .rnum2(rt), .wnum(out_mux_for_wnum), 
                .write(is_write_reg), .wdata(out_mux_for_wdata), 
                .rdata1(rdata1), .rdata2(rdata2));

mux #(.W(WIDTH), .N(2)) 
    _mux_for_alu({rdata2, expand_IMM}, is_I_type, out_mux_for_alu);

alu _alu(.clk(clk), .rst(rst), .in1(rdata1), .in2(out_mux_for_alu), 
         .opcode(opcode_alu), .zero(is_alu_zero), .out(out_alu));

memory _memory(.clk(clk), .rst(rst), .idata(rdata2), .write(is_write_mem), 
               .addr(out_alu[4:0]), .odata(out_memory));

mux #(.W(WIDTH), .N(2)) 
    _mux_for_wdata({out_alu, out_memory}, is_write_from_mem, out_mux_for_wdata);


// hazzards
regs_hazzard _regs_hazzard(.clk(clk), .rst(rst), .rnum1(rs), .rnum2(rt), .wnum(rt),
                           .is_write_reg(is_write_reg), 
                           .is_full_rnum1(is_full_rnum1), .is_full_rnum2(is_full_rnum2));

adder _adder_plus_one(.clk(clk), .rst(rst), .load(is_load_PC),
                      .x(curr_inst), .y(32'b1), .out(out_from_adder_puls_one));

adder _adder_puls_IMM(.clk(clk), .rst(rst),
                      .x(curr_inst), .y(expand_IMM), .out(out_from_adder_puls_IMM));

mux #(.W(WIDTH), .N(3)) 
    _mux_for_PC({out_from_adder_puls_one, out_from_adder_puls_IMM, expand_ADDR}, 
                 control_mux_for_PC, in_PC);

endmodule
