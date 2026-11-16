module alu_tb;

    reg  [3:0] a;
    reg  [3:0] b;
    reg  [2:0] alu_op;
    wire [3:0] result;

    alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result)
    );

    task check_operation;
        input [2:0] op;
        input [3:0] expected;
        begin
            alu_op = op;
            #1;

            if (result !== expected) begin
                $display("FAIL: op=%b, expected=%b, actual=%b",
                         op, expected, result);
                $finish;
            end
            else begin
                $display("PASS: op=%b, result=%b",
                         op, result);
            end
        end
    endtask

    initial begin
        a = 4'b1010;
        b = 4'b0011;

        check_operation(3'b000, 4'b1101); // 10 + 3 = 13
        check_operation(3'b001, 4'b0111); // 10 - 3 = 7
        check_operation(3'b010, 4'b0010); // AND
        check_operation(3'b011, 4'b1011); // OR
        check_operation(3'b100, 4'b1001); // XOR
        check_operation(3'b101, 4'b0101); // NOT ?? a
        check_operation(3'b110, 4'b0000); // default
        check_operation(3'b111, 4'b0000); // default

        $display("PASS: ?? ?????? ALU ????");
        $finish;
    end

endmodule
