`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2022 02:10:06 PM
// Design Name: 
// Module Name: PipelinedTB
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


module PipelinedTB();
reg clk, rst;
Project1_Pipelined_Top cpu(clk, rst);


// apply clock
initial begin
    clk = 1;
    forever #20 clk = ~clk;
end

initial begin

    rst = 1;
    #20;
    rst = 0;
    #20;

end
endmodule
