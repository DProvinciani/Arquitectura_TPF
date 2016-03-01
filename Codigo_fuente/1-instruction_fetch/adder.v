`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:08:24 11/27/2015 
// Design Name: 
// Module Name:    adder 
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
module adder
	#(
		parameter B=32 // ancho de la direccion
	)
	(
		input wire [B-1:0] value1,
		input wire [B-1:0] value2,
		output wire [B-1:0] result
   );
	
	assign result = value1 + value2;

endmodule
