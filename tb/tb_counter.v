`timescale 1ns/1ps
`default_nettype none
module tb_counter;
    reg        clk = 1'b0;
    reg        rst = 1'b1;
    reg        en  = 1'b0;
    wire [3:0] q;
    integer    errors = 0;

    counter dut (.clk(clk), .rst(rst), .en(en), .q(q));

    always #5 clk = ~clk;              // period 10 ns

    task check(input [3:0] exp);
        begin
            if (q !== exp) begin
                $display("FAIL at %0t ns: q=%0d, expected %0d", $time, q, exp);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sim/tb_counter.vcd");
        $dumpvars(0, tb_counter);

        @(negedge clk); rst = 1'b0; en = 1'b1;
        @(negedge clk); check(4'd1);
        repeat (14) @(negedge clk);
        check(4'd15);
        @(negedge clk); check(4'd0);   // wrap-around
        en = 1'b0;
        @(negedge clk); check(4'd0);   // hold

        if (errors == 0) $display("PASS");
        else             $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule
