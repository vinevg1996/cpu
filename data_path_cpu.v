module data_path_cpu(clk, rst, is_load_PC, is_write_reg, is_write_mem, opcode_alu,
                     is_R_type, is_I_type, is_J_type, is_write_from_mem, control_mux_for_PC,
                     opcode, funct, out_alu,
                     // added_for_debug
                     curr_inst, inst_out_command, rdata1, rdata2, out_memory,
                     out_reg0, out_reg1, out_reg2, out_reg3,
                     out_mem0, out_mem1, out_mem2, out_mem3,
                     out_from_adder_puls_one, out_from_adder_puls_IMM,
                     expand_IMM);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 16;
    input clk, rst, is_load_PC, is_write_reg, is_write_mem;
    input is_R_type, is_I_type, is_J_type, is_write_from_mem;
    input [1:0] control_mux_for_PC;
    input [5:0] opcode_alu;
    //output reg [5:0] opcode;
    //output reg [5:0] funct;
    output [5:0] opcode;
    output [5:0] funct;
    output [WIDTH-1:0] out_alu;
    // added_for_debug
    output [WIDTH-1:0] curr_inst;
    output [WIDTH-1:0] inst_out_command;
    output [WIDTH-1:0] rdata1, rdata2, out_memory;
    output [WIDTH-1:0] out_reg0;
    output [WIDTH-1:0] out_reg1;
    output [WIDTH-1:0] out_reg2;
    output [WIDTH-1:0] out_reg3;
    output [WIDTH-1:0] out_mem0;
    output [WIDTH-1:0] out_mem1;
    output [WIDTH-1:0] out_mem2;
    output [WIDTH-1:0] out_mem3;
    output [WIDTH-1:0] out_from_adder_puls_one;
    output [WIDTH-1:0] out_from_adder_puls_IMM;
    output [WIDTH-1:0] expand_IMM;

//reg [WIDTH-1:0] in_PC;
//reg [WIDTH-1:0] start_in_PC;
wire [WIDTH-1:0] in_PC;
//reg [1:0] wait_execute_command;
//wire [WIDTH-1:0] curr_inst;
//reg [WIDTH-1:0] out_memory;

// instractions regesters
//reg [5:0] opcode;
wire [4:0] rs, rt, rd;
wire [4:0] shamt;
//reg [5:0] funct;
wire [25:0] ADDR;
wire [15:0] IMM;
wire [WIDTH-1:0] IMM_plus_curr_inst;
wire [15:0] zero;
wire [31:0] expand_IMM;
wire [31:0] expand_ADDR;

wire [WIDTH-1:0] out_mux_for_alu, out_mux_for_wdata;
wire [ADDR_WIDTH-1:0] out_mux_for_wnum;

//wire [WIDTH-1:0] rdata1, rdata2, out_alu, out_memory;
wire is_out_alu_zero;

assign opcode = inst_out_command[31:26];
assign rs = inst_out_command[25:21];
assign rt = inst_out_command[20:16];
assign rd = inst_out_command[15:11];
assign shamt = inst_out_command[10:6];
assign funct = inst_out_command[5:0];
assign IMM = inst_out_command[15:0];
assign zero = 0;
assign expand_IMM = {zero, IMM};
assign ADDR = inst_out_command[25:0];
assign expand_ADDR = {6'b000000, ADDR};

//reg [WIDTH-1:0] const_one;
//wire [WIDTH-1:0] out_from_adder_puls_one, out_from_adder_puls_IMM;

adder _adder_puls_one(.clk(clk), .rst(rst),
                      .x(curr_inst), .y(1'b1), .out(out_from_adder_puls_one));

adder _adder_puls_IMM(.clk(clk), .rst(rst),
                      .x(curr_inst), .y(expand_IMM), .out(out_from_adder_puls_IMM));

mux #(.W(WIDTH), .N(3)) 
    _mux_for_PC({out_from_adder_puls_one, out_from_adder_puls_IMM, expand_ADDR}, 
                 control_mux_for_PC, in_PC);

PC _PC(.load(is_load_PC), .clk(clk), .rst(rst), .in(in_PC), .out(curr_inst));

instractions #(.INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
              _inst(.load(is_load_PC), .clk(clk), .rst(rst), 
              .curr_command(curr_inst), .out_data(inst_out_command));


mux #(.W(ADDR_WIDTH), .N(2)) 
    _mux_for_regs({rd, rt}, is_I_type, out_mux_for_wnum);

registers _regs(.clk(clk), .rst(rst), .rnum1(rs), .rnum2(rt), .wnum(out_mux_for_wnum), 
                .write(is_write_reg), .wdata(out_mux_for_wdata), .rdata1(rdata1), .rdata2(rdata2),
                .out_reg0(out_reg0), .out_reg1(out_reg1),
                .out_reg2(out_reg2), .out_reg3(out_reg3));

mux #(.W(WIDTH), .N(2)) 
    _mux_for_alu({rdata2, expand_IMM}, is_I_type, out_mux_for_alu);

alu _alu(.clk(clk), .rst(rst), .in1(rdata1), .in2(out_mux_for_alu), 
         .opcode(opcode_alu), .zero(is_out_alu_zero), .out(out_alu));

memory _memory(.clk(clk), .rst(rst), .idata(rdata2), .write(is_write_mem), 
               .addr(out_alu[4:0]), .odata(out_memory),
               .out_reg0(out_mem0), .out_reg1(out_mem1), .out_reg2(out_mem2), .out_reg3(out_mem3));

mux #(.W(WIDTH), .N(2)) 
    _mux_for_wdata({out_alu, out_memory}, is_write_from_mem, out_mux_for_wdata);

endmodule
