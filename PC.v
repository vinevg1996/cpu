module PC(load, in, clk, rst, out);
    parameter integer WIDTH = 32;
    input [WIDTH-1:0] in;
    input load, clk, rst;
    output reg [WIDTH-1:0] out;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
        end
        else if (load) begin
            out <= in;
        end
    end

endmodule