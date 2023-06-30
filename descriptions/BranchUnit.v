`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2022 10:40:36 AM
// Design Name: 
// Module Name: BranchUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Depending on a branch control signal and four flags from the ALU , the branch unit produces a two bit output
// which will be later used as a selector for the 4x1 mux (which is the input of the PC). By doing so, this allows
// us to correctly execute branches, jalr, jal, and halting instructions. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//MUX inputs  = BranchUnitOutput
//  Branch 00       //PC+ VAR
//  JALR   01       
//  Dont branch 10  // PC+4
`include "defines.v"

module BranchUnit(input [4:0] OPCode, input [2:0] func3, input branch, cf, zf, vf, sf,  output reg [1:0] BranchUnitOutput);
    
    always @(*)
    begin
    if (branch) begin
    case(func3)
    `BR_BEQ : BranchUnitOutput =  (zf) ? 2'b_00 : 2'b_10;
    `BR_BNE : BranchUnitOutput =  (~zf) ? 2'b_00 : 2'b_10;
    `BR_BLT :  BranchUnitOutput =  (sf!=vf) ? 2'b_00 : 2'b_10;
    `BR_BGE : BranchUnitOutput =  (sf==vf) ? 2'b_00 : 2'b_10;
    `BR_BLTU : BranchUnitOutput =  (~cf) ? 2'b_00 : 2'b_10;
    `BR_BGEU : BranchUnitOutput =  (cf) ? 2'b_00 : 2'b_10;
    default:;
    endcase
    end
    else if( OPCode == `OPCODE_JALR)
        BranchUnitOutput = 2'b_01;
    else if(OPCode ==  `OPCODE_JAL)
        BranchUnitOutput = 2'b_00;
    else if(OPCode == `OPCODE_SYSTEM)
        BranchUnitOutput = 2'b_11;
    else BranchUnitOutput = 2'b10;

    end 

endmodule
