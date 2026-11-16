module cpu_tb;

reg clk;
reg reset;

wire [3:0] pc_out;
wire [11:0] instruction_out;
wire [3:0] alu_out;

cpu_top dut (
    .clk(clk),
    .reset(reset),
    .pc_out(pc_out),
    .instruction_out(instruction_out),
    .alu_out(alu_out)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1'b1;
    #12 reset = 1'b0;

    #40;

    $display("R1 = %b", dut.rf_unit.regs[1]);
    $display("R2 = %b", dut.rf_unit.regs[2]);
    $display("R3 = %b", dut.rf_unit.regs[3]);
    $display("Memory[4] = %b", dut.dmem_unit.memory[4]);

    $stop;
end

endmodule