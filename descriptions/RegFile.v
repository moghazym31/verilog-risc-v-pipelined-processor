`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:34:29 PM
// Design Name: 
// Module Name: RegFile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Contains all 32 bit registers. Any updates or reads to any registers made by instructions are made through this file
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module RegFile(
input clk, rst,// clock and reset
input [4:0] readreg1, readreg2, writereg, //selector  for reading/writing 
input [31:0] writedata, //data to be written 
input regwrite,// write switch
output  [31:0] readdata1, readdata2);//readed output 

reg Load [31:0];
wire [31:0] dataout [0:31];

integer j;
    genvar i;
    generate 
        for(i=0; i < 32; i= i+1) 
        begin
            Register32bits inst3 (clk,rst,writedata,Load[i],dataout[i]);
      end
      endgenerate
      
always @ (*) 
begin

    for (j=0;j<32;j=j+1)
    begin
        if (j == writereg && regwrite ==1 && j != 0)
            Load[j] =1;
        else 
            Load[j]=0;    
    end
    
 end
 

assign readdata1 = dataout[readreg1] ; 
assign readdata2 = dataout[readreg2] ; 


endmodule