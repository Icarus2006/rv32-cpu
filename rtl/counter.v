`default_nettype none
// Παράδειγμα από το Μέρος 0 (κεφ. 0.4): μόνο για να μάθεις τη ροή προσομοίωσης.
module counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst)     q <= 4'd0;
        else if (en) q <= q + 4'd1;
    end
endmodule
