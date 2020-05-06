module reset_register(load, in, clk, rst, nop_rst, out);
    parameter integer WIDTH = 32;
    input [WIDTH-1:0] in;
    input load, clk, rst, nop_rst;
    output reg [WIDTH-1:0] out;
/*
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            //out <= 0;
            out <= nop_value;
        end
        else begin
            if (nop_rst) begin
                out <= nop_value;
            end
            else if (load) begin
                out <= in;
            end
        end
    end
*/

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            //out <= 0; 
            out <= {WIDTH{1'b1}};
        end
        else begin
            if (nop_rst) begin
                out <= {WIDTH{1'b1}};
            end
            else if (load) begin
                out <= in;
            end
        end
    end
endmodule