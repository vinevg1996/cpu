module data_path_cpu(// inputs
                     clk, rst, is_write_reg, is_write_mem, opcode_alu,
                     is_R_type, is_I_type, is_J_type, is_write_from_mem, control_mux_for_PC,
                     // outputs
                     opcode, funct, EX_MEM_is_alu_zero
                    );
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 16;

    input clk, rst, is_write_reg, is_write_mem;
    input is_R_type, is_I_type, is_J_type, is_write_from_mem;
    input [1:0] control_mux_for_PC;
    input [5:0] opcode_alu;
    output [5:0] opcode;
    output [5:0] funct;
    //output is_alu_zero;
    output EX_MEM_is_alu_zero;

// FETCH WIRES
wire [WIDTH-1:0] in_PC;
wire [WIDTH-1:0] curr_inst;
wire [WIDTH-1:0] curr_inst_plus_one;
wire [WIDTH-1:0] instraction;
wire [WIDTH-1:0] IF_ID_instraction;
wire [WIDTH-1:0] IF_ID_curr_inst_plus_one;

// DECODE WIRES
wire [4:0] rs, rt, rd;
wire [4:0] out_mux_for_wnum;
wire [4:0] shamt;
wire [25:0] ADDR;
wire [15:0] IMM;
wire [WIDTH-1:0] expand_IMM;
wire [WIDTH-1:0] expand_ADDR;
wire [WIDTH-1:0] rdata1, rdata2;
wire [WIDTH-1:0] ID_EX_rdata1, ID_EX_rdata2;
wire [WIDTH-1:0] ID_EX_expand_IMM;
wire [WIDTH-1:0] ID_EX_expand_ADDR;
wire [WIDTH-1:0] ID_EX_curr_inst_plus_one;

// EXECUTE WIRES
wire [WIDTH-1:0] curr_inst_plus_one_plus_IMM;
wire [WIDTH-1:0] out_mux_for_alu;
wire is_alu_zero;
wire [WIDTH-1:0] out_alu;
wire [WIDTH-1:0] EX_MEM_curr_inst_plus_one_plus_IMM;
//wire EX_MEM_is_alu_zero;
wire [WIDTH-1:0] EX_MEM_out_alu;
wire [WIDTH-1:0] EX_MEM_rdata2;

// MEMORY WIRES
wire [WIDTH-1:0] out_memory;
wire [WIDTH-1:0] MEM_WB_out_alu;
wire [WIDTH-1:0] MEM_WB_out_memory;

// WRITEBACK WIRES
wire [WIDTH-1:0] WB_data_for_write;

//______________________________________
// WIRES FOR CONVEER
wire is_load_PC;
wire is_IFID_open, is_IDEX_open, is_EXMEM_open, is_MEMWB_open;

wire [2:0] curr_state;
//______________________________________

// FETCH STEP
mux #(.W(WIDTH), .N(3)) 
    _mux_for_PC({curr_inst_plus_one, EX_MEM_curr_inst_plus_one_plus_IMM, ID_EX_expand_ADDR}, 
                 control_mux_for_PC, in_PC);

