module register_file (
    input wire clk,
    input wire reset,
    input wire [1:0] read_addr1,
    input wire [1:0] read_addr2,
    input wire [1:0] write_addr,
    input wire [3:0] write_data,
    input wire reg_write,
    output wire [3:0] read_data1,
    output wire [3:0] read_data2
);

reg [3:0] regs [0:3];
integer i;

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 4; i = i + 1)
            regs[i] <= 4'b0000;
    end
    else if (reg_write) begin
        regs[write_addr] <= write_data;
    end
end

assign read_data1 = regs[read_addr1];
assign read_data2 = regs[read_addr2];

endmodule
