module adder (clk, rst, x, y, out);
    parameter integer WIDTH = 32;
    parameter integer WAIT_CONST = 0;
    input clk, rst;
    input [WIDTH-1:0] x, y;
    output reg [WIDTH-1:0] out;

reg [1:0] wait_execute_command;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        out <= 0; 
        wait_execute_command <= 0;
    end
    else begin
        if (wait_execute_command == WAIT_CONST) begin
            out <= x + y; 
            wait_execute_command <= 0;
        end
        else begin
            wait_execute_command <= wait_execute_command + 1;
        end
    end
end
/*
initial begin
    wait_execute_command = 0;
end
*/
endmodule

/*
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
*/