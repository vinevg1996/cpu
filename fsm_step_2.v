module fsm_step_2(// input 
    clk, rst,
    opcode_step_2, opcode_step_5,
    // output
    is_write_reg, control_mux_for_rt_rd, 
    control_mux_for_wnum, is_hazzard);

    input clk;
    input rst;
    input [5:0] opcode_step_2;
    input [5:0] opcode_step_5;
    input is_hazzard;
    output reg is_write_reg;
    output reg control_mux_for_rt_rd;
    output reg control_mux_for_wnum;

always @(*) begin
    // addi, lw, add, sub
    if ((opcode_step_5 == 6'b001000) ||
        (opcode_step_5 == 6'b100011) ||
        (opcode_step_5 == 6'b000000)) begin
            is_write_reg = 1'b1;
            control_mux_for_wnum = 1'b1;
    end
    else begin
            is_write_reg = 1'b0;
            control_mux_for_wnum = 1'b0;
    end
    case(opcode_step_2)
        // add, sub
        6'b000000: begin
            control_mux_for_rt_rd = 1'b0;
        end
        // addi
        6'b001000: begin
            control_mux_for_rt_rd = 1'b1;
        end
        // beq
        6'b000100: begin
            control_mux_for_rt_rd = 1'b1;
        end
        // lw
        6'b100011: begin
            control_mux_for_rt_rd = 1'b1;
        end
        // sw
        6'b101011: begin
            control_mux_for_rt_rd = 1'b1;
        end
        default: begin
            control_mux_for_rt_rd = 1'b0;
        end
    endcase

end

endmodule