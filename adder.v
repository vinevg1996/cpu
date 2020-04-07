module adder (clk, rst, load, x, y, out);
    parameter integer WIDTH = 32;
    input clk, rst, load;
    input [WIDTH-1:0] x, y;
    //output reg [WIDTH-1:0] out;
    output [WIDTH-1:0] out;

    assign out = x + y;

endmodule
