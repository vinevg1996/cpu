module cpu(clk, rst);
    parameter integer WIDTH = 32;
    localparam ADDR_WIDTH = $clog2(WIDTH);
    input clk, rst;

    wire is_write_reg, is_write_mem;
    wire is_R_type, is_I_type, is_J_type, is_write_from_mem;
    wire [1:0] control_mux_for_PC;
    wire [5:0] opcode_alu, opcode, funct;
    wire is_alu_zero;

    data_path_cpu _data_path_cpu(
        // inputs
        .clk(clk), 
        .rst(rst),
        .is_write_reg(is_write_reg), 
        .is_write_mem(is_write_mem), 
        .opcode_alu(opcode_alu),
        .is_R_type(is_R_type), 
        .is_I_type(is_I_type),
        .is_J_type(is_J_type),
        .control_mux_for_PC(control_mux_for_PC),
        .is_write_from_mem(is_write_from_mem),
        // outputs
        .opcode(opcode),
        .funct(funct),
        .EX_MEM_is_alu_zero(is_alu_zero)
    );

    control_path_cpu _control_path_cpu(
        // inputs
        .clk(clk), 
        .rst(rst),
        .opcode(opcode), 
        .funct(funct),
        .is_alu_zero(is_alu_zero),
        // outputs
        .is_R_type(is_R_type), 
        .is_I_type(is_I_type),
        .is_J_type(is_J_type),
        .is_write_from_mem(is_write_from_mem),
        .is_write_reg(is_write_reg), 
        .is_write_mem(is_write_mem), 
        .control_mux_for_PC(control_mux_for_PC),
        .opcode_alu(opcode_alu)
    );

endmodule
