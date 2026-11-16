module data_memory (
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [3:0] address,
    input wire [3:0] write_data,
    output reg [3:0] read_data
);

reg [3:0] memory [0:15];

always @(posedge clk) begin
    if (mem_write)
        memory[address] <= write_data;
end

always @(*) begin
    if (mem_read)
        read_data = memory[address];
    else
        read_data = 4'b0000;
end

endmodule
