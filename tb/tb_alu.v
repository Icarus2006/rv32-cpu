`timescale 1ns/1ps
`default_nettype none
module tb_alu;
    reg  [31:0] a, b;
    reg  [3:0]  alu_control;
    wire [31:0] result;
    wire        zero;
    integer     errors = 0;

    alu dut (.a(a), .b(b), .alu_control(alu_control), .result(result), .zero(zero));

    // Κωδικοί πράξεων, για να διαβάζονται τα tests
    localparam ADD = 4'b0000, SUB = 4'b0001, AND = 4'b0010, OR  = 4'b0011,
               XOR = 4'b0100, SLT = 4'b0101, SLTU = 4'b0110,
               SLL = 4'b0111, SRL = 4'b1000, SRA = 4'b1001;

    task check(input [3:0] op, input [31:0] x, input [31:0] y, input [31:0] exp);
        begin
            alu_control = op; a = x; b = y;
            #1;
            if (result !== exp) begin
                $display("FAIL op=%b a=%h b=%h: result=%h, expected %h", op, x, y, result, exp);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sim/tb_alu.vcd");
        $dumpvars(0, tb_alu);

        // ---- ADD ----
        check(ADD, 32'd2, 32'd3, 32'd5);
        check(ADD, 32'h7FFFFFFF, 32'd1, 32'h80000000);   // wrap-around

        // ---- SUB ----
        check(SUB, 32'd5, 32'd7, 32'hFFFFFFFE);

        // TODO: AND, OR, XOR
        // TODO: SLT  (-1 < 1 -> 1)  και  SLTU (0xFFFFFFFF < 1 -> 0)
        // TODO: SLL  (1 << 33 -> 2)
        // TODO: SRL  και  SRA  (0x80000000 κατά 4)
        // TODO: default (4'b1111 -> 0)

        // ---- zero ----
        check(SUB, 32'd9, 32'd9, 32'd0);
        if (zero !== 1'b1) begin
            $display("FAIL zero: expected 1");
            errors = errors + 1;
        end

        if (errors == 0) $display("PASS");
        else             $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule