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
module adder(
		input [6:0] pc,
		output [6:0] pc_next
    );
	
	assign pc_next = pc + 1'b1;

endmodule
