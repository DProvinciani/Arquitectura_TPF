`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:05 11/27/2015 
// Design Name: 
// Module Name:    program_counter 
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
module program_counter
	#(
	parameter B=32 // ancho de la direccion
	)
	(
		input wire clk,
		input [B-1:0] next_in,
		output [B-1:0] next_out
   );
	
	//PC
	reg [B-1:0] pc_counter;
	// operacion escritura de la nueva direcion
	always @(posedge clk)
			pc_counter <= next_in;
	
	assign next_out = pc_counter;

endmodule
