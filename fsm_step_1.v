module fsm_step_1(// input 
    clk, rst,
    is_alu_zero_step_4, opcode_step_4,
    // output
    control_mux_for_PC);

    input clk;
    input rst;
    input is_alu_zero_step_4;
    input [5:0] opcode_step_4;
    //output reg is_load_PC;
    output reg [1:0] control_mux_for_PC;

always @(*) begin
    case(opcode_step_4)
        // beq
        6'b000100: begin
            if (is_alu_zero_step_4 == 1'b1) begin
                control_mux_for_PC = 2'b01;
            end
            else begin
                control_mux_for_PC = 2'b00;
            end
        end
        // j-command
        6'b000010: begin
            control_mux_for_PC = 2'b10;
        end
        // add, sub
        6'b000000: begin
            control_mux_for_PC = 2'b00;
        end
        // addi
        6'b001000: begin
            control_mux_for_PC = 2'b00;
        end
        // lw
        6'b100011: begin
            control_mux_for_PC = 2'b00;
        end
        // sw
        6'b101011: begin
            control_mux_for_PC = 2'b00;
        end
        default: begin
            control_mux_for_PC = 2'b00;
        end
    endcase
end

endmodule