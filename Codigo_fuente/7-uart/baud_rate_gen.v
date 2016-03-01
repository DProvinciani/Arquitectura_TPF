`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:36:17 10/17/2015 
// Design Name: 
// Module Name:    baud_rate_gen 
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
module baud_rate_gen
	#(
		M = 651 //clk 100MHz, baudrate 9600 --> clk/(baudrate*16) = count
	)
	(
		input wire clk, reset,
		output wire tick
    );
	 
	reg [9:0] r_reg, r_next;
	
	always @(posedge clk, posedge reset)
	begin
		if (reset) r_reg <= 0;
		else r_reg <= r_next;
	end
	
	//r_next = r_reg+1 o r_reg=0 (cuando r_reg=651)
	always @*
	begin
		r_next = (r_reg == (M-1)) ? 10'b00_0000_0000 : r_reg + 10'b00_0000_0001;
	end 
	
	assign tick = (r_reg == (M-1)) ? 1'b1 : 1'b0;
	
endmodule
