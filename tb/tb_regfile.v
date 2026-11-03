`timescale 1ns/1ps
`default_nettype none
module tb_regfile;
    reg         clk = 1'b0;
    reg         we3 = 1'b0;
    reg  [4:0]  a1, a2, a3;
    reg  [31:0] wd3;
    wire [31:0] rd1, rd2;
    integer     errors = 0;
    integer     i;

    regfile dut (.clk(clk), .we3(we3), .a1(a1), .a2(a2), .a3(a3),
                 .wd3(wd3), .rd1(rd1), .rd2(rd2));

    always #5 clk = ~clk;

    // Εγγραφή: βάζουμε τις εισόδους στην αρνητική ακμή,
    // η εγγραφή γίνεται στην επόμενη θετική, και μετά κλείνουμε το we3.
    task write_reg(input [4:0] addr, input [31:0] value);
        begin
            @(negedge clk);
            a3 = addr; wd3 = value; we3 = 1'b1;
            @(negedge clk);
            we3 = 1'b0;
        end
    endtask

    // Ανάγνωση: συνδυαστική, άρα δεν περιμένουμε ρολόι, μόνο 1 ns.
    // Ελέγχουμε και τις δύο θύρες ανάγνωσης με την ίδια διεύθυνση.
    task check_read(input [4:0] addr, input [31:0] exp);
        begin
            a1 = addr; a2 = addr;
            #1;
            if (rd1 !== exp || rd2 !== exp) begin
                $display("FAIL x%0d: rd1=%h rd2=%h, expected %h", addr, rd1, rd2, exp);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sim/tb_regfile.vcd");
        $dumpvars(0, tb_regfile);

        // 1. Γράφουμε και διαβάζουμε έναν καταχωρητή
        write_reg(5'd5, 32'hDEADBEEF);
        check_read(5'd5, 32'hDEADBEEF);

        // 2. Ο x0 μένει πάντα 0
        write_reg(5'd0, 32'h12345678);
        check_read(5'd0, 32'd0);

        // TODO 3: με we3 = 0 η τιμή ΔΕΝ αλλάζει.
        //         Βάλε a3 = 5, wd3 = κάτι άλλο, περίμενε μια ακμή χωρίς we3,
        //         και έλεγξε ότι ο x5 είναι ακόμα DEADBEEF.

        @(negedge clk);
        a3 = 5'd5;
        wd3 = 32'd2006;
        we3 = 1'b0;
        @(negedge clk);
        check_read(5'd5, 32'hDEADBEEF);
        
        // TODO 4: γράψε όλους τους x1..x31 με διαφορετική τιμή (π.χ. i * 3)
        //         με ένα for, και μετά διάβασέ τους όλους με δεύτερο for.
        for (i = 1; i < 32; i = i + 1)
            write_reg(i, i*3);
        for (i = 1; i < 32; i = i + 1)
            check_read(i, i*4);

        // TODO 5: οι δύο θύρες ανάγνωσης είναι ανεξάρτητες:
        //         a1 = 1, a2 = 2 ταυτόχρονα, και το rd1, rd2 δίνουν το καθένα το σωστό.

        if (errors == 0) $display("PASS");
        else             $display("FAIL: %0d errors", errors);
        $finish;
    end
endmodule