`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2022 12:08:28 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Based on an input from the ALU selector (called alufn in this module), this module will carry out the required operation
// on its two operatnds a and b .
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module ALU(
	input   wire [31:0] a, b,
	input    itype,  rtype,    //r>> b[4:0], i[shamt]
	input   wire [4:0]  shamt,
	input   wire [4:0]  alufn,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf
);
    
    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    wire [4:0] shift_amount;
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    assign shift_amount = (itype) ? shamt : b[4:0];
    shifter shifter0(a, alufn[1:0] ,shift_amount ,  sh);
    
    wire signed [31:0] signed_operand_a = a;
    wire signed [31:0] signed_operand_b = b;
    wire [63:0] full_signed_multiplication_output = signed_operand_a *signed_operand_b;
    wire [63:0] full_both_signs_multiplication_output = signed_operand_a *b;
    wire [63:0] full_unsigned_multiplication_output = a*b;
    wire [31:0] rem = a%b;
    
    
    always@(*)
    begin
        r = 0;
        (* parallel_case *)
        case (alufn)
        `ALU_AND:  r = a & b; 
        `ALU_OR:   r = a | b;    
        `ALU_XOR:  r = a ^ b;   
        `ALU_ADD:  r = add;    
        `ALU_SUB:  r = add;    
        `ALU_SLT:  r = {31'b0, (sf != vf)};
        `ALU_SLTU: r = {31'b0,(~cf)};        
        `ALU_SLLI: r = sh;        
        `ALU_SRLI: r = sh;        
        `ALU_SRAI: r = sh;
        `ALU_SLL:  r = sh;
        `ALU_SRL:  r = sh;
        `ALU_SRA:  r = sh;

           //bonus
           `ALU_MUL:   r = full_signed_multiplication_output[31:0]; 
           `ALU_MULH:   r = full_signed_multiplication_output[63:32]; 
           `ALU_MULHSU: r = full_both_signs_multiplication_output[63:32]; 
           `ALU_MULHU:  r = full_unsigned_multiplication_output[63:32]; 
           
           `ALU_REM:
                begin
                     if(signed_operand_b == 0)
                        r = 32'dZ;
                      else if(signed_operand_a[31] == 0)
                        r = rem;
                      else
                        r = ~(rem) + 1; 
                end
                
          
          `ALU_REMU:
                   begin
                       if(b == 0)
                           r = 32'dZ;
                       else if(a[31] == 0)
                           r = rem;
                       else
                           r = ~(rem) + 1; 
                   end
           
           `ALU_DIV:
               begin
                   if(signed_operand_a == 0)
                       r = 32'dZ;
                   else
                       r = signed_operand_a / signed_operand_b;
               end 
           
           
           `ALU_DIVU:
               begin
                 if(b == 0)
                    r = 32'dZ;
                 else
                    r = a / b;
                end 
 

        endcase
    end
endmodule