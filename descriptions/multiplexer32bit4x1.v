`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 02:02:30 PM
// Design Name: 
// Module Name: multiplexer32bit4x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Standard fixed 32 bit 4x1 multiplexer
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiplexer32bits4x1 ( a, b, c, d, sel, out);

input [31:0] a, b, c, d;
input [1:0] sel;
output reg [31:0] out;

always @ (*)
begin

case (sel)
2'b00 : out <= a;
2'b01 : out <= b;
2'b10 : out <= c;
2'b11 : out <= d;
default:;
endcase
/*
    00 dataMem
    01 jalr
    10 AUIPC
    11 Lui
*/

end

endmodule
