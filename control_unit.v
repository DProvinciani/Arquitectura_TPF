`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:18 11/28/2015 
// Design Name: 
// Module Name:    control_unit 
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
module control_unit(
		input wire [5:0] opcode,
		input clk,
		input ena,
		input rst,
		output reg rd,
		output reg alu_src,
		output reg mem_to_reg,
		output reg reg_write,	
		output reg mem_read,
		output reg mem_write,
		output reg branch,
		output reg next_mem_read,
		output reg [5:0]alu_op,
    );
		reg next_rd;
		reg next_alu_src;
		reg next_mem_to_reg;
		reg next_reg_write;
		reg next_mem_read;
		reg next_mem_write;
		reg next_branch;
		reg next_mem_read;
		reg [5:0]next_alu_op;
		
		//next state logic
		always @*
			begin
			alu_op = next_alu_op;
			alu_src = next_alu_src;
			branch = next_branch;
			mem_to_reg = next_mem_to_reg;
			mem_write = next_mem_write;
			rd = next_rd;
			reg_write = next_reg_write;
			case (opcode)
			6'b000000://R o J instructions
			reg_dest = 1; //falta agregar
			aluSrc = 0;
			mem_to_reg = 0;
			reg_write = 1;
			aluOp = instruction[5:0];
			branch = 0;
			default: 
				
				
			endcase
		end

endmodule
