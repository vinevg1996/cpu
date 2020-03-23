// Новые точки объявлять перед экземплярами под соответствующим комментарием. Комментарий не стирать.
// Назначать новые порты в экземплярах - в конце всех назначений под соответствующим комментарием. Комментарий не стирать.
// НЕ ЗАБУДЬТЕ поставить запятую после ".rst(rst)", если добавляете новые порты.
module alu(clk, rst, in1, in2, opcode, zero, out);
    parameter integer WIDTH = 32;
    input clk, rst;
    input [WIDTH-1:0] in1;
    input [WIDTH-1:0] in2;
    input [5:0] opcode;
    //output reg zero;
    output zero;
    output reg [WIDTH-1:0] out;

    always @(in1, in2, opcode) begin
        case(opcode)
            6'b100000: out = in1 + in2;
            6'b100010: out = in1 - in2;
            default: out = 0;
        endcase
    end
    assign zero = (out == 0);

endmodule
