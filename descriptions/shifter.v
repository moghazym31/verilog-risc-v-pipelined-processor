`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 12:14:05 PM
// Design Name: 
// Module Name: shifter
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
//shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));

module shifter(
input [31:0] a,
input [1:0] alufn ,
input [4:0] shamt,
output reg [31:0] shifted
);

integer i;
always @(*) begin
    shifted = a;
    for (i=0;i<shamt;i=i+1)
    begin
            case (alufn)
                2'b_10   : shifted =  {shifted[31], shifted[31:1]}; //SRA sign extend 
                2'b_00   : shifted = {1'b0, shifted[31:1]}; //SRL 0 extend
                2'b_01   : shifted = {shifted[30:0], 1'b0}; //SLL  0 extend
            
                default : ; // IMM_I
            endcase 
        end
    end


endmodule
