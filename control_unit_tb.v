module control_unit_tb;

    reg  [3:0] opcode;
    wire       reg_write;
    wire       mem_read;
    wire       mem_write;
    wire [2:0] alu_op;
    wire [1:0] result_sel;

    integer errors;

    control_unit dut (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_op(alu_op),
        .result_sel(result_sel)
    );

    task check;
        input [3:0] test_opcode;
        input [7:0] expected;
        reg   [7:0] actual;
        begin
            opcode = test_opcode;
            #1;

            actual = {reg_write, mem_read, mem_write,
                      alu_op, result_sel};

            if (actual !== expected) begin
                $display("FAIL opcode=%b expected=%b actual=%b",
                         test_opcode, expected, actual);
                errors = errors + 1;
            end
            else begin
                $display("PASS opcode=%b", test_opcode);
            end
        end
    endtask

    initial begin
        errors = 0;

        check(4'b0000, 8'b10000000); // ADD
        check(4'b0001, 8'b10000100); // SUB
        check(4'b0010, 8'b11000001); // LOAD
        check(4'b0011, 8'b00100000); // STORE
        check(4'b0100, 8'b10000010); // MOVI
        check(4'b1111, 8'b00000000); // NOP
        check(4'b0101, 8'b00000000); // opcode ??? ?????

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
