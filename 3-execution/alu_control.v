`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:08 01/30/2016 
// Design Name: 
// Module Name:    alu_control 
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
module alu_control(
	input [5:0] ALUOp,
	input [5:0] funct,
	output wire [3:0] ALUcontrolOut
	);
	
	assign ALUcontrolOut = 	(ALUOp == 6'b000100) ? 4'b0001 : //SUB para BEQ
							(ALUOp == 6'b000101) ? 4'b0001 : //SUB para BNE
							(ALUOp == 6'b001000) ? 4'b0000 : //ADDI
							(ALUOp == 6'b001010) ? 4'b0110 : //SLTI
							(ALUOp == 6'b001100) ? 4'b0010 : //ANDI
							(ALUOp == 6'b001101) ? 4'b0011 : //ORI
							(ALUOp == 6'b001110) ? 4'b0100 : //XORI
							(ALUOp == 6'b100000) ? 4'b0000 : //ADD para LB
							(ALUOp == 6'b100001) ? 4'b0000 : //ADD para LH
							(ALUOp == 6'b100011) ? 4'b0000 : //ADD para LW
							(ALUOp == 6'b100100) ? 4'b0000 : //ADD para LBU
							(ALUOp == 6'b100101) ? 4'b0000 : //ADD para LHU
							(ALUOp == 6'b100111) ? 4'b0000 : //ADD para LWU
							(ALUOp == 6'b101000) ? 4'b0000 : //ADD para SB
							(ALUOp == 6'b101001) ? 4'b0000 : //ADD para SH
							(ALUOp == 6'b101011) ? 4'b0000 : //ADD para SW
							(	(funct == 6'b100000) ? 4'b0000 : //ADD
								(funct == 6'b100010) ? 4'b0001 : //SUB
								(funct == 6'b100100) ? 4'b0010 : //AND
								(funct == 6'b100101) ? 4'b0011 : //OR
								(funct == 6'b100110) ? 4'b0100 : //XOR
								(funct == 6'b100111) ? 4'b0101 : //NOR
								4'b0110); //SLT 

endmodule