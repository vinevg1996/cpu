module branch(// input 
    clk, rst,
    opcode_step_4, is_alu_zero_step_4,
    // output
    is_branch_fault);

    input clk, rst;
    input [5:0] opcode_step_4;
    input is_alu_zero_step_4;
    output is_branch_fault;

// beq = 6'b000100
// j-command = 6'b000010

assign is_branch_fault = (opcode_step_4 == 6'b000100) && (is_alu_zero_step_4);

endmodule