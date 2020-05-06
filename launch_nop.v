module launch_nop(// input
        is_hazzard, is_branch, nop_step_5, pc_out,
        is_branch_step_4,
        // output
        is_load_PC, is_load_for_launch_1_2,
        nop_step_3, nop_step_2);
    parameter integer WIDTH = 32;
    parameter integer INSTRACTION_NUMBERS = 16;

    input is_hazzard, is_branch;
    input nop_step_5;
    input [WIDTH-1:0] pc_out;
    input is_branch_step_4;
    output reg is_load_PC, is_load_for_launch_1_2, nop_step_3, nop_step_2;

always @(*) begin
    if (is_hazzard) begin
        is_load_PC = 1'b0;
        is_load_for_launch_1_2 = 1'b0;
        nop_step_3 = 1'b1;
        nop_step_2 = 1'b0;
    end
    else begin
        if (is_branch) begin
            if (is_branch_step_4) begin
                is_load_PC = 1'b1;
            end
            else begin
                is_load_PC = 1'b0;
            end
            is_load_for_launch_1_2 = 1'b0;
            nop_step_2 = 1'b1;
            nop_step_3 = 1'b0;
        end
        else begin        
            if (pc_out < INSTRACTION_NUMBERS) begin
                is_load_PC = 1'b1;
            end
            else begin
                is_load_PC = 1'b0;
            end
            is_load_for_launch_1_2 = 1'b1;
            nop_step_2 = 1'b0;
            nop_step_3 = 1'b0;
        end
    end
end

endmodule