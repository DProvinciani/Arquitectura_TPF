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
	input [1:0] ALUOp,
	input [5:0] funct,
	output wire [3:0] ALUcontrolOut
	);
	
	assign ALUcontrolOut = 	(ALUOp == 2'b00) ? 4'b0010 : //ADD
									(ALUOp == 2'b01) ? 4'b0110 : //SUB
									(	(funct == 6'b100000) ? 4'b0010 :
										(funct == 6'b100010) ? 4'b0110 : //SUB
										(funct == 6'b100100) ? 4'b0000 : //AND
										(funct == 6'b100101) ? 4'b0001 : //OR
										4'b0111); //SLT
	/*														 
	always @(*) begin
		case (ALUOp)
		2'b00: ALUcontrolOut <= 4'b0010; //ADD
		2'b01: ALUcontrolOut <= 4'b0110; //SUB
		2'b10: begin
				case(funct)
					6'b100000: ALUcontrolOut <= 4'b0010; //ADD
					6'b100010: ALUcontrolOut <= 4'b0110; //SUB
					6'b100100: ALUcontrolOut <= 4'b0000; //AND
					6'b100101: ALUcontrolOut <= 4'b0001; //OR
					6'b101010: ALUcontrolOut <= 4'b0111; //SLT
				endcase
				end
		endcase
	end
	*/
endmodule
