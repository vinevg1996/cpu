module cpu(clk, rst);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    parameter integer INSTRACTION_NUMBERS = 8;
    input clk, rst;

//_________________________________
// wires for step_1
// _output_wires
wire [WIDTH-1:0] pc_plus_one_step_1;
wire [WIDTH-1:0] instr_step_1;
// control_wires
wire is_load_PC;
wire [1:0] control_mux_for_PC;

//_________________________________
// wires for step_2
// data_wires
// _input_wires
wire [WIDTH-1:0] pc_plus_one_step_2;
wire [WIDTH-1:0] instr_step_2;
// _output_wires
wire [5:0] opcode_step_2;
wire [5:0] funct_step_2;
wire [4:0] out_rt_rd_mux_step_2;
wire [WIDTH-1:0] rdata1_step_2;
wire [WIDTH-1:0] rdata2_step_2;
wire [WIDTH-1:0] ext_IMM_step_2;
wire [WIDTH-1:0] ext_ADDR_step_2;
// control_wires
wire is_write_reg;
wire control_mux_for_rt_rd;
wire control_mux_for_wnum;

//_________________________________
// wires for step_3
// _input_wires
wire [5:0] opcode_step_3;
wire [5:0] funct_step_3;
wire [4:0] out_rt_rd_mux_step_3;
wire [WIDTH-1:0] pc_plus_one_step_3;
wire [WIDTH-1:0] rdata1_step_3;
wire [WIDTH-1:0] rdata2_step_3;
wire [WIDTH-1:0] ext_IMM_step_3;
wire [WIDTH-1:0] ext_ADDR_step_3;
// _output_wires
wire [WIDTH-1:0] pc_plus_one_plus_IMM_step_3;
wire is_alu_zero_step_3;
wire [WIDTH-1:0] out_alu_step_3;
// _control_wires
wire control_mux_for_alu;
wire [5:0] alu_op;

//_________________________________
// wires for step_4
// _input_wires
wire [5:0] opcode_step_4;
wire [4:0] out_rt_rd_mux_step_4;
wire [WIDTH-1:0] pc_plus_one_step_4;
wire is_alu_zero_step_4;
wire [WIDTH-1:0] out_alu_step_4;
wire [WIDTH-1:0] rdata2_step_4;
wire [WIDTH-1:0] pc_plus_one_plus_IMM_step_4;
wire [WIDTH-1:0] ext_ADDR_step_4;
// _output_wires
wire [WIDTH-1:0] out_memory_step_4;
// control_wires
wire is_write_mem;

//_________________________________
// wires for step_5
wire [5:0] opcode_step_5;
wire [4:0] out_rt_rd_mux_step_5;
wire [WIDTH-1:0] out_alu_step_5;
wire [WIDTH-1:0] out_memory_step_5;
// _output_wires
wire [WIDTH-1:0] out_mux_for_write_back_step_5;
// control_wires
wire control_mux_for_write_back;

wire is_hazard;
wire is_branch, is_branch_step_2, is_branch_step_3, is_branch_step_4;
//wire nop_step_3, nop_step_5;
wire nop_step_2;
wire nop_step_3;
wire nop_step_4;
wire is_load_for_launch_1_2;
wire is_branch_fault;

wire is_send_from_alu_rs;
wire is_send_from_alu_rt;
wire is_send_from_mem_rs;
wire is_send_from_mem_rt;

// step 1
cpu_step_1 #(.WIDTH(WIDTH), .INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
    _cpu_step_1(// input 
                .clk(clk), .rst(rst),
                .ext_ADDR_step_4(ext_ADDR_step_4), .pc_plus_one_plus_IMM_step_4(pc_plus_one_plus_IMM_step_4),
                // output
                .pc_plus_one_step_1(pc_plus_one_step_1), .instr_step_1(instr_step_1),
                // control
                .is_load_PC(is_load_PC), .control_mux_for_PC(control_mux_for_PC));

fsm_step_1 _fsm_step_1(// input 
                       .clk(clk), .rst(rst),
                       .is_alu_zero_step_4(is_alu_zero_step_4), .opcode_step_4(opcode_step_4),
                       // output
                       .control_mux_for_PC(control_mux_for_PC));

reset_register #(.WIDTH(WIDTH)) _pc_plus_one_1_2_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(is_load_for_launch_1_2), .in(pc_plus_one_step_1), .out(pc_plus_one_step_2));
reset_register #(.WIDTH(WIDTH)) _instr_1_2_launch (.rst(rst), .nop_rst(nop_step_2), .clk(clk), .load(is_load_for_launch_1_2), .in(instr_step_1), .out(instr_step_2));

