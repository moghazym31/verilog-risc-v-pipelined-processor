`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:54:18 PM
// Design Name: 
// Module Name: multiplexer32bit2x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Variable size 2x1 multiplexer. This will be used for flushing
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DynamicMux2x1 #(parameter bits = 32)(input [bits-1:0] input0, input1, input selector, output [bits-1:0] Y);

assign Y = (selector)? input1:input0;

endmodule
