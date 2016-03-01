`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:37:33 02/08/2016 
// Design Name: 
// Module Name:    mux4 
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
module mux4
	#(
		parameter B=32
	)
	(
		input wire [1:0] sel,
		input wire [B-1:0] item_a,
		input wire [B-1:0] item_b,
		input wire [B-1:0] item_c,
		input wire [B-1:0] item_d,
		output wire [B-1:0] signal
    );

	assign signal = 	(sel == 2'b00) ? item_a :
							(sel == 2'b01) ? item_b :
							(sel == 2'b10) ? item_c :
							(sel == 2'b11) ? item_d :
							32'b11111111_11111111_11111111_11111111;
	
endmodule
