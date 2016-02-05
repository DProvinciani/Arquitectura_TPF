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
	
	assign result = 	(alu_control == 4'b0010) ? op1 + op2 : //ADD
							(alu_control == 4'b0110) ? op1 - op2 : //SUB
							(alu_control == 4'b0000) ? op1 & op2 : //AND
							(alu_control == 4'b0001) ? op1 | op2 : //OR
							(alu_control == 4'b0111) ? op1 < op2 : //SLT
							32'b11111111_11111111_11111111_11111111;
	
	assign zero = (result == 0) ? 1'b1 : 1'b0;
							
	/*
	always @(*) begin
		case (alu_control)
			3'b0010: result = op1 + op2; //ADD
			3'b0110: result = op1 - op2; //SUB
			3'b0000: result = op1 & op2; //AND
			3'b0001: result = op1 | op2; //OR
			3'b0111: result = op1 < op2; //SLT
		endcase
		if(result == 0)
			zero = 1;
		else
			zero = 0;
	end
	*/
endmodule
