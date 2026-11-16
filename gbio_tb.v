`timescale 1ns/1ps

module gpio_tb;

    reg clk;
    reg reset;
    reg write_enable;
    reg [3:0] write_data;

    wire [3:0] gpio_out;
    wire [3:0] read_data;

    gpio dut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .write_data(write_data),
        .gpio_out(gpio_out),
        .read_data(read_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        write_enable = 0;
        write_data = 4'b0000;

        #12 reset = 0;

        @(negedge clk);
        write_enable = 1;
        write_data = 4'b1010;

        @(negedge clk);
        write_enable = 0;
        write_data = 4'b0101;

        @(negedge clk);
        write_enable = 1;
        write_data = 4'b0011;

        @(negedge clk);
        write_enable = 0;

        #1 $finish;
    end

    initial begin
        $monitor("time=%0t reset=%b WE=%b write_data=%b gpio_out=%b read_data=%b",
                 $time, reset, write_enable, write_data, gpio_out, read_data);
    end

endmodule