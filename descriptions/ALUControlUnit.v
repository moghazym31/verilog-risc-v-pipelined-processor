`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:17:02 PM
// Design Name: 
// Module Name: ALUControlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//Based on func3 the 30th bit and bit number 25 bit. This module will provide the ALU with a specific operation corresponding
//to the given instruction. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"
module ALUControlUnit(input [14:12] instruct0 , input instruct1,instruct2, rtype, itype, input [1:0] ALUOp, output reg [4:0] ALUSelection);
wire [5:0] fullInput;
assign fullInput = {ALUOp, instruct0,instruct1/*, instruct2*/};

always @(*)
begin 
if (instruct2 && rtype)
casex(fullInput)        
//bonus
        6'b_10_000_0: ALUSelection = `ALU_MUL;     //mul     
        6'b_10_001_0: ALUSelection = `ALU_MULH;    //mulh    
        6'b_10_010_0: ALUSelection = `ALU_MULHSU;  //mulhsu  
        6'b_10_011_0: ALUSelection = `ALU_MULHU;   //mulhu  
        6'b_10_100_0: ALUSelection = `ALU_DIV;     //div     
        6'b_10_101_0: ALUSelection = `ALU_DIVU;    //divu    
        6'b_10_110_0: ALUSelection = `ALU_REM;     //rem     
        6'b_10_111_0: ALUSelection = `ALU_REMU;    //remu        
      default:;
    endcase
else
    casex(fullInput)
                6'b_00_XXX_X:ALUSelection = `ALU_ADD; 
                6'b_01_XXX_X:ALUSelection = `ALU_SUB;
                
                6'b_10_000_X: begin if (itype) ALUSelection = `ALU_ADD; else if(rtype && instruct1 == 0 ) ALUSelection = `ALU_ADD; else if(rtype) ALUSelection = `ALU_SUB; else ALUSelection = `ALU_ADD ; end //ADD, ADDI, SUB
                6'b_11_XXX_X:ALUSelection = `ALU_PASS;    
               
                6'b_10_101_0:ALUSelection = `ALU_SRL;   
                6'b_10_101_1:ALUSelection = `ALU_SRA;   
                6'b_10_001_0:ALUSelection = `ALU_SLL;
                
                6'b_10_110_X: ALUSelection = `ALU_OR;     
                6'b_10_111_X: ALUSelection = `ALU_AND;   
                6'b_10_100_X:ALUSelection = `ALU_XOR;       
                
                6'b_10_010_X:ALUSelection = `ALU_SLT;
                6'b_10_011_X:ALUSelection = `ALU_SLTU;//UNSIGNED
                    default:;
                endcase

end
endmodule