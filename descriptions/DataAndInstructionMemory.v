`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2022 02:55:50 PM
// Design Name: 
// Module Name: DataAndInstructionMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This module is the single-ported instruction and data memory. Its purppose is to provide the correct memory content in case
// of a memread. Depending on the clock, it is also used to provide the correct instruction. This can be done because the memory
//itself is divided into two. Based on the clock the 32 bit data_out changes from instruction to memory content and vice versa
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Need to merge with instruction memory
//Check Negative edge 

module DataAndInstructionMemory(input [2:0] funct3 ,input clk, input MemRead, MemWrite,input [13:0] addr, input [31:0] data_in,output reg [31:0] data_out);
 parameter MemSize = 256;
 parameter DataMemStartLocation = 128;
 wire [7:0] DataMemStartIndex; 
 assign DataMemStartIndex= DataMemStartLocation + addr[13:7];
 //address 13-7  = Data Memory
 //address 6-0 = Instruction Memory
 reg [7:0] mem [0:255];


//Check Inputs and Outputs
// Add instructions and data in the memory using inital begin and end
//Start index for instruction memory is 0
//Start index for data memory is 128 (256/2)


always @(negedge clk)
     begin
     if (MemWrite)
         begin
         case(funct3)
                3'b_000: mem[DataMemStartIndex] <= data_in[7:0];
                3'b_001: begin mem[DataMemStartIndex]  <= data_in[7:0]; mem[DataMemStartIndex+1] <= data_in[15:8]; end
                3'b_010: begin mem[DataMemStartIndex]  <= data_in[7:0]; mem[DataMemStartIndex+1] <= data_in[15:8]; 
                mem[DataMemStartIndex+2] <= data_in[23:16]; mem[DataMemStartIndex+3] <= data_in[31:24]; end
         endcase   
         end
     end 

     
     
always @(*)
begin
    if (clk)
          if (MemRead)
                 begin
                      case(funct3)
                              3'b_000: data_out ={ {24{mem[DataMemStartIndex][7]}}, mem[DataMemStartIndex]};
                              3'b_001: begin data_out = { {16{mem[DataMemStartIndex+1][7]}}, mem[DataMemStartIndex+1], mem[DataMemStartIndex]}; end
                              3'b_010: begin data_out = { mem[DataMemStartIndex+3],mem[DataMemStartIndex+2], mem[DataMemStartIndex+1], mem[DataMemStartIndex]}; end
                              3'b_100: data_out ={ {24{1'b0}}, mem[DataMemStartIndex]};
                               3'b_101: begin data_out = { {16{1'b_0}}, mem[DataMemStartIndex+1], mem[DataMemStartIndex]}; end
                          default:data_out=0; 
                          endcase   
                                        
                    end
                          else data_out=0;
    else
       data_out = {mem[addr[6:0]+3],mem[addr[6:0]+2],mem[addr[6:0]+1],mem[addr[6:0]]};

end



initial begin

//Batch 1:

mem[0]=8'h_33; //add x0, x0, x0
mem[1]=8'h_00; //add x0, x0, x0
mem[2]=8'h_00; //add x0, x0, x0
mem[3]=8'h_00; //add x0, x0, x0

mem[4]=8'h_83; //lw x1, 0(x0)
mem[5]=8'h_20; //lw x1, 0(x0)
mem[6]=8'h_00; //lw x1, 0(x0)
mem[7]=8'h_00; //lw x1, 0(x0)

mem[8]=8'h_03; //lw x2, 4(x0)
mem[9]=8'h_21; //lw x2, 4(x0)
mem[10]=8'h_40; //lw x2, 4(x0)
mem[11]=8'h_00; //lw x2, 4(x0)

mem[12]=8'h_83; //lw x3, 8(x0)
mem[13]=8'h_21; //lw x3, 8(x0)
mem[14]=8'h_80; //lw x3, 8(x0)
mem[15]=8'h_00; //lw x3, 8(x0)

mem[16]=8'h_33; //add x4 x3 x2
mem[17]=8'h_82; //add x4 x3 x2
mem[18]=8'h_21; //add x4 x3 x2
mem[19]=8'h_00; //add x4 x3 x2

mem[20]=8'h_33; //sub x4, x4, x1
mem[21]=8'h_02; //sub x4, x4, x1
mem[22]=8'h_12; //sub x4, x4, x1
mem[23]=8'h_40; //sub x4, x4, x1

mem[24]=8'h_13; //addi x4, x3, 4
mem[25]=8'h_82; //addi x4, x3, 4
mem[26]=8'h_41; //addi x4, x3, 4
mem[27]=8'h_00; //addi x4, x3, 4 

mem[28]=8'h_13; //addi x4, x2, -2
mem[29]=8'h_02; //addi x4, x2, -2
mem[30]=8'h_e1; //addi x4, x2, -2
mem[31]=8'h_ff; //addi x4, x2, -2

mem[32]=8'h_b3; //and x5, x2, x3
mem[33]=8'h_72; //and x5, x2, x3
mem[34]=8'h_31; //and x5, x2, x3
mem[35]=8'h_00; //and x5, x2, x3

mem[36]=8'h_13; //andi x6, x3, 25
mem[37]=8'h_f3; //andi x6, x3, 25
mem[38]=8'h_91; //andi x6, x3, 25
mem[39]=8'h_01; //andi x6, x3, 25

mem[40]=8'h_b3; //or x7, x6, x1
mem[41]=8'h_63; //or x7, x6, x1
mem[42]=8'h_13; //or x7, x6, x1
mem[43]=8'h_00; //or x7, x6, x1

mem[44]=8'h_33; //xor x8, x6, x1
mem[45]=8'h_44; //xor x8, x6, x1
mem[46]=8'h_13; //xor x8, x6, x1
mem[47]=8'h_00; //xor x8, x6, x1

mem[48]=8'h_93; //xori x9, x8, 7
mem[49]=8'h_44; //xori x9, x8, 7
mem[50]=8'h_74; //xori x9, x8, 7
mem[51]=8'h_00; //xori x9, x8, 7

mem[52]=8'h_13; //ori x10, x9, 17
mem[53]=8'h_e5; //ori x10, x9, 17
mem[54]=8'h_14; //ori x10, x9, 17
mem[55]=8'h_01; //ori x10, x9, 17

mem[56]=8'h_b3; //sll x11, x9, x4
mem[57]=8'h_95; //sll x11, x9, x4
mem[58]=8'h_44; //sll x11, x9, x4
mem[59]=8'h_00; //sll x11, x9, x4


mem[60]=8'h_13; //slli x12, x11, 2
mem[61]=8'h_96; //slli x12, x11, 2
mem[62]=8'h_25; //slli x12, x11, 2
mem[63]=8'h_00; //slli x12, x11, 2

mem[64]=8'h_93; //srli x13, x12, 2
mem[65]=8'h_56; //srli x13, x12, 2
mem[66]=8'h_26; //srli x13, x12, 2
mem[67]=8'h_00; //srli x13, x12, 2

mem[68]=8'h_33; //srl x14,x13,x4
mem[69]=8'h_d7; //srl x14,x13,x4
mem[70]=8'h_46; //srl x14,x13,x4
mem[71]=8'h_00; //srl x14,x13,x4

mem[72]=8'h_b3; //slt x15, x14,x1 
mem[73]=8'h_27; //slt x15, x14,x1  
mem[74]=8'h_17; //slt x15, x14,x1  
mem[75]=8'h_00; //slt x15, x14,x1


mem[76]=8'h_03; //lw x16, 12(x0)
mem[77]=8'h_28; //lw x16, 12(x0)
mem[78]=8'h_c0; //lw x16, 12(x0)
mem[79]=8'h_00; //lw x16, 12(x0)


mem[80]=8'h_b3; //slt x17, x15, x16
mem[81]=8'h_a8; //slt x17, x15, x16
mem[82]=8'h_07; //slt x17, x15, x16
mem[83]=8'h_01; //slt x17, x15, x16

mem[84]=8'h_b3; //sltu x17, x15, x16
mem[85]=8'h_b8; //sltu x17, x15, x16
mem[86]=8'h_07; //sltu x17, x15, x16
mem[87]=8'h_01; //sltu x17, x15, x16

mem[88]=8'h_13; //slti x18, x3,356
mem[89]=8'h_a9; //slti x18, x3,356
mem[90]=8'h_41; //slti x18, x3,356
mem[91]=8'h_16; //slti x18, x3,356

mem[92]=8'h_93; //sltiu x19, x16, 20
mem[93]=8'h_39; //sltiu x19, x16, 20
mem[94]=8'h_48; //sltiu x19, x16, 20
mem[95]=8'h_01; //sltiu x19, x16, 20


//Batch 2 :
/*
mem[0]=8'h_33; //add x0, x0, x0
mem[1]=8'h_00; //add x0, x0, x0
mem[2]=8'h_00; //add x0, x0, x0
mem[3]=8'h_00; //add x0, x0, x0

mem[4]=8'h_83; //lw x1, 16(x0)
mem[5]=8'h_20; //lw x1, 16(x0)
mem[6]=8'h_00; //lw x1, 16(x0)
mem[7]=8'h_01; //lw x1, 16(x0)

mem[8]=8'h_03; //lb x2, 20(x0)
mem[9]=8'h_01; //lb x2, 20(x0)
mem[10]=8'h_40; //lb x2, 20(x0)
mem[11]=8'h_01; //lb x2, 20(x0)

mem[12]=8'h_b3; //sra x3, x1, x2
mem[13]=8'h_d1; //sra x3, x1, x2
mem[14]=8'h_20; //sra x3, x1, x2
mem[15]=8'h_40; //sra x3, x1, x2

mem[16]=8'h_13; //srai x4, x1, 1
mem[17]=8'h_d2; //srai x4, x1, 1
mem[18]=8'h_10; //srai x4, x1, 1
mem[19]=8'h_40; //srai x4, x1, 1

mem[20]=8'h_83; //lbu x5, 24(x0)
mem[21]=8'h_42; //lbu x5, 24(x0)
mem[22]=8'h_80; //lbu x5, 24(x0)
mem[23]=8'h_01; //lbu x5, 24(x0)

mem[24]=8'h_03; //lhu x6, 24(x0)
mem[25]=8'h_53; //lhu x6, 24(x0)
mem[26]=8'h_80; //lhu x6, 24(x0)
mem[27]=8'h_01; //lhu x6, 24(x0)

mem[28]=8'h_03; //lh x8, 12(x0)
mem[29]=8'h_14; //lh x8, 12(x0)
mem[30]=8'h_c0; //lh x8, 12(x0)
mem[31]=8'h_00; //lh x8, 12(x0)

mem[32]=8'h_23; //sb x8, 32(x0)
mem[33]=8'h_00; //sb x8, 32(x0)
mem[34]=8'h_80; //sb x8, 32(x0)
mem[35]=8'h_02; //sb x8, 32(x0)

mem[36]=8'h_83; //lbu x9, 32(x0)
mem[37]=8'h_44; //lbu x9, 32(x0)
mem[38]=8'h_00; //lbu x9, 32(x0)
mem[39]=8'h_02; //lbu x9, 32(x0)

mem[40]=8'h_83; //lh x11, 12(x0)
mem[41]=8'h_15; //lh x11, 12(x0)
mem[42]=8'h_c0; //lh x11, 12(x0)
mem[43]=8'h_00; //lh x11, 12(x0)

mem[44]=8'h_23; //sh x11, 36(x0)
mem[45]=8'h_12; //sh x11, 36(x0)
mem[46]=8'h_b0; //sh x11, 36(x0)
mem[47]=8'h_02; //sh x11, 36(x0)

mem[48]=8'h_03; //lhu x12, 36(x0)
mem[49]=8'h_56; //lhu x12, 36(x0)
mem[50]=8'h_40; //lhu x12, 36(x0)
mem[51]=8'h_02; //lhu x12, 36(x0)

mem[52]=8'h_23; //sw x8, 40(x0)
mem[53]=8'h_24; //sw x8, 40(x0)
mem[54]=8'h_80; //sw x8, 40(x0)
mem[55]=8'h_02; //sw x8, 40(x0)

mem[56]=8'h_83; //lw x13, 40(x0)
mem[57]=8'h_26; //lw x13, 40(x0)
mem[58]=8'h_80; //lw x13, 40(x0)
mem[59]=8'h_02; //lw x13, 40(x0)

mem[60]=8'h_37; //lui x14, 26 
mem[61]=8'h_a7; //lui x14, 26 
mem[62]=8'h_01; //lui x14, 26 
mem[63]=8'h_00; //lui x14, 26 

mem[64]=8'h_97; //auipc x15, 26 
mem[65]=8'h_a7; //auipc x15, 26 
mem[66]=8'h_01; //auipc x15, 26 
mem[67]=8'h_00; //auipc x15, 26 */


//Batch 3:
/*mem[0]=8'h_33; //add x0, x0, x0
mem[1]=8'h_00; //add x0, x0, x0
mem[2]=8'h_00; //add x0, x0, x0
mem[3]=8'h_00; //add x0, x0, x0

mem[4]=8'h_03; //lw x2, 16(x0)
mem[5]=8'h_21; //lw x2, 16(x0)
mem[6]=8'h_00; //lw x2, 16(x0)
mem[7]=8'h_01; //lw x2, 16(x0)


mem[8]=8'h_83; //lw x3, 12(x0)
mem[9]=8'h_21; //lw x3, 12(x0)
mem[10]=8'h_c0; //lw x3, 12(x0)
mem[11]=8'h_00; //lw x3, 12(x0)*/


/*mem[12]=8'h_63; //bltu x2,x3,L1
mem[13]=8'h_6a; //bltu x2,x3,L1
mem[14]=8'h_31; //bltu x2,x3,L1
mem[15]=8'h_00; //bltu x2,x3,L1*/



/*mem[12]=8'h_63; //bne x1,x0 , L1
mem[13]=8'h_9a; //bne x1,x0 , L1
mem[14]=8'h_00; //bne x1,x0 , L1
mem[15]=8'h_00; //bne x1,x0 , L1*/



/*mem[12]=8'h_63; //beq x1,x0 , L1
mem[13]=8'h_88; //beq x1,x0 , L1
mem[14]=8'h_00; //beq x1,x0 , L1
mem[15]=8'h_00; //beq x1,x0 , L1*/


/*mem[12]=8'h_ef; //jal x1 , L1
mem[13]=8'h_00; //jal x1 , L1
mem[14]=8'h_40; //jal x1 , L1
mem[15]=8'h_01; //jal x1 , L1*/



/*mem[12]=8'h_63; //blt x2,x3,L1
mem[13]=8'h_4a; //blt x2,x3,L1
mem[14]=8'h_31; //blt x2,x3,L1
mem[15]=8'h_00; //blt x2,x3,L1*/



/*mem[12]=8'h_63; //bge x2,x3,L1
mem[13]=8'h_5a; //bge x2,x3,L1
mem[14]=8'h_31; //bge x2,x3,L1
mem[15]=8'h_00; //bge x2,x3,L1*/



/*mem[12]=8'h_63; //bgeu x2,x3,L1
mem[13]=8'h_7a; //bgeu x2,x3,L1
mem[14]=8'h_31; //bgeu x2,x3,L1
mem[15]=8'h_00; //bgeu x2,x3,L1*/



/*mem[12]=8'h_03; //lw x4, 36(x0)
mem[13]=8'h_22; //lw x4, 36(x0)
mem[14]=8'h_40; //lw x4, 36(x0)
mem[15]=8'h_02; //lw x4, 36(x0)


mem[16]=8'h_67; //jalr x0, 0(x4)
mem[17]=8'h_00; //jalr x0, 0(x4)
mem[18]=8'h_02; //jalr x0, 0(x4)
mem[19]=8'h_00; //jalr x0, 0(x4)*/

/*
mem[16]=8'h_13; //addi x2, x2, 1
mem[17]=8'h_01; //addi x2, x2, 1
mem[18]=8'h_11; //addi x2, x2, 1
mem[19]=8'h_00; //addi x2, x2, 1*/

/*mem[20]=8'h_13; //addi x2, x2, 2
mem[21]=8'h_01; //addi x2, x2, 2
mem[22]=8'h_21; //addi x2, x2, 2
mem[23]=8'h_00; //addi x2, x2, 2

mem[24]=8'h_13; //addi x2, x2, 3
mem[25]=8'h_01; //addi x2, x2, 3
mem[26]=8'h_31; //addi x2, x2, 3
mem[27]=8'h_00; //addi x2, x2, 3

mem[28]=8'h_93; //L1:addi x1, x1, 0
mem[29]=8'h_80; //L1:addi x1, x1, 0
mem[30]=8'h_00; //L1:addi x1, x1, 0
mem[31]=8'h_00; //L1:addi x1, x1, 0*/



/*
//Batch 4:
mem[0]=8'h_33; //add x0, x0, x0
mem[1]=8'h_00; //add x0, x0, x0
mem[2]=8'h_00; //add x0, x0, x0
mem[3]=8'h_00; //add x0, x0, x0


//7680
mem[4]=8'h_03; //lw x2, 16(x0)
mem[5]=8'h_21; //lw x2, 16(x0)
mem[6]=8'h_00; //lw x2, 16(x0)
mem[7]=8'h_01; //lw x2, 16(x0)


//-1
mem[8]=8'h_83; //lw x3, 12(x0)
mem[9]=8'h_21; //lw x3, 12(x0)
mem[10]=8'h_c0; //lw x3, 12(x0)
mem[11]=8'h_00; //lw x3, 12(x0)

mem[12]=8'h_03; //lw x4, 4(x0)
mem[13]=8'h_22; //lw x4, 4(x0)
mem[14]=8'h_40; //lw x4, 4(x0)
mem[15]=8'h_00; //lw x4, 4(x0)

mem[16]=8'h_b3; //mul x5,x4,x3
mem[17]=8'h_02; //mul x5,x4,x3
mem[18]=8'h_32; //mul x5,x4,x3
mem[19]=8'h_02; //mul x5,x4,x3


mem[20]=8'h_33; //mul x6,x5,x2
mem[21]=8'h_83; //mul x6,x5,x2
mem[22]=8'h_22; //mul x6,x5,x2
mem[23]=8'h_02; //mul x6,x5,x2

mem[24]=8'h_b3; //mulh x7,x6,x4
mem[25]=8'h_13; //mulh x7,x6,x4
mem[26]=8'h_43; //mulh x7,x6,x4
mem[27]=8'h_02; //mulh x7,x6,x4

mem[28]=8'h_03; //lw x8, 8(x0)
mem[29]=8'h_24; //lw x8, 8(x0)
mem[30]=8'h_80; //lw x8, 8(x0)
mem[31]=8'h_00; //lw x8, 8(x0)


mem[32]=8'h_b3; //mulhsu x9,x2,x6
mem[33]=8'h_24; //mulhsu x9,x2,x6
mem[34]=8'h_61; //mulhsu x9,x2,x6
mem[35]=8'h_02; //mulhsu x9,x2,x6


mem[36]=8'h_33; //mulhu x10,x8,x4
mem[37]=8'h_35; //mulhu x10,x8,x4
mem[38]=8'h_44; //mulhu x10,x8,x4
mem[39]=8'h_02; //mulhu x10,x8,x4

mem[40]=8'h_b3; //div x11, x2, x7
mem[41]=8'h_45; //div x11, x2, x7
mem[42]=8'h_71; //div x11, x2, x7
mem[43]=8'h_02; //div x11, x2, x7

mem[44]=8'h_33; //divu x12, x2,x3
mem[45]=8'h_56; //divu x12, x2,x3
mem[46]=8'h_31; //divu x12, x2,x3
mem[47]=8'h_02; //divu x12, x2,x3

mem[48]=8'h_b3; //rem x13, x2, x4
mem[49]=8'h_66; //rem x13, x2, x4
mem[50]=8'h_41; //rem x13, x2, x4
mem[51]=8'h_02; //rem x13, x2, x4

mem[52]=8'h_33; //rem x14, x2, x8
mem[53]=8'h_67; //rem x14, x2, x8
mem[54]=8'h_81; //rem x14, x2, x8
mem[55]=8'h_02; //rem x14, x2, x8*/


  mem[128]=8'd17;
  mem[129]=8'd0;
  mem[130]=8'd0;
  mem[131]=8'd0;
  
  mem[132]=8'd9;
  mem[133]=8'd0;
  mem[134]=8'd0;
  mem[135]=8'd0;
  
  mem[136]=8'd25;
  mem[137]=8'd0;
  mem[138]=8'd0;
  mem[139]=8'd0;
 
 //-1 
  mem[140]=8'hff;
  mem[141]=8'hff;
  mem[142]=8'hff;
  mem[143]=8'hff;
  
 //7680
   mem[144]=8'h00;
   mem[145]=8'h1e;
   mem[146]=8'h00;
   mem[147]=8'h00;
   
 //1000000001  
   
   mem[148]=8'h01;
   mem[149]=8'hca;
   mem[150]=8'h9a;
   mem[151]=8'h3b;
   
   //binary 11111111111111111
   mem[152]=8'hff;
   mem[153]=8'hff;
   mem[154]=8'hff;
   mem[155]=8'h00;

   mem[156]=8'hff;
   mem[157]=8'hff;
   mem[158]=8'hff;
   mem[159]=8'h00;

   mem[160]=8'h1C;
   mem[161]=8'h00;
   mem[162]=8'h00;
   mem[163]=8'h00;
   
   mem[164]=8'h20;
   mem[165]=8'h00;
   mem[166]=8'h00;
   mem[167]=8'h00;
   

   

end
 endmodule