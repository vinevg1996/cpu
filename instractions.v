module instractions(load, clk, rst, curr_command, out_data);
    parameter integer WIDTH = 32;
    parameter integer INSTRACTION_NUMBERS = 1;
    input load;
    input clk;
    input rst;
    input [WIDTH-1: 0] curr_command;
    output [WIDTH-1:0] out_data;

reg [WIDTH-1:0] mem [0:INSTRACTION_NUMBERS-1];

initial begin
    //$readmemb("mem_content.list", mem); // Raw binary format
    $readmemb("mem_content_lw_command.list", mem); // Raw binary format
end

assign out_data = mem[curr_command];

endmodule
