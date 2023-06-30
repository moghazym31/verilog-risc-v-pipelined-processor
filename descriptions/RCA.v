`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:31:37 PM
// Design Name: 
// Module Name: RCA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Simple Ripple carry adder. CIN is 0 from the top module. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps


module RCA(a,b,cin,sum,cout);
input [31:0] a;
input [31:0] b;
input cin;

output [31:0]sum;
output cout;

wire[31:0] c;


genvar i;
generate 
    for(i=0; i < 32; i= i+1)
    begin
    if (i == 0)
        FullAdder uut(a[i],b[i],cin,sum[i],c[i]);
    else
        FullAdder uut(a[i],b[i],c[i-1],sum[i],c[i]);  
    end
endgenerate

assign cout = c[31];

endmodule
