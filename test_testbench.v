`timescale 1 ns / 100 ps
// testbench is a module which only task is to test another module
// testbench is for simulation only, not for synthesis

module test_testbench;
    parameter integer WIDTH = 32;
    reg clk, rst;

    cpu _cpu(
        .clk(clk),
        .rst(rst)
    );

    always begin
        #5 clk =~ clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, testbench);
        /*
        $display("time,  clk, curr_inst, out_reg1, out_reg2, out_reg3, mem0, mem1, is_nop, prev, rnum1, rnum2, curr_wnum");
        $monitor(" %1d     %1d        %1d        %1d        %1d         %1d        %1d      %1d      %1d       %1d       %1d       %1d       %1d       ",
                 $time, clk, 
                 _cpu._data_path_cpu.curr_inst,
                 _cpu._data_path_cpu._regs._reg1.out,
                 _cpu._data_path_cpu._regs._reg2.out,
                 _cpu._data_path_cpu._regs._reg3.out,
                 _cpu._data_path_cpu._memory._reg0.out,
                 _cpu._data_path_cpu._memory._reg1.out,
                 _cpu._control_path_cpu.is_nop,
                 _cpu._control_path_cpu.is_previous_nop,
                 _cpu._data_path_cpu._regs_hazzard.rnum1, 
                 _cpu._data_path_cpu._regs_hazzard.rnum2,
                 _cpu._data_path_cpu._regs_hazzard.curr_wnum,
                 );
        */
        /*
        $display("time,  clk, curr_inst, out_reg1, out_reg2, out_reg3, mem0, mem1, state, IMM, ID_EX_IMM");
        $monitor(" %1d     %1d        %1d        %1d        %1d         %1d         %1d       %1d      %1d      %1d",
                 $time, clk, 
                 _cpu._data_path_cpu.curr_inst,
                 _cpu._data_path_cpu._regs.out_reg1,
                 _cpu._data_path_cpu._regs.out_reg2,
                 _cpu._data_path_cpu._regs.out_reg3,
                 _cpu._data_path_cpu._memory.out_reg0,
                 _cpu._data_path_cpu._memory.out_reg1,
                 _cpu._data_path_cpu.curr_state,
                 _cpu._data_path_cpu.expand_IMM,
                 _cpu._data_path_cpu.ID_EX_expand_IMM
                 );
        */
        /*
        $display("time,  clk, rst, pc_out, reg1, reg2, reg3, rdata1_st2, rdata2_st2, out_rt_rd, wnum, control_wnum, op_2, op_3, op_4, op_5, wnum_step_5");
        $monitor(" %1d     %1d     %1d      %1d     %1d     %1d      %1d         %1d        %1d           %1d        %1d        %1d        %1d     %1d     %1d     %1d     %1d",
                 $time, clk, rst,
                 _cpu._cpu_step_1._PC.out,
                 _cpu._cpu_step_2._regs.out_reg1,
                 _cpu._cpu_step_2._regs.out_reg2,
                 _cpu._cpu_step_2._regs.out_reg3,
                 _cpu._cpu_step_2.rdata1_step_2, 
                 _cpu._cpu_step_2.rdata2_step_2,
                 _cpu._cpu_step_2.out_rt_rd_mux_step_2,
                 _cpu._cpu_step_2.wnum,
                 _cpu._cpu_step_2.control_mux_for_wnum,
                 _cpu.opcode_step_2,
                 _cpu.opcode_step_3,
                 _cpu.opcode_step_4,
                 _cpu.opcode_step_5,
                 _cpu._cpu_step_2.wnum_step_5
                 );
        */
        // execute_test
/*
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
*/
/*
        $display("time,  clk, opcode2, opcode3, rt_rd_3, pc_plus_1, is_alu_zero_3, out_alu, rdata2_3, alu_op, in1, in2, mux_alu, haz, load_1_2, nop_3, nop_5, opcode_5");
        $monitor("%1d     %1d      %1d      %1d         %1d          %1d            %1d          %1d         %1d        %1d      %1d      %1d      %1d      %1d      %1d      %1d      %1d      %1d      ",
                 $time, clk, 
                 _cpu.opcode_step_2,
                 _cpu.opcode_step_3,
                 _cpu.out_rt_rd_mux_step_3,
                 _cpu.pc_plus_one_step_3,
                 _cpu.is_alu_zero_step_3,
                 _cpu.out_alu_step_3,
                 _cpu.rdata2_step_3,
                 _cpu._cpu_step_3.alu_op,
                 _cpu._cpu_step_3._alu.in1,
                 _cpu._cpu_step_3._alu.in2,
                 _cpu._cpu_step_3.control_mux_for_alu,
                 _cpu.is_hazzard,
                 _cpu.is_load_for_launch_1_2,
                 _cpu.nop_step_3,
                 _cpu._launch_nop.nop_step_5,
                 _cpu.opcode_step_5
                 );
*/
// hazzard
/*
    $display("time, clk, haz,   rs,   rt, opcode2, opcode3, opcode4, opcode5, w_3, r_2_w_3, w_4, r_2_w_4, w_5, r_2_w_5, nop3");
    $monitor("%1d     %1d     %1d     %1d     %1d       %1d       %1d       %1d       %1d     %1d     %1d     %1d     %1d     %1d     %1d     %1d",
                 $time, clk, 
                 _cpu.is_hazzard,
                 _cpu._cpu_step_2.rs,
                 _cpu._cpu_step_2.rt,
                 _cpu._hazzard.opcode_step_2,
                 _cpu._hazzard.opcode_step_3,
                 _cpu._hazzard.opcode_step_4,
                 _cpu._hazzard.opcode_step_5,
                 _cpu._hazzard.is_write_step_3,
                 _cpu._hazzard.is_read_step_2_and_write_step_3,
                 _cpu._hazzard.is_write_step_4,
                 _cpu._hazzard.is_read_step_2_and_write_step_4,
                 _cpu._hazzard.is_write_step_4,
                 _cpu._hazzard.is_read_step_2_and_write_step_4,
                 _cpu.nop_step_3
                 );
*/

// memory_step_4
/*
        $display("time,  clk, opcode4, rt_rd_4, out_alu_4, out_mem4");
        $monitor("%1d     %1d      %1d      %1d         %1d          %1d",
                 $time, clk, 
                 _cpu.opcode_step_4,
                 _cpu.out_rt_rd_mux_step_4,
                 _cpu.out_alu_step_4,
                 _cpu.out_memory_step_4
                 );
*/
//out_alu_step_5
//out_mux_for_write_back_step_5
/*
        $display("time,  clk, reg1, reg2, reg3, opcode5, out_alu_5, haz");
        $monitor("%1d     %1d     %1d     %1d     %1d      %1d      %1d      %1d         %1d",
                 $time, clk, 
                 _cpu._cpu_step_2._regs.out_reg1,
                 _cpu._cpu_step_2._regs.out_reg2,
                 _cpu._cpu_step_2._regs.out_reg3,
                 _cpu.opcode_step_5,
                 _cpu.out_rt_rd_mux_step_5,
                 _cpu.out_alu_step_5,
                 _cpu.is_hazzard
                 );
*/

$display("time,  clk, pc_out, reg1, reg2, reg3, mem0,   mem1,   opcode2, opcode3, opcode4, opcode5");
$monitor("%1d     %1d      %1d      %1d      %1d      %1d      %1d      %1d         %1d         %1d         %1d         %1d",
         $time, clk, 
         _cpu._cpu_step_1.pc_out,
         _cpu._cpu_step_2._regs.out_reg1,
         _cpu._cpu_step_2._regs.out_reg2,
         _cpu._cpu_step_2._regs.out_reg3,
         _cpu._cpu_step_4._memory.out_reg0,
         _cpu._cpu_step_4._memory.out_reg1,
         _cpu.opcode_step_2,
         _cpu.opcode_step_3,
         _cpu.opcode_step_4,
         _cpu.opcode_step_5
         );

/*
$display("time,  clk, pc_out, haz, nop2, nop3, branch,  opcode2, opcode3, opcode4, PC_mux, alu3, alu4");
$monitor("%1d     %1d     %1d     %1d        %1d     %1d        %1d          %1d          %1d         %1d         %1d      %1d      %1d",
         $time, clk, 
         _cpu._cpu_step_1.pc_out,
         _cpu.is_hazzard,
         _cpu.nop_step_2,
         _cpu.nop_step_3,
         _cpu.is_branch,
         _cpu.opcode_step_2,
         _cpu.opcode_step_3,
         _cpu.opcode_step_4,
         _cpu._cpu_step_1.control_mux_for_PC,
         _cpu.out_alu_step_3,
         _cpu.out_alu_step_4,
         );
*/
        // simulation
        clk = 1;
        rst = 1;
        #5
        rst = 0;
        //#100
        #400
        $finish;
    end

endmodule