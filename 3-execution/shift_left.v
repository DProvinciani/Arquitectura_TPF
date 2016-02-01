`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:17 01/30/2016 
// Design Name: 
// Module Name:    shift_left 
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
module shift_left(
    	input [31:0] shift_in,
		output [31:0] shift_out
    );
	
	assign shift_out = (shift_in << 2);

endmodule
