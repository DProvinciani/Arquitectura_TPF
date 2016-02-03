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
module sig_extend(
	input [15:0]reg_in,
	output reg signed [31:0]reg_out,
	input wire clk,
	input wire reset
    );
	
	always @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			reg_out <= 0; 
		end
		else
		begin 
			reg_out <= $signed(reg_in);
		end
	end
endmodule