// step 2
cpu_step_2 #(.WIDTH(WIDTH)) 
    _cpu_step_2(// input
                .clk(clk), .rst(rst),
                .instr_step_2(instr_step_2), .wnum_step_5(out_rt_rd_mux_step_5), 
                .wdata_step_5(out_mux_for_write_back_step_5),
                .out_alu_step_3(out_alu_step_3),
                .out_mem_step_4(out_memory_step_4),
                // output
                .rdata1_step_2(rdata1_step_2), .rdata2_step_2(rdata2_step_2),
                .ext_IMM_step_2(ext_IMM_step_2), .ext_ADDR_step_2(ext_ADDR_step_2),
                .opcode_step_2(opcode_step_2), .funct_step_2(funct_step_2),
                .out_rt_rd_mux_step_2(out_rt_rd_mux_step_2),
                // control
                .is_write_reg(is_write_reg), .control_mux_for_rt_rd(control_mux_for_rt_rd),
                .control_mux_for_wnum(control_mux_for_wnum),
                .is_send_from_alu_rs(is_send_from_alu_rs),
                .is_send_from_alu_rt(is_send_from_alu_rt),
                .is_send_from_mem_rs(is_send_from_mem_rs),
                .is_send_from_mem_rt(is_send_from_mem_rt));

fsm_step_2 _fsm_step_2(// input 
                       .clk(clk), .rst(rst),
                       .opcode_step_2(opcode_step_2), .opcode_step_3(opcode_step_3),
                       .opcode_step_4(opcode_step_4), .opcode_step_5(opcode_step_5),
                       .rs(_cpu_step_2.rs), .rt(_cpu_step_2.rt), 
                       .out_rt_rd_mux_step_3(out_rt_rd_mux_step_3),
                       .out_rt_rd_mux_step_4(out_rt_rd_mux_step_4),
                       // output
                       .is_write_reg(is_write_reg), .control_mux_for_rt_rd(control_mux_for_rt_rd),
                       .control_mux_for_wnum(control_mux_for_wnum),
                       .is_send_from_alu_rs(is_send_from_alu_rs),
                       .is_send_from_alu_rt(is_send_from_alu_rt),
                       .is_send_from_mem_rs(is_send_from_mem_rs),
                       .is_send_from_mem_rt(is_send_from_mem_rt));

reset_register #(.WIDTH(6)) _opcode_2_3_launch (.rst(rst), .nop_rst(nop_step_3), .clk(clk), .load(1'b1), .in(opcode_step_2), .out(opcode_step_3));
reset_register #(.WIDTH(6)) _funct_2_3_launch (.rst(rst), .nop_rst(nop_step_3), .clk(clk), .load(1'b1), .in(funct_step_2), .out(funct_step_3));
reset_register #(.WIDTH(5)) _out_rt_rd_mux_2_3_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(out_rt_rd_mux_step_2), .out(out_rt_rd_mux_step_3));
reset_register #(.WIDTH(WIDTH)) _pc_plus_one_2_3_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(pc_plus_one_step_2), .out(pc_plus_one_step_3));
reset_register #(.WIDTH(WIDTH)) _rdata1_2_3_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(rdata1_step_2), .out(rdata1_step_3));
reset_register #(.WIDTH(WIDTH)) _rdata2_2_3_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(rdata2_step_2), .out(rdata2_step_3));
reset_register #(.WIDTH(WIDTH)) _ext_IMM_2_3_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(ext_IMM_step_2), .out(ext_IMM_step_3));
reset_register #(.WIDTH(WIDTH)) _ext_ADDR_2_3_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(ext_ADDR_step_2), .out(ext_ADDR_step_3));

// step_3
cpu_step_3 #(.WIDTH(WIDTH)) 
    _cpu_step_3(// input
                .clk(clk), .rst(rst),
                .pc_plus_one_step_3(pc_plus_one_step_3),
                .rdata1_step_3(rdata1_step_3), .rdata2_step_3(rdata2_step_3),
                .ext_IMM_step_3(ext_IMM_step_3),
                // output
                .pc_plus_one_plus_IMM_step_3(pc_plus_one_plus_IMM_step_3),
                .out_alu_step_3(out_alu_step_3), .is_alu_zero_step_3(is_alu_zero_step_3),
                // control
                .alu_op(alu_op), .control_mux_for_alu(control_mux_for_alu));

fsm_step_3 _fsm_step_3(// input 
                       .clk(clk), .rst(rst),
                       .opcode_step_3(opcode_step_3),
                       // output
                       .control_mux_for_alu(control_mux_for_alu), .alu_op(alu_op));

