`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:56:14 01/27/2016 
// Design Name: 
// Module Name:    mux 
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
module mux
	#(
		parameter B=32 // ancho de palabra en bits
	)
	(
		input wire select,
		input wire [B-1:0] item_a,
		input wire [B-1:0] item_b,
		output reg [B-1:0] signal
   );
	
	//reg [B-1:0] signal;
	
	always @(select)
	begin
		case (select)
			1'b0: signal = item_a;
			default: signal = item_b;
		endcase
	end

endmodule
