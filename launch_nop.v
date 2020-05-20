module launch_nop(// input
        is_hazard, pc_out,
        is_hit, is_branch_fault,
        // output
        is_load_PC, is_load_for_launch_1_2,
        is_load_for_launch_2_3, is_load_for_launch_3_4,
        is_load_for_launch_4_5,
        nop_step_2, nop_step_3, nop_step_4);
    parameter integer WIDTH = 32;
    parameter integer INSTRACTION_NUMBERS = 16;

    input is_hazard;
    input [WIDTH-1:0] pc_out;
    input is_hit;
    input is_branch_fault;
    output reg is_load_PC, is_load_for_launch_1_2;
    output reg is_load_for_launch_2_3, is_load_for_launch_3_4;
    output reg is_load_for_launch_4_5;
    output reg nop_step_2, nop_step_3, nop_step_4;

always @(*) begin
    if (is_hazard) begin
        is_load_PC = 1'b0;
        is_load_for_launch_1_2 = 1'b0;
        is_load_for_launch_2_3 = 1'b1;
        is_load_for_launch_3_4 = 1'b1;
        is_load_for_launch_4_5 = 1'b1;
        nop_step_3 = 1'b1;
        nop_step_2 = 1'b0;
        nop_step_4 = 1'b0;
    end
    else if(is_branch_fault) begin
        nop_step_2 = 1'b1;
        nop_step_3 = 1'b1;
        nop_step_4 = 1'b1;
    end
    else if (!is_hit) begin
        is_load_PC = 1'b0;
        is_load_for_launch_1_2 = 1'b0;
        is_load_for_launch_2_3 = 1'b0;
        is_load_for_launch_3_4 = 1'b0;
        is_load_for_launch_4_5 = 1'b0;
    end
    else begin
        if (pc_out < INSTRACTION_NUMBERS) begin
            is_load_PC = 1'b1;
        end
        else begin
            is_load_PC = 1'b0;
        end
        is_load_for_launch_1_2 = 1'b1;
        is_load_for_launch_2_3 = 1'b1;
        is_load_for_launch_3_4 = 1'b1;
        is_load_for_launch_4_5 = 1'b1;
        nop_step_2 = 1'b0;
        nop_step_3 = 1'b0;
        nop_step_4 = 1'b0;
    end
end

endmodule