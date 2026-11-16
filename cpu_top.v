module cpu_top (
    input wire clk,
    input wire reset,
    output wire [3:0] pc_out,
    output wire [11:0] instruction_out,
    output wire [3:0] alu_out,
    output wire [3;0] gpio_out
);

wire [3:0] pc;
wire [11:0] instruction;

wire [3:0] opcode;
wire [1:0] rd;
wire [1:0] rs1;
wire [1:0] rs2;
wire [3:0] immediate;

wire [1:0] rf_read_addr1;
wire [3:0] read_data1;
wire [3:0] read_data2;

reg [3:0] write_back_data;

wire reg_write;
wire mem_read;
wire mem_write;
wire [2:0] alu_op;
wire [1:0] result_sel;

wire [3:0] alu_result;
wire [3:0] mem_read_data;
wire [3:0] ram_read_data;
wire [3:0] ram_address;
wire [3:0] ram_write_data;

wire [3:0] gpio_read_data;
wire [3:0] gpio_write_data;

wire ram_read;
wire ram_write;
wire gpio_write_enable;

assign pc_out = pc;
assign instruction_out = instruction;
assign alu_out = alu_result;

assign opcode    = instruction[11:8];
assign rd        = instruction[7:6];
assign rs1       = instruction[5:4];
assign rs2       = instruction[3:2];
assign immediate = instruction[5:2];

assign rf_read_addr1 =
    (opcode == 4'b0011) ? rd : rs1;

program_counter pc_unit (
    .clk(clk),
    .reset(reset),
    .pc(pc)
);

instruction_memory imem_unit (
    .address(pc),
    .instruction(instruction)
);

control_unit cu_unit (
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_op(alu_op),
    .result_sel(result_sel)
);

register_file rf_unit (
    .clk(clk),
    .reset(reset),
    .read_addr1(rf_read_addr1),
    .read_addr2(rs2),
    .write_addr(rd),
    .write_data(write_back_data),
    .reg_write(reg_write),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

alu alu_unit (
    .a(read_data1),
    .b(read_data2),
    .alu_op(alu_op),
    .result(alu_result)
);

data_memory dmem_unit (
    .clk(clk),
    .mem_read(ram_read),
    .mem_write(ram_write),
    .address(ram_address),
    .write_data(ram_write_data1),
    .read_data(ram_read_data)
);
simple_bus bus_unit (
    .address(immediate),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .cpu_write_data(read_data1),

    .ram_read_data(ram_read_data),
    .gpio_read_data(gpio_read_data),

    .cpu_read_data(mem_read_data),
    .ram_address(ram_address),
    .ram_write_data(ram_write_data),
    .gpio_write_data(gpio_write_data),

    .ram_read(ram_read),
    .ram_write(ram_write),
    .gpio_write_enable(gpio_write_enable)
);

gpio gpio_unit (
    .clk(clk),
    .reset(reset),
    .write_enable(gpio_write_enable),
    .write_data(gpio_write_data),
    .gpio_out(gpio_out),
    .read_data(gpio_read_data)
);

always @(*) begin
    case (result_sel)
        2'b00: write_back_data = alu_result;
        2'b01: write_back_data = mem_read_data;
        2'b10: write_back_data = immediate;
        default: write_back_data = 4'b0000;
    endcase
end

endmodule
