`timescale 1 ns / 100 ps
// testbench is a module which only task is to test another module
// testbench is for simulation only, not for synthesis

module testbench;
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
        $dumpvars(0, testbench);
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
        $display("time,  clk, curr_inst, out_reg1, out_reg2, out_reg3, mem0, mem1");
        $monitor(" %1d     %1d        %1d        %1d        %1d         %1d        %1d      %1d      ",
                 $time, clk, 
                 _cpu._data_path_cpu.curr_inst,
                 _cpu._data_path_cpu._regs.out_reg1,
                 _cpu._data_path_cpu._regs.out_reg2,
                 _cpu._data_path_cpu._regs.out_reg3,
                 _cpu._data_path_cpu._memory.out_reg0,
                 _cpu._data_path_cpu._memory.out_reg1
                 );
        // simulation
        clk = 1;
        rst = 1;
        #5
        rst = 0;
        #140
        $finish;
    end

endmodule