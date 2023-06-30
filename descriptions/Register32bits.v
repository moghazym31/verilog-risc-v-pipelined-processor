`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:26:52 PM
// Design Name: 
// Module Name: Register32bits
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


module Register32bits(clk, rst, D, Load, Q);
    input clk;
    input rst;
    input [31:0] D;
    input Load;
    output [31:0] Q;
    
    wire [31:0] Y;
    genvar i;
    generate 
        for(i=0; i < 32; i= i+1)
        begin

          multiplexer2x1 inst0( Q[i], D[i], Load, Y[i]);
          DFlipFlop inst1(clk, rst, Y[i], Q[i]); 
        end
    endgenerate
endmodule