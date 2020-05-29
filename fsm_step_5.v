module fsm_step_5(// input 
       clk, rst,
       opcode_step_5,
       // output
       control_mux_for_write_back);

    input clk;
    input rst;
    input [5:0] opcode_step_5;
    output reg control_mux_for_write_back;

always @(*) begin
    // lw
    if (opcode_step_5 == 6'b100011) begin
        control_mux_for_write_back = 1'b1;
    end
    else begin
        control_mux_for_write_back = 1'b0;
    end
end

endmodule