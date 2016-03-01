`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:11 11/27/2015 
// Design Name: 
// Module Name:    instruction_fetch 
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
module instruction_fetch
	#(
		parameter B=32 // ancho de la direccion (PC)
	)
	(
		//input wire reset,
		input wire clk,
		input wire [B-1:0] pc,
		//output wire [B-1:0] pc_incrementado, //PC para enviar al registro IF/ID
		output [B-1:0] instruction				
    );
												
		instructionMemory im (
		.addra(pc),
		.clka(~clk), 
		.douta(instruction), 
		.ena(1'b1)
		);
	
endmodule
