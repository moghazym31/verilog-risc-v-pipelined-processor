`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2022 02:37:56 PM
// Design Name: 
// Module Name: DynamicRegFile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dynamic registers are used for all the pipeline registers as they are all of different lengths.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DynamicRegFile #(parameter bits = 32)
(clk, rst, Load, D, Q);
    input clk;
    input rst;
    input [bits-1:0] D;
    input Load;
    output [bits-1:0] Q;
    
    wire [bits-1:0] Y;
    genvar i;
    generate 
        for(i=0; i < bits; i= i+1) 
        begin
          multiplexer2x1 inst0( Q[i], D[i], Load, Y[i]);
          DFlipFlop inst1(clk, rst, Y[i], Q[i]); 
        end
    endgenerate
endmodule
