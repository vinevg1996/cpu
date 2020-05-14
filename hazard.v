module hazard(// input 
    clk, rst,
    opcode_step_2, rs, rt,
    opcode_step_3, out_rt_rd_mux_step_3, 
    opcode_step_4, out_rt_rd_mux_step_4, 
    opcode_step_5, out_rt_rd_mux_step_5,
    // output
    is_hazard);

    input clk;
    input rst;
    input [4:0] rs, rt;
    input [5:0] opcode_step_2, opcode_step_3, opcode_step_4, opcode_step_5;
    input [4:0] out_rt_rd_mux_step_3, out_rt_rd_mux_step_4, out_rt_rd_mux_step_5;
    output is_hazard;

wire is_write_step_3;
wire is_write_step_4;
wire is_write_step_5;
wire is_read_step_2_and_write_step_3;
wire is_read_step_2_and_write_step_4;
wire is_read_step_2_and_write_step_5;

// addi, lw, add
assign is_write_step_3 = ((opcode_step_3 == 6'b001000) || (opcode_step_3 == 6'b100011) || (opcode_step_3 == 6'b000000));
// addi, lw, add
assign is_write_step_4 = ((opcode_step_4 == 6'b001000) || (opcode_step_4 == 6'b100011) || (opcode_step_4 == 6'b000000));
// addi, lw, add
assign is_write_step_5 = ((opcode_step_5 == 6'b001000) || (opcode_step_5 == 6'b100011) || (opcode_step_5 == 6'b000000));
assign is_read_step_2_and_write_step_3 = ((rs == out_rt_rd_mux_step_3) || (rt == out_rt_rd_mux_step_3));
assign is_read_step_2_and_write_step_4 = ((rs == out_rt_rd_mux_step_4) || (rt == out_rt_rd_mux_step_4));
assign is_read_step_2_and_write_step_5 = ((rs == out_rt_rd_mux_step_5) || (rt == out_rt_rd_mux_step_5));

// opcode_step_2 is not j-command
/*
assign is_hazard = ((opcode_step_2 != 6'b000010) && 
                    (
                        ( 
                            is_write_step_3 && is_read_step_2_and_write_step_3
                        ) ||
                        ( 
                            is_write_step_4 && is_read_step_2_and_write_step_4
                        ) || 
                        ( 
                            is_write_step_5 && is_read_step_2_and_write_step_5
                        )
                    )
                    );
*/
/*
assign is_hazard = ((opcode_step_2 != 6'b000010) && 
                    (
                        ( 
                            ((opcode_step_3 == 6'b001000) && is_read_step_2_and_write_step_3) ||
                            ((opcode_step_3 == 6'b100011) && is_read_step_2_and_write_step_3) ||
                            ((opcode_step_3 == 6'b000000) && is_read_step_2_and_write_step_3)
                        ) ||
                        ( 
                            is_write_step_4 && is_read_step_2_and_write_step_4
                        ) || 
                        ( 
                            is_write_step_5 && is_read_step_2_and_write_step_5
                        )
                    )
                    );
*/

//opcode_step_3 == lw

assign is_hazard = ((opcode_step_2 != 6'b000010) && 
                    (
                        ( 
                            ((opcode_step_3 == 6'b100011) && is_read_step_2_and_write_step_3)
                        ) ||
                        ( 
                            (((opcode_step_4 == 6'b001000) || (opcode_step_4 == 6'b000000)) && 
                                is_read_step_2_and_write_step_4)
                        ) || 
                        ( 
                            is_write_step_5 && is_read_step_2_and_write_step_5
                        )
                    )
                    );

endmodule