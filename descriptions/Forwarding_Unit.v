`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/06/2022 10:32:25 AM
// Design Name:
// Module Name: ForwardingUnit
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


module Forwarding_Unit(input [4:0] ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, input EX_MEM_RegWrite, MEM_WB_RegWrite,
                      output reg [1:0] ForwardA, ForwardB);

    always @(*) begin
               
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1))
            ForwardA = 2'b10; //exmem alu result
         
        else if ((MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1)) && ~(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1)))
            ForwardA = 2'b01; //write data
         
        else
            ForwardA = 2'b00;  //idex read data one
    end  
   
    always @(*) begin  
       
        if ((MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2)) && ~(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2)))
            ForwardB = 2'b01; //write data
           
        else if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2))
            ForwardB = 2'b10;// exmem alu result
       
        else
            ForwardB = 2'b00; // //idex read data two 
    end
endmodule
