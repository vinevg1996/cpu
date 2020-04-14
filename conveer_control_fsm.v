module conveer_control_fsm(// inputs
                       clk, rst, curr_inst,
                       // outputs
                       is_IFID_open,
                       is_IDEX_open,
                       is_EXMEM_open,
                       is_MEMWB_open,
                       is_load_PC,
                       curr_state
                       );
    parameter integer WIDTH = 32;
    parameter integer INSTRACTION_NUMBERS = 16;
    input clk, rst;
    input [WIDTH-1:0] curr_inst;
    output reg is_IFID_open, is_IDEX_open, is_EXMEM_open, is_MEMWB_open;
    output reg is_load_PC;
    output reg [2:0] curr_state;

    parameter IF_ID   = 0,
              ID_EX   = 1,
              EX_MEM  = 2,
              MEM_WB  = 3,
              WRITE_STATE = 4,
              LOAD_PC = 5;
    
    reg [2:0] next_state, prev_state;

    always @(curr_state) begin
        case(curr_state)
            IF_ID: begin
                is_IFID_open <= 1'b1;
                is_IDEX_open <= 1'b0;
                is_EXMEM_open <= 1'b0;
                is_MEMWB_open <= 1'b0;
                is_load_PC <= 1'b0;

                next_state <= ID_EX;
            end

            ID_EX: begin
                is_IFID_open <= 1'b0;
                is_IDEX_open <= 1'b1;
                is_EXMEM_open <= 1'b0;
                is_MEMWB_open <= 1'b0;
                is_load_PC <= 1'b0;

                next_state <= EX_MEM;
            end

            EX_MEM: begin
                is_IFID_open <= 1'b0;
                is_IDEX_open <= 1'b0;
                is_EXMEM_open <= 1'b1;
                is_MEMWB_open <= 1'b0;
                is_load_PC <= 1'b0;

                next_state <= MEM_WB;
            end

            MEM_WB: begin
                is_IFID_open <= 1'b0;
                is_IDEX_open <= 1'b0;
                is_EXMEM_open <= 1'b0;
                is_MEMWB_open <= 1'b1;
                is_load_PC <= 1'b0;

                next_state <= WRITE_STATE;
            end

            WRITE_STATE: begin
                is_IFID_open <= 1'b0;
                is_IDEX_open <= 1'b0;
                is_EXMEM_open <= 1'b0;
                is_MEMWB_open <= 1'b0;
                is_load_PC <= 1'b0;

                next_state <= LOAD_PC;
            end

            LOAD_PC: begin
                is_IFID_open <= 1'b0;
                is_IDEX_open <= 1'b0;
                is_EXMEM_open <= 1'b0;
                is_MEMWB_open <= 1'b0;
                if (curr_inst  < INSTRACTION_NUMBERS) begin
                    is_load_PC <= 1'b1;
                end
                else begin
                    is_load_PC <= 1'b0;
                end

                next_state <= IF_ID;
            end

            default: begin
                is_load_PC <= 1'b0;
            end
        endcase
    end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        curr_state <= IF_ID;
    end
    else begin
        curr_state <= next_state;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        prev_state <= IF_ID;
    end
    else begin
        prev_state <= curr_state;
    end
end

endmodule