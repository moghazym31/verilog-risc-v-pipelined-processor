`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 01:20:14 PM
// Design Name: 
// Module Name: ControlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Based on the OPCODE, func3 and func7, the control unit outputs the correct control signals which will be used to correctly
// execute the desired instruction.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module ControlUnit(input [31:0] fullInstruction,  
output reg sign,
output jal, branch, 
MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, output [1:0] ALUOP, muxSel, output reg itype, rtype);

reg [10:0] ControlInstruction;
reg [3:0] Func3Func7;
//
always @(*)
begin 
Func3Func7 = {fullInstruction[14:12], fullInstruction[30]};
itype = 0;
rtype = 0;
sign = 0;

/*
    00 dataMem
    01 jalr
    10 AUIPC
    11 Lui
*/
casex(fullInstruction[6:2])
    `OPCODE_Branch: begin ControlInstruction  =   11'b_00_0100_01_000;
        
         casex(Func3Func7)
             4'b_110X:sign = 1;//BLTU
             4'b_111X:sign = 1;//BGEU
             default:;
             endcase
         end
         
     `OPCODE_Load: begin  ControlInstruction  =   11'b_00_0011_00_011;
         
           casex(Func3Func7)
            4'b_100X:sign = 1;//LBU
            4'b_101X:sign = 1;//LHU
            default:;
            endcase
        end
        
    `OPCODE_Store:  ControlInstruction  =   11'b_00_0001_00_110;
    `OPCODE_JALR: ControlInstruction    =   11'b_01_1000_00_011;
    `OPCODE_JAL: ControlInstruction     =   11'b_01_1000_00_011; 
    `OPCODE_Arith_I: 
    begin 
    ControlInstruction=  11'b_00_0000_10_011;
     
       
         casex(Func3Func7)
         4'b_0110: sign = 1;//SLTIU
         default:;
         endcase
     
     itype = 1'b1;
     end //
    `OPCODE_Arith_R : begin 
        ControlInstruction =   11'b_00_0000_10_001;
          
              case(Func3Func7)
               4'b_0110: sign = 1;//SLTU
               default:;
               endcase
           
        rtype = 1'b1;
        end //
        
    `OPCODE_AUIPC: ControlInstruction   =   11'b_10_0000_00_011;
    `OPCODE_SYSTEM: ControlInstruction   =   11'b_00_0000_00_000;
    
    `OPCODE_FENCE: ControlInstruction   =   11'b_00_0000_00_000;
    
    `OPCODE_LUI: ControlInstruction     =   11'b_11_0000_11_011;
    
    default:ControlInstruction=0;
    endcase
end


//assign {branch,MemRead,MemtoReg, ALUOP, MemWrite, ALUSrc, RegWrite} = ControlInstruction;

assign muxSel = ControlInstruction[10:9];
assign jal = ControlInstruction[8];
assign branch = ControlInstruction[7];
assign MemRead = ControlInstruction[6];
assign MemtoReg = ControlInstruction[5];
assign ALUOP = ControlInstruction[4:3];
assign MemWrite = ControlInstruction[2];
assign ALUSrc = ControlInstruction[1];
assign RegWrite = ControlInstruction[0];
endmodule