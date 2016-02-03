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
	input wire reset,
	input wire [B-1:0]pc_incrementado_in,
	input wire [B-1:0]instruction_in,
	output reg [B-1:0]pc_incrementado_out,
	output reg [B-1:0]instruction_out
	);
	//reg [B-1:0] instr_reg;
	//reg [W-1:0] pc_next_reg;
	
	always @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			pc_incrementado_out <= 0;
			instruction_out <=0;
		end
		else
		begin
			instruction_out <= instruction_in;
			pc_incrementado_out <= pc_incrementado_in;
		end
	end
	
	//assign instruction_out = instr_reg;
	//assign pc_next_out = pc_next_reg;
endmodule
