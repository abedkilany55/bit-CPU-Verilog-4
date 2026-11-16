
module instruction_memory (
    input wire [3:0] address,
    output wire [11:0] instruction
);

reg [11:0] rom [0:15];
integer i;

initial begin
    for (i = 0; i < 16; i = i + 1)
        rom[i] = 12'b1111_0000_0000;

    rom[0] = 12'b0100_01_0101_00;
    rom[1] = 12'b0100_10_0011_00;
    rom[2] = 12'b0000_11_01_10_00;
    rom[3] = 12'b0011_11_0100_00;
end

assign instruction = rom[address];

endmodule