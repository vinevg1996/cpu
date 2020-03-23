`timescale 1 ns / 100 ps
// testbench is a module which only task is to test another module
// testbench is for simulation only, not for synthesis

module cpu;
    parameter integer WIDTH = 32;
    // added for debug
    wire [WIDTH-1:0] rdata1, rdata2, out_alu, out_memory;
    wire [WIDTH-1:0] curr_inst;
    wire [WIDTH-1:0] inst_out_command;
    wire [WIDTH-1:0] out_reg0;
    wire [WIDTH-1:0] out_reg1;
    wire [WIDTH-1:0] out_reg2;
    wire [WIDTH-1:0] out_reg3;
    wire [WIDTH-1:0] out_mem0;
    wire [WIDTH-1:0] out_mem1;
    wire [WIDTH-1:0] out_mem2;
    wire [WIDTH-1:0] out_mem3;
    wire [WIDTH-1:0] out_from_adder_puls_one;
    wire [WIDTH-1:0] out_from_adder_puls_IMM;
    wire [WIDTH-1:0] expand_IMM;
    // for data_path and control_path
    reg [0:0] clk, rst;
    wire is_write_reg, is_write_mem, is_load_PC;
    wire [0:0] is_R_type, is_I_type, is_J_type, is_write_from_mem;
    wire [1:0] control_mux_for_PC;
    wire [5:0] opcode_alu, opcode, funct;

    data_path_cpu _data_path_cpu(
        // input
        .clk(clk), 
        .rst(rst),
        .is_load_PC(is_load_PC), 
        .is_write_reg(is_write_reg), 
        .is_write_mem(is_write_mem), 
        .opcode_alu(opcode_alu),
        .is_R_type(is_R_type), 
        .is_I_type(is_I_type),
        .is_J_type(is_J_type),
        .control_mux_for_PC(control_mux_for_PC),
        .is_write_from_mem(is_write_from_mem),
        // output
        .opcode(opcode),
        .funct(funct),
        .out_alu(out_alu), 
        // added_for_debug
        .curr_inst(curr_inst),
        .inst_out_command(inst_out_command),
        .rdata1(rdata1), 
        .rdata2(rdata2), 
        .out_memory(out_memory),
        .out_reg0(out_reg0), 
        .out_reg1(out_reg1),
        .out_reg2(out_reg2), 
        .out_reg3(out_reg3),
        .out_mem0(out_mem0), 
        .out_mem1(out_mem1),
        .out_mem2(out_mem2), 
        .out_mem3(out_mem3),
        .out_from_adder_puls_one(out_from_adder_puls_one),
        .out_from_adder_puls_IMM(out_from_adder_puls_IMM),
        .expand_IMM(expand_IMM)
    );

    control_path_cpu _control_path_cpu(
        // input
        .clk(clk), 
        .rst(rst),
        .opcode(opcode), 
        .funct(funct),
        .out_alu(out_alu),
        // output
        .is_R_type(is_R_type), 
        .is_I_type(is_I_type),
        .is_J_type(is_J_type),
        .is_write_from_mem(is_write_from_mem),
        .is_write_reg(is_write_reg), 
        .is_write_mem(is_write_mem), 
        .is_load_PC(is_load_PC), 
        .control_mux_for_PC(control_mux_for_PC),
        .opcode_alu(opcode_alu)
    );

    always begin
        #5 clk =~ clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $display("time,  clk,  curr_inst,  rdata1, rdata2, out_alu, out_reg0, out_reg1, out_reg2, out_reg3, out_mem0, out_mem1");
        $monitor(" %1d     %1d        %1d        %1d        %1d         %1d        %1d        %1d        %1d        %1d        %1d        %1d",
                 $time, clk, curr_inst, rdata1, rdata2, out_alu, out_reg0, out_reg1, out_reg2, out_reg3, out_mem0, out_mem1);
        clk = 1;
        rst = 1;
        #5
        rst = 0;
        #210
        $finish;
    end

endmodule
