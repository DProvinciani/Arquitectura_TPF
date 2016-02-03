`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:01 01/30/2016 
// Design Name: 
// Module Name:    write_back 
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
module write_back
	#(
	parameter B=32, D=5
	)
	(
	input clk,
	input wire[B-1:0]mem_data,
	input wire[B-1:0]ALU_data,
	input wire MemtoReg,
	output wire data_out
   );
	mux wb_mux (
	.select(MemtoReg),
	.item_a(mem_data),
	.item_b(ALU_data),
	.signal(data_out)
	);
	


endmodule
