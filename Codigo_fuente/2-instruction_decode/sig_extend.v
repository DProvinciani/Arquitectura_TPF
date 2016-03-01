`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:17 11/28/2015 
// Design Name: 
// Module Name:    sig_extend 
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
module sig_extend
	#(
		parameter B=16
	)
	(
		input [B-1:0] reg_in,
		output [31:0] reg_out
    );
	
	assign reg_out = {{(32-B){reg_in[B-1]}}, reg_in};
	
endmodule
