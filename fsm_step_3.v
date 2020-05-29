module fsm_step_3(// input 
                  clk, rst,
                  opcode_step_3,
                  // output
                  control_mux_for_alu, alu_op);
    input clk;
    input rst;
    input [5:0] opcode_step_3;
    output reg control_mux_for_alu;
    output reg [5:0] alu_op;


always @(*) begin
    case(opcode_step_3)
        // beq
        6'b000100: begin
            //control_mux_for_alu = 1'b1;
            control_mux_for_alu = 1'b0;
            alu_op = 6'b100010;
        end
        // j-command
        6'b000010: begin
            control_mux_for_alu = 1'b0;
            alu_op = 6'b000000;
        end
        // add
        6'b000000: begin
            control_mux_for_alu = 1'b0;
            alu_op = 6'b100000;
        end
        // addi
        6'b001000: begin
            control_mux_for_alu = 1'b1;
            alu_op = 6'b100000;
        end
        // lw
        6'b100011: begin
            control_mux_for_alu = 1'b1;
            alu_op = 6'b100000;
        end
        // sw
        6'b101011: begin
            control_mux_for_alu = 1'b1;
            alu_op = 6'b100000;
        end
        default: begin
            control_mux_for_alu = 1'b0;
            alu_op = 6'b000000;
        end
    endcase
end

endmodule