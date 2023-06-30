`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:32:22 PM
// Design Name: 
// Module Name: FullAdder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Standard Full adder, instantiated by the RCA
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module FullAdder(a, b, cin, sum, cout);

input a,b,cin;
output sum,cout;

assign sum=(a^b^cin);

assign cout=((a&b)|(b&cin)|(a&cin));

endmodule