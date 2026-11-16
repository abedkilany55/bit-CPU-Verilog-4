module control_unit (
    input wire [3:0] opcode,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [2:0] alu_op,
    output reg [1:0] result_sel
);

always @(*) begin
    reg_write = 1'b0;
    mem_read  = 1'b0;
    mem_write = 1'b0;
    alu_op    = 3'b000;
    result_sel = 2'b00;

    case (opcode)
        4'b0000: begin // ADD
            reg_write = 1'b1;
            alu_op = 3'b000;
            result_sel = 2'b00;
        end

        4'b0001: begin // SUB
            reg_write = 1'b1;
            alu_op = 3'b001;
            result_sel = 2'b00;
        end

        4'b0010: begin // LOAD
            reg_write = 1'b1;
            mem_read = 1'b1;
            result_sel = 2'b01;
        end

        4'b0011: begin // STORE
            mem_write = 1'b1;
        end

        4'b0100: begin // MOVI
            reg_write = 1'b1;
            result_sel = 2'b10;
        end

        4'b1111: begin // NOP
        end

        default: begin
        end
    endcase
end

endmodule
