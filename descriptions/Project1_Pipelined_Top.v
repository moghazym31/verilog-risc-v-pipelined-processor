`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2022 02:48:21 PM
// Design Name: 
// Module Name: Project1_Pipelined_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This module instantiates all required modules and gives them the appropriate inputs. This module is modeled 
// after the attached datapath. 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"


module Project1_Pipelined_Top(input clk,rst);

//IF 
wire [31:0] mux2PC, CurrentPC, PCplus4, data_out, instruction;
reg FlushingSignal;

//IFID
wire [31:0] IF_ID_CurrentPC,IF_ID_FullInstruction,IF_ID_PCplus4;

//ID
wire Sign, Jal, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, itype, rtype;
wire  [1:0] ALUOp, ControlUnitMuxSel;
wire [13:0] ActualControlSignals;
wire [31:0] ReadData1, ReadData2, ImmediateOutput;

//IDEX
wire ID_EX_Sign,ID_EX_Jal,ID_EX_Branch,ID_EX_MemRead,ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite,ID_EX_itype,ID_EX_rtype, ID_EX_Func7bit;
wire [1:0] ID_EX_ALUOp, ID_EX_ControlUnitMuxSel;
wire [2:0] ID_EX_Func3;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_OPCode;
wire [31:0] ID_EX_CurrentPC, ID_EX_ReadData1,ID_EX_ReadData2,ID_EX_ImmediateOutput, ID_EX_PCplus4;


//EX
wire cf, zf, vf, sf;
wire[1:0] ForwardA, ForwardB;
wire[4:0] ALUSelection;
wire [6:0] EX_MEM_ActualControlSignals;
wire [31:0] ALU2ndInput, PCplusVar, r , ForwardAMuxOutput, ForwardBMuxOutput;

//EXMEM
wire EX_MEM_MemWrite, EX_MEM_MemRead ,EX_MEM_Sign , EX_MEM_Jal , EX_MEM_Branch , EX_MEM_RegWrite , EX_MEM_MemtoReg, EX_MEM_cf , EX_MEM_zf , EX_MEM_vf , EX_MEM_sf;
wire [1:0] EX_MEM_ControlUnitMuxSel;
wire [4:0] EX_MEM_Rd , EX_MEM_OPCode;
wire [2:0] EX_MEM_Func3;
wire [31:0] EX_MEM_ImmediateOutput, EX_MEM_r, EX_MEM_PCplusVar, EX_MEM_CurrentPC , EX_MEM_PCplus4,EX_MEM_ReadData2;

//MEM
wire [1:0] BranchUnitOutput;

//MEMWB

wire MEM_WB_RegWrite, MEM_WB_MemtoReg;
wire [1:0] MEM_WB_ControlUnitMuxSel;
wire [4:0] MEM_WB_Rd;
wire [31:0] MEM_WB_data_out, MEM_WB_r, MEM_WB_PCplus4,MEM_WB_PCplusVar, MEM_WB_ImmediateOutput;

//WB
wire [31:0] WBStageMuxOutput, MEM_WB_WriteData;

//Miscellaneous
wire [13:0] addr = {EX_MEM_r[6:0],CurrentPC[6:0]};


//-----------------------------------------------


always @(*)
begin
if (BranchUnitOutput == 2'b_00 || BranchUnitOutput == 2'b_01 )
 FlushingSignal = 1;
 else
 FlushingSignal = 0;
end 


//IF
Register32bits ProgramCounter(clk, rst, mux2PC,  1'd_1,CurrentPC);
RCA Constant4Adder(CurrentPC, 32'd4, 1'd0, PCplus4);
//DynamicMux2x1 #(7) AddressMemoryMux();
DataAndInstructionMemory AllMemory(EX_MEM_Func3, ~clk, EX_MEM_MemRead, EX_MEM_MemWrite, addr, EX_MEM_ReadData2, data_out);
DynamicMux2x1 FetchingFlushingMux(data_out,32'h_00000033, 0/*FlushingSignal*/ , instruction );

//IF ID----------------
DynamicRegFile #(96) IF_ID (~clk,rst,1'b1,{CurrentPC,instruction,PCplus4},{IF_ID_CurrentPC,IF_ID_FullInstruction,IF_ID_PCplus4});
//---------------------

//ID

ControlUnit ControlUnit(IF_ID_FullInstruction,Sign, Jal, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, ControlUnitMuxSel, itype, rtype);
DynamicMux2x1 #(14) DecodingFlushingMux({Sign, Jal, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, ControlUnitMuxSel, itype, rtype}, 0, FlushingSignal,ActualControlSignals );

RegFile RegisterFile(~clk, rst, IF_ID_FullInstruction[`IR_rs1],IF_ID_FullInstruction[`IR_rs2], MEM_WB_Rd, MEM_WB_WriteData, MEM_WB_RegWrite, ReadData1, ReadData2);
ImmGen ImmediateGenerator(IF_ID_FullInstruction, ImmediateOutput);

//ID EX----------------
DynamicRegFile #(199) ID_EX (clk,rst,1'b1,{ActualControlSignals,IF_ID_CurrentPC, ReadData1, ReadData2,
ImmediateOutput,IF_ID_FullInstruction[`IR_funct3],IF_ID_FullInstruction[30],IF_ID_FullInstruction[25],IF_ID_FullInstruction[`IR_rs1],
IF_ID_FullInstruction[`IR_rs2], IF_ID_FullInstruction[`IR_rd],IF_ID_FullInstruction[`IR_opcode],IF_ID_PCplus4 },
{ID_EX_Sign,ID_EX_Jal,ID_EX_Branch,ID_EX_MemRead,ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc,
 ID_EX_RegWrite,ID_EX_ALUOp, ID_EX_ControlUnitMuxSel,
 ID_EX_itype,ID_EX_rtype,ID_EX_CurrentPC, ID_EX_ReadData1,ID_EX_ReadData2,ID_EX_ImmediateOutput, 
ID_EX_Func3, ID_EX_Func7bit,ID_EX_Func25bit, ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_OPCode, ID_EX_PCplus4} );
//---------------------


