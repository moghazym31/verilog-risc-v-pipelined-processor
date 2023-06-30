`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2022 01:43:24 PM
// Design Name: 
// Module Name: CPU_Top
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
`include "defines.v"


module CPU_Top(input clk,rst);

wire [31:0] FullInstruction, PCplus4, PCplusVar, mux2pc, CurrentPC, ImmediateOuput, ShiftedImmediate;
wire [31:0] ALUResult, WriteData, ReadData1, ReadData2, mux2ALU, DataMemoryOut,WriteDataMuxed;
wire [3:0] ALUControlOutput;
wire [1:0] ALUOp,ControlUnitMuxSel, BranchUnitOutput;
wire  ALUSrc, ALUZeroFlag, Branch, MemRead, MemtoReg, MemWrite, RegWrite;
wire cf, zf, vf, sf, Sign, JAL, Itype, Rtype;

BranchUnit BranchUnit( FullInstruction[`IR_opcode], FullInstruction[`IR_funct3], Branch, cf, zf, vf, sf, BranchUnitOutput);
// BranchUnit( OPCode, func3, branch, cf, zf, vf, sf,  BranchUnitOutput);


multiplexer32bits4x1 BranchAddersMux(PCplusVar,   ALUResult, PCplus4, CurrentPC, BranchUnitOutput, mux2pc);//err
RCA Constant4Adder(CurrentPC, 32'd4, 1'd0, PCplus4);

ImmGen ImmediateGenerator(FullInstruction, ImmediateOuput);
RCA BranchAdder(CurrentPC, ImmediateOuput, 1'd0, PCplusVar);   

Register32bits ProgramCounter(clk, rst, mux2pc, ~(FullInstruction[6]&FullInstruction[5]&FullInstruction[4]) , CurrentPC);
InstMem InstructionMemory(CurrentPC[31:0], FullInstruction);
multiplexer32bits4x1 WriteDataMux(WriteData,PCplus4,PCplusVar,ImmediateOuput,ControlUnitMuxSel,WriteDataMuxed); //Mem
RegFile RegisterFile(clk, rst, FullInstruction[19:15], FullInstruction[24:20], FullInstruction[11:7], WriteDataMuxed, RegWrite, ReadData1, ReadData2);
multiplexer32bit2x1 RF2ALU(ReadData2, ImmediateOuput, ALUSrc, mux2ALU);
ALU ALU(ReadData1, mux2ALU,Itype, Rtype, FullInstruction[`IR_shamt],  ALUControlOutput, ALUResult, cf, zf, vf,sf);

ControlUnit ControlUnit(FullInstruction, Sign, JAL ,Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, ControlUnitMuxSel, Itype, Rtype );
ALUControlUnit ALUControlUnit(FullInstruction[14:12], FullInstruction[30], Rtype, Itype ,ALUOp, ALUControlOutput);
DataMem DataMemory (FullInstruction[`IR_funct3], clk, MemRead,  MemWrite, ALUResult[7:0], ReadData2, DataMemoryOut);

//DataMem(funct3 ,clk,MemRead, MemWrite, addr,  data_in, data_out);

multiplexer32bit2x1 DataMemory2RF(ALUResult, DataMemoryOut, MemtoReg, WriteData);

endmodule
