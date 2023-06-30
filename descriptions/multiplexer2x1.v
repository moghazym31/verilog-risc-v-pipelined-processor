`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:35:19 PM
// Design Name: 
// Module Name: multiplexer2x1
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

module multiplexer2x1(input0, input1, selector, Y);

output Y;
input input0, input1, selector; 

assign Y=(selector)?input1:input0;

endmodule
