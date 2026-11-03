/*###########-Μια πρώτη δομή για το Register File-###########*/
`timescale 1ns/1ps
`default_nettype none

module regfile(
    input wire clk,
    input wire we3,
    input wire [4:0] a1,
    input wire [4:0] a2,
    input wire [4:0] a3,
    input wire [31:0] wd3,
    output wire [31:0] rd1,
    output wire [31:0] rd2
);

reg [31:0] data[0:31];

always@(posedge clk)begin
    if((we3 == 1) & (a3 != 5'b0))begin
    data[a3] <= wd3;

    end
end

assign rd1 = (a1 == 5'b0) ? 32'b0 : data[a1];
assign rd2 = (a2 == 5'b0) ? 32'b0 : data[a2];

endmodule