`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:49 01/30/2016 
// Design Name: 
// Module Name:    alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu #(parameter B = 32)
	(
	input wire [B-1:0] op1,
	input wire [B-1:0] op2,
	input wire [3:0] alu_control,
	output wire [B-1:0] result,
	output wire zero
	);
	
	assign result = 	(alu_control == 4'b0000) ? op1 + op2 : //ADD
							(alu_control == 4'b0001) ? op1 - op2 : //SUB
							(alu_control == 4'b0010) ? op1 & op2 : //AND
							(alu_control == 4'b0011) ? op1 | op2 : //OR
							(alu_control == 4'b0100) ? op1 ^ op2 : //XOR
							(alu_control == 4'b0101) ? ~(op1 | op2) : //NOR
							(alu_control == 4'b0110) ? op1 < op2 : //SLT
							32'b11111111_11111111_11111111_11111111;
	
	assign zero = (result == 0) ? 1'b1 : 1'b0;
							
endmodule
