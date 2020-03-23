module PC(load, in, clk, rst, out);
    parameter integer WIDTH = 32;
    parameter integer WAIT_CONST = 1;
    input [WIDTH-1:0] in;
    input load, clk, rst;
    output reg [WIDTH-1:0] out;
/*
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
        end
        else if (load) begin
            out <= in;
        end
    end
*/
    reg [1:0] wait_execute_command;
    
    always @(posedge clk, posedge rst) begin
    if (rst) begin
        out <= 0; 
        wait_execute_command <= 0;
    end
    else begin
        if (wait_execute_command == WAIT_CONST) begin
            out <= in;
            wait_execute_command <= 0;
        end
        else begin
            wait_execute_command <= wait_execute_command + 1;
        end
    end
    end

/*
    always @(posedge clk) begin
        if (load) begin
            out <= in;
        end
    end
*/
endmodule