adder _adder_plus_one(.clk(clk), .rst(rst),
                      .x(curr_inst), .y(32'b1), .out(curr_inst_plus_one));

PC _PC(.load(is_load_PC), .clk(clk), .rst(rst), 
       .in(in_PC), .out(curr_inst));

instractions #(.INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
              _inst(.rst(rst), .curr_command(curr_inst), 
              .out_data(instraction));

register #(.WIDTH(WIDTH)) _IF_ID_curr_inst_plus_one_launch
    (.rst(rst), .clk(clk), .load(is_IFID_open),
     .in(curr_inst_plus_one), .out(IF_ID_curr_inst_plus_one));

register #(.WIDTH(WIDTH)) _IF_ID_instraction_launch
    (.rst(rst), .clk(clk), .load(is_IFID_open),
     .in(instraction), .out(IF_ID_instraction));

// DECODE STEP
assign opcode = IF_ID_instraction[31:26];
assign rs = IF_ID_instraction[25:21];
assign rt = IF_ID_instraction[20:16];
assign rd = IF_ID_instraction[15:11];
assign shamt = IF_ID_instraction[10:6];
assign funct = IF_ID_instraction[5:0];
assign IMM = IF_ID_instraction[15:0];
assign ADDR = IF_ID_instraction[25:0];

mux #(.W(ADDR_WIDTH), .N(2)) 
    _mux_for_regs({rd, rt}, is_I_type, out_mux_for_wnum);

registers _regs(.clk(clk), .rst(rst), .rnum1(rs), .rnum2(rt), .wnum(out_mux_for_wnum), 
                .write(is_write_reg), .wdata(WB_data_for_write), 
                .rdata1(rdata1), .rdata2(rdata2));

assign expand_IMM = {16'b0, IMM};

assign expand_ADDR = {6'b000000, ADDR};

register #(.WIDTH(WIDTH)) _ID_EX_curr_inst_plus_one_launch
    (.rst(rst), .clk(clk), .load(is_IDEX_open),
     .in(IF_ID_curr_inst_plus_one), .out(ID_EX_curr_inst_plus_one));

register #(.WIDTH(WIDTH)) _ID_EX_rdata1_launch
    (.rst(rst), .clk(clk), .load(is_IDEX_open),
     .in(rdata1), .out(ID_EX_rdata1));

register #(.WIDTH(WIDTH)) _ID_EX_rdata2_launch
    (.rst(rst), .clk(clk), .load(is_IDEX_open),
     .in(rdata2), .out(ID_EX_rdata2));

register #(.WIDTH(WIDTH)) _ID_EX_expand_IMM_launch
    (.rst(rst), .clk(clk), .load(is_IDEX_open),
     .in(expand_IMM), .out(ID_EX_expand_IMM));

register #(.WIDTH(WIDTH)) _ID_EX_expand_ADDR_launch
    (.rst(rst), .clk(clk), .load(is_IDEX_open),
     .in(expand_ADDR), .out(ID_EX_expand_ADDR));

// EXECUTE STEP

mux #(.W(WIDTH), .N(2)) 
    _mux_for_alu({ID_EX_rdata2, ID_EX_expand_IMM}, is_I_type, out_mux_for_alu);

alu _alu(.clk(clk), .rst(rst), .in1(ID_EX_rdata1), .in2(out_mux_for_alu), 
         .opcode(opcode_alu), .zero(is_alu_zero), .out(out_alu));

adder _adder_plus_IMM(.clk(clk), .rst(rst),
                      .x(ID_EX_curr_inst_plus_one), .y(ID_EX_expand_IMM), 
                      .out(curr_inst_plus_one_plus_IMM));

register #(.WIDTH(WIDTH)) _EX_MEM_curr_inst_plus_one_plus_IMM_launch
    (.rst(rst), .clk(clk), .load(is_EXMEM_open),
     .in(curr_inst_plus_one_plus_IMM), .out(EX_MEM_curr_inst_plus_one_plus_IMM));

register #(.WIDTH(1)) _EX_MEM_is_alu_zero_launch
    (.rst(rst), .clk(clk), .load(is_EXMEM_open),
     .in(is_alu_zero), .out(EX_MEM_is_alu_zero));

register #(.WIDTH(WIDTH)) _EX_MEM_is_out_alu_launch
    (.rst(rst), .clk(clk), .load(is_EXMEM_open),
     .in(out_alu), .out(EX_MEM_out_alu));

register #(.WIDTH(WIDTH)) _EX_MEM_rdata2_launch
    (.rst(rst), .clk(clk), .load(is_EXMEM_open),
     .in(ID_EX_rdata2), .out(EX_MEM_rdata2));

// MEMORY STEP

memory _memory(.clk(clk), .rst(rst), .idata(EX_MEM_rdata2), .write(is_write_mem), 
               .addr(EX_MEM_out_alu[4:0]), .odata(out_memory));

register #(.WIDTH(WIDTH)) MEM_WB_out_alu_launch
    (.rst(rst), .clk(clk), .load(is_MEMWB_open),
     .in(EX_MEM_out_alu), .out(MEM_WB_out_alu));

register #(.WIDTH(WIDTH)) MEM_WB_out_memory_launch
    (.rst(rst), .clk(clk), .load(is_MEMWB_open),
     .in(out_memory), .out(MEM_WB_out_memory));

// write_back step conveer

mux #(.W(WIDTH), .N(2)) 
    _mux_for_wdata({MEM_WB_out_alu, MEM_WB_out_memory}, is_write_from_mem, WB_data_for_write);


// conveer_control

conveer_control_fsm #(.WIDTH(WIDTH), .INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
                _conveer_control_fsm(
                 // inputs
                 .clk(clk), .rst(rst),
                 .curr_inst(curr_inst),
                 // outputs
                 .is_IFID_open(is_IFID_open),
                 .is_IDEX_open(is_IDEX_open),
                 .is_EXMEM_open(is_EXMEM_open),
                 .is_MEMWB_open(is_MEMWB_open),
                 .is_load_PC(is_load_PC),
                 .curr_state(curr_state)
                 );

endmodule
