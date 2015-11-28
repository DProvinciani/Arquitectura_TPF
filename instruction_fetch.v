`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:11 11/27/2015 
// Design Name: 
// Module Name:    instruction_fetch 
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
module instruction_fetch(
		input [6:0] pc_in,
		input wire enable,
		input wire reset,
		input wire clock,
		output [6:0] pc_next,
		output [31:0] instruction
    );
	
	wire [6:0] pc_out;
	reg [6:0] pc_reg = 7'b0000000;
	
	program_counter pc (.next_in(pc_in), .next_out(pc_out));
	adder add (.pc(pc_reg), .pc_next(pc_next));
	instruction_memory im (.addra(pc_reg), .ena(enable), .rsta(reset), .clka(clock), .douta(instruction)); //recorda cambiar el clock que pusiste en el ENA
	
	always@(posedge clock or posedge reset)
	if (reset == 1) pc_reg = 7'b0000000;
	else
	begin
		if (enable) begin
			pc_reg = pc_out;
		end
	end

endmodule
