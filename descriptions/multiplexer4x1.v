`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:41:06 PM
// Design Name: 
// Module Name: multiplexer4x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module multiplexer4x1 ( input a, input b, input c, input d, input s0, s1, output out);

assign out = s1 ? (s0 ? d : c) : (s0 ? b : a);

endmodule