module instructions(rst, curr_command, out_data);
    parameter integer WIDTH = 32;
    parameter integer INSTRACTION_NUMBERS = 1;
    input rst;
    input [WIDTH-1: 0] curr_command;
    output [WIDTH-1:0] out_data;

reg [WIDTH-1:0] mem [0:INSTRACTION_NUMBERS-1];

initial begin
    $readmemb("mem_content.list", mem); // Raw binary format
end

assign out_data = mem[curr_command];

endmodule
