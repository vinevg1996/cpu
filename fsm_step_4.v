module fsm_step_4(// input 
    clk, rst,
    opcode_step_4,
    // output
    is_write_mem);

    input clk;
    input rst;
    input [5:0] opcode_step_4;
    output reg is_write_mem;

always @(*) begin
    if (opcode_step_4 == 6'b101011) begin
        is_write_mem = 1'b1;
    end
    else begin
        is_write_mem = 1'b0;
    end
end

endmodule