reset_register #(.WIDTH(6)) _opcode_3_4_launch (.rst(rst), .nop_rst(nop_step_4), .clk(clk), .load(1'b1), .in(opcode_step_3), .out(opcode_step_4));
reset_register #(.WIDTH(5)) _out_rt_rd_mux_3_4_launch (.rst(rst), .nop_rst(1'b0),  .clk(clk), .load(1'b1), .in(out_rt_rd_mux_step_3), .out(out_rt_rd_mux_step_4));
reset_register #(.WIDTH(WIDTH)) _pc_plus_one_3_4_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(pc_plus_one_step_3), .out(pc_plus_one_step_4));
reset_register #(.WIDTH(1)) _is_alu_zero_3_4_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(is_alu_zero_step_3), .out(is_alu_zero_step_4));
reset_register #(.WIDTH(WIDTH)) _out_alu_3_4_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(out_alu_step_3), .out(out_alu_step_4));
reset_register #(.WIDTH(WIDTH)) _rdata2_3_4_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(rdata2_step_3), .out(rdata2_step_4));
reset_register #(.WIDTH(WIDTH)) _pc_plus_one_plus_IMM_3_4_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(pc_plus_one_plus_IMM_step_3), .out(pc_plus_one_plus_IMM_step_4));
reset_register #(.WIDTH(WIDTH)) _ext_ADDR_3_4_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(ext_ADDR_step_3), .out(ext_ADDR_step_4));

// step_4
cpu_step_4 #(.WIDTH(WIDTH)) 
    _cpu_step_4(// input
                .clk(clk), .rst(rst),
                .out_alu_step_4(out_alu_step_4), .rdata2_step_4(rdata2_step_4),
                // output
                .out_memory_step_4(out_memory_step_4),
                // control
                .is_write_mem(is_write_mem));

fsm_step_4 _fsm_step_4(// input 
                       .clk(clk), .rst(rst),
                       .opcode_step_4(opcode_step_4),
                       // output
                       .is_write_mem(is_write_mem));

reset_register #(.WIDTH(6)) _opcode_4_5_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(opcode_step_4), .out(opcode_step_5));
reset_register #(.WIDTH(5)) _out_rt_rd_mux_4_5_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(out_rt_rd_mux_step_4), .out(out_rt_rd_mux_step_5));
reset_register #(.WIDTH(WIDTH)) _out_alu_4_5_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(out_alu_step_4), .out(out_alu_step_5));
reset_register #(.WIDTH(WIDTH)) _out_memory_4_5_launch (.rst(rst), .nop_rst(1'b0), .clk(clk), .load(1'b1), .in(out_memory_step_4), .out(out_memory_step_5));

// step_5
cpu_step_5 #(.WIDTH(WIDTH)) 
    _cpu_step_5(// input
                .clk(clk), .rst(rst),
                .out_alu_step_5(out_alu_step_5), .out_memory_step_5(out_memory_step_5),
                // output
                .out_mux_for_write_back_step_5(out_mux_for_write_back_step_5),
                // control
                .control_mux_for_write_back(control_mux_for_write_back));

fsm_step_5 _fsm_step_5(// input 
                       .clk(clk), .rst(rst),
                       .opcode_step_5(opcode_step_5),
                       // output
                       .control_mux_for_write_back(control_mux_for_write_back));


hazard _hazard(// input 
               .clk(clk), .rst(rst),
               .opcode_step_2(opcode_step_2),
               .rs(_cpu_step_2.rs), .rt(_cpu_step_2.rt),  
               .opcode_step_3(opcode_step_3), .out_rt_rd_mux_step_3(out_rt_rd_mux_step_3),
               .opcode_step_4(opcode_step_4), .out_rt_rd_mux_step_4(out_rt_rd_mux_step_4),
               .opcode_step_5(opcode_step_5), .out_rt_rd_mux_step_5(out_rt_rd_mux_step_5),
               // output
               .is_hazard(is_hazard));

branch _branch(// input 
             .clk(clk), .rst(rst),
             .opcode_step_4(opcode_step_4),
             .is_alu_zero_step_4(is_alu_zero_step_4),
             // output
             .is_branch_fault(is_branch_fault)
             );

launch_nop #(.WIDTH(WIDTH), .INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
            _launch_nop(// input
                       .is_hazard(is_hazard), .is_branch_fault(is_branch_fault),
                       .pc_out(_cpu_step_1.pc_out),
                       // output
                       .is_load_PC(is_load_PC),
                       .is_load_for_launch_1_2(is_load_for_launch_1_2),
                       .nop_step_2(nop_step_2),
                       .nop_step_3(nop_step_3),
                       .nop_step_4(nop_step_4)
                      );

endmodule