//EX

DynamicMux2x1 mux2ALU(ForwardBMuxOutput, ID_EX_ImmediateOutput, ID_EX_ALUSrc, ALU2ndInput);
ALU ALU( ForwardAMuxOutput, ALU2ndInput,ID_EX_itype,ID_EX_rtype, ID_EX_Rs2, ALUSelection,r,cf, zf, vf, sf);
ALUControlUnit ALUControl(ID_EX_Func3 , ID_EX_Func7bit ,ID_EX_Func25bit,ID_EX_rtype, ID_EX_itype, ID_EX_ALUOp, ALUSelection);
RCA BranchAdder(ID_EX_CurrentPC, ID_EX_ImmediateOutput, 1'd0, PCplusVar);

Forwarding_Unit forwardingUnit(ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite,ForwardA, ForwardB);

multiplexer32bits4x1 forwardA(ID_EX_ReadData1,EX_MEM_r,MEM_WB_WriteData,0,ForwardA, ForwardAMuxOutput);// idex read data 1 write data //exmemaluresult //0 selection forward unit a
multiplexer32bits4x1 forwardB(ID_EX_ReadData2,EX_MEM_r,MEM_WB_WriteData,0,ForwardB, ForwardBMuxOutput); //idex read data 2 write data // exmemaluresult //0 selectino forward unit b 

DynamicMux2x1#(7)ExecutionFlushingMux({ID_EX_MemWrite , ID_EX_MemRead , ID_EX_Sign , ID_EX_Jal , ID_EX_Branch , ID_EX_RegWrite, ID_EX_MemtoReg},0,0/*FlushingSignal*/, EX_MEM_ActualControlSignals);

//EX MEM -----------
DynamicRegFile #(218) EXMEM (~clk,rst,1'b1,{EX_MEM_ActualControlSignals , PCplusVar,ID_EX_CurrentPC,ID_EX_PCplus4,cf, zf, vf, sf,r,ID_EX_Rd, ID_EX_Func3, ID_EX_OPCode, ForwardBMuxOutput, ID_EX_ImmediateOutput, ID_EX_ControlUnitMuxSel},
{EX_MEM_MemWrite, EX_MEM_MemRead ,EX_MEM_Sign , EX_MEM_Jal , EX_MEM_Branch , EX_MEM_RegWrite , EX_MEM_MemtoReg , EX_MEM_PCplusVar,
EX_MEM_CurrentPC , EX_MEM_PCplus4 , EX_MEM_cf , EX_MEM_zf , EX_MEM_vf , EX_MEM_sf , EX_MEM_r , EX_MEM_Rd,EX_MEM_Func3, EX_MEM_OPCode, EX_MEM_ReadData2, EX_MEM_ImmediateOutput, EX_MEM_ControlUnitMuxSel});

//-----------

//MEM

BranchUnit BranchUnitInst( EX_MEM_OPCode, EX_MEM_Func3, EX_MEM_Branch, EX_MEM_cf, EX_MEM_zf, EX_MEM_vf, EX_MEM_sf, BranchUnitOutput);
//Data Memory included above is also a part of this stage
multiplexer32bits4x1 muxPC(EX_MEM_PCplusVar,EX_MEM_r ,PCplus4, EX_MEM_CurrentPC ,BranchUnitOutput , mux2PC);


//MEM WB------------
DynamicRegFile #(169) MEMWB (clk,rst,1'b1,{EX_MEM_RegWrite , EX_MEM_MemtoReg , data_out , EX_MEM_r, EX_MEM_Rd,
 EX_MEM_PCplus4, EX_MEM_PCplusVar, EX_MEM_ImmediateOutput, EX_MEM_ControlUnitMuxSel},
{MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_data_out, MEM_WB_r, MEM_WB_Rd, MEM_WB_PCplus4,
 MEM_WB_PCplusVar, MEM_WB_ImmediateOutput, MEM_WB_ControlUnitMuxSel});

//WB
DynamicMux2x1 WBStageMux(MEM_WB_r,MEM_WB_data_out, MEM_WB_MemtoReg, WBStageMuxOutput);
multiplexer32bits4x1 WriteDataMux(WBStageMuxOutput,MEM_WB_PCplus4,MEM_WB_PCplusVar,MEM_WB_ImmediateOutput,MEM_WB_ControlUnitMuxSel,MEM_WB_WriteData);


//------------------

//PC clk
//IFID ~clk
//IDEX clk
//EXMEM ~clk
//MEMWB clk
//RegFile ~clk
//DataandInstMEM ~clk (if ~clk)

endmodule
