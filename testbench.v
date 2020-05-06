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
        $dumpvars(1, testbench);

$display("time,  clk, pc_out, reg1, reg2, reg3,  mem0,   mem1,   opcode2,   opcode3,   opcode4,  opcode5");
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

        // simulation
        clk = 1;
        rst = 1;
        #5
        rst = 0;
        //#100
        #150
        $finish;
    end

endmodule