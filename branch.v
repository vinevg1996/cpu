module branch(// input 
    clk, rst,
    opcode_step_2, opcode_step_3, opcode_step_4,
    // output
    is_branch, is_branch_step_2, is_branch_step_3, is_branch_step_4);

    input clk, rst;
    input [5:0] opcode_step_2, opcode_step_3, opcode_step_4;
    output is_branch;
    output is_branch_step_2;
    output is_branch_step_3;
    output is_branch_step_4;

// beq = 6'b000100
// j-command = 6'b000010
assign is_branch_step_2 = (opcode_step_2 == 6'b000100) || (opcode_step_2 == 6'b000010);
assign is_branch_step_3 = (opcode_step_3 == 6'b000100) || (opcode_step_3 == 6'b000010);
assign is_branch_step_4 = (opcode_step_4 == 6'b000100) || (opcode_step_4 == 6'b000010);

assign is_branch = is_branch_step_2 || is_branch_step_3 || is_branch_step_4;
//                    (opcode_step_4 == 6'b000100) || (opcode_step_4 == 6'b000010));


endmodule