`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:12 01/24/2016 
// Design Name: 
// Module Name:    latch_IF_ID 
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
module latch_IF_ID
	#(
	parameter B=32	//32 bits instruccion, 7 bits pc_next (direccion)
	)
	(
	input wire clk,
	input wire [B-1:0]pc_incrementado_in,
	input wire [B-1:0]instruction_in,
	//output reg [B-1:0]pc_incrementado_out,
	//output reg [B-1:0]instruction_out
	output wire [B-1:0]pc_incrementado_out,
	output wire [B-1:0]instruction_out
	);
	reg [B-1:0] pc_incrementado_reg;
	reg [B-1:0] instruction_reg= 32'b10001100000100000000000000000000;
	
	always @(posedge clk)
	begin
		instruction_reg <= instruction_in;
		pc_incrementado_reg <= pc_incrementado_in;
	end
	
	assign pc_incrementado_out = pc_incrementado_reg;
	assign instruction_out = instruction_reg;
	
endmodule
