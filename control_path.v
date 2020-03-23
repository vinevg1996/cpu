// Новые точки объявлять перед экземплярами под соответствующим комментарием. Комментарий не стирать.
// Назначать новые порты в экземплярах - в конце всех назначений под соответствующим комментарием. Комментарий не стирать.
// НЕ ЗАБУДЬТЕ поставить запятую после ".rst(rst)", если добавляете новые порты.
module control_path_cpu(clk, rst, opcode, funct, out_alu,
                        is_R_type, is_I_type, is_J_type,
                        is_write_from_mem, is_write_reg,
                        is_write_mem, is_load_PC, 
                        control_mux_for_PC, opcode_alu);
    parameter integer WIDTH = 32;
    parameter integer wait_const = 1;
    input clk, rst;
    input [5:0] opcode;
    input [5:0] funct;
    input [WIDTH-1:0] out_alu;
    output reg is_R_type, is_I_type, is_J_type, is_write_from_mem;
    output reg is_write_reg, is_write_mem, is_load_PC;
    output reg [1:0] control_mux_for_PC;
    output reg [5:0] opcode_alu;

    always @(clk, opcode, funct, rst, out_alu) begin
        case(opcode)
            // add, sub
            6'b000000: begin
                is_R_type = 1'b1;
                is_I_type = 1'b0;
                is_J_type = 1'b0;
                is_write_from_mem = 1'b0;
                is_write_mem = 1'b0;
                is_write_reg = 1'b1;
                is_load_PC = 1'b1;
                case(funct)
                    6'b100000: begin
                        opcode_alu = 6'b100000;
                    end
                    6'b100010: begin
                        opcode_alu = 6'b100010;
                    end
                    default: begin
                        opcode_alu = 6'b000000;
                    end
                endcase
                control_mux_for_PC = 2'b00;
            end
            // addi
            6'b001000: begin
                is_R_type = 1'b0;
                is_I_type = 1'b1;
                is_J_type = 1'b0;
                is_write_from_mem = 1'b0;
                is_write_mem = 1'b0;
                is_write_reg = 1'b1;
                is_load_PC = 1'b1;
                opcode_alu = 6'b100000;
                control_mux_for_PC = 2'b00;
            end
            // lw
            6'b100011: begin
                is_R_type = 1'b0;
                is_I_type = 1'b1;
                is_J_type = 1'b0;
                is_write_from_mem = 1'b1;
                is_write_mem = 1'b0;
                is_write_reg = 1'b1;
                is_load_PC = 1'b1;
                opcode_alu = 6'b100000;
                control_mux_for_PC = 2'b00;
            end
            // sw
            6'b101011: begin
                is_R_type = 1'b0;
                is_I_type = 1'b1;
                is_J_type = 1'b0;
                is_write_from_mem = 1'b0;
                is_write_mem = 1'b1;
                is_write_reg = 1'b0;
                is_load_PC = 1'b1;
                opcode_alu = 6'b100000;
                control_mux_for_PC = 2'b00;
            end
            // beq
            6'b000100: begin
                is_R_type = 1'b0;
                is_I_type = 1'b1;
                is_J_type = 1'b0;
                is_write_from_mem = 1'b0;
                is_write_mem = 1'b0;
                is_write_reg = 1'b0;
                is_load_PC = 1'b1;
                opcode_alu = 6'b000000;
                if (out_alu == 0) begin
                    control_mux_for_PC = 2'b01;
                end
                else begin
                   control_mux_for_PC = 2'b00;
                end

            end
            // j-command
            6'b000010: begin
                is_R_type = 1'b0;
                is_I_type = 1'b0;
                is_J_type = 1'b1;
                is_write_from_mem = 1'b0;
                is_write_mem = 1'b0;
                is_write_reg = 1'b0;
                is_load_PC = 1'b1;
                opcode_alu = 6'b000000;
                control_mux_for_PC = 2'b10;
            end
            default: begin
                is_load_PC = 1'b0;
                control_mux_for_PC = 2'b00;
            end
        endcase
    end

endmodule
