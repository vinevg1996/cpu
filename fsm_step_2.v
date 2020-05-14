module fsm_step_2(// input 
    clk, rst,
    opcode_step_2, opcode_step_3, opcode_step_4, opcode_step_5,
    rs, rt, out_rt_rd_mux_step_3, out_rt_rd_mux_step_4,
    // output
    is_write_reg, control_mux_for_rt_rd, 
    control_mux_for_wnum, 
    is_send_from_alu_rs, is_send_from_alu_rt,
    is_send_from_mem_rs, is_send_from_mem_rt);

    input clk;
    input rst;
    input [5:0] opcode_step_2;
    input [5:0] opcode_step_3;
    input [5:0] opcode_step_4;
    input [5:0] opcode_step_5;
    input [4:0] rs;
    input [4:0] rt;
    input [4:0] out_rt_rd_mux_step_3;
    input [4:0] out_rt_rd_mux_step_4;
    output reg is_write_reg;
    output reg control_mux_for_rt_rd;
    output reg control_mux_for_wnum;
    output is_send_from_alu_rs;
    output is_send_from_alu_rt;
    output is_send_from_mem_rs;
    output is_send_from_mem_rt;

assign is_send_from_alu_rs = ((opcode_step_3 == 6'b001000) || (opcode_step_3 == 6'b000000)) && 
                             (rs == out_rt_rd_mux_step_3);

assign is_send_from_alu_rt = ((opcode_step_3 == 6'b001000) || (opcode_step_3 == 6'b000000)) && 
                             (rt == out_rt_rd_mux_step_3);

assign is_send_from_mem_rs = (opcode_step_4 == 6'b100011) && 
                             (rs == out_rt_rd_mux_step_4);

assign is_send_from_mem_rt = (opcode_step_4 == 6'b100011) && 
                             (rt == out_rt_rd_mux_step_4);

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