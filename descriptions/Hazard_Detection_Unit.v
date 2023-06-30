`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2022 01:32:54 PM
// Design Name: 
// Module Name: DetectionUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Unused in the pipelined implementation as the slow-fast clock solution eliminate the hazards this module was built to mitigate. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Hazard_Detection_Unit(input [4:0] IF_IDRegisterRs1,IF_IDRegisterRs2, ID_EXRegisterRd, input ID_EXMemRead ,output reg stall);

    always @(*) begin
        if ( (IF_IDRegisterRs1==ID_EXRegisterRd) || (IF_IDRegisterRs2==ID_EXRegisterRd) && (ID_EXMemRead && (ID_EXRegisterRd != 0)) )
            stall = 1;
        else 
            stall = 0;
    end

endmodule