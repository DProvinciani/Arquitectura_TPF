`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:48:25 01/29/2016 
// Design Name: 
// Module Name:    latch_MEM_WB 
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
module latch_MEM_WB
	#(
	parameter B=32, W=5
	)
	(
	input wire clk,
	input wire reset,
	/* Data signals INPUTS */
	input wire [B-1:0]read_data_in,
	input wire [B-1:0]alu_result_in,
	input wire [W-1:0]mux_RegDst_in,
	/* Data signals OUTPUTS */
	output wire [B-1:0]read_data_out,
	output wire [B-1:0]alu_result_out,
	output wire [W-1:0]mux_RegDst_out,
	/* Control signals INPUTS*/
	//Write back
	input wire wb_RegWrite_in,
	input wire wb_MemtoReg_in,
	/* Control signals OUTPUTS */
	//Write back
	input wire wb_RegWrite_out,
	input wire wb_MemtoReg_out

   );
	/* Data REGISTERS */
	reg [B-1:0]read_data_reg;
	reg [B-1:0]alu_result_reg;
	reg [W-1:0]mux_RegDst_reg;
	/* Control REGISTERS */
	//Write back
	reg wb_RegWrite_reg;
	reg wb_MemtoReg_reg;

	always @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
			read_data_reg <= 0;
			alu_result_reg <= 0;
			mux_RegDst_reg <= 0;
			wb_RegWrite_reg <= 0;
			wb_MemtoReg_reg <= 0;
		end
		else 
		begin
			/* Data signals write to ID_EX register */
			read_data_reg <= read_data_in;
			alu_result_reg <= alu_result_in;
			mux_RegDst_reg <= mux_RegDst_in;
			/* Control signals write to ID_EX register */
			//Write back
			wb_RegWrite_reg <= wb_RegWrite_in;
			wb_MemtoReg_reg <= wb_MemtoReg_in;
		end
	end
	/* Data signals read from ID_EX register */	
	assign read_data_out = read_data_reg;
	assign alu_result_out = alu_result_reg;
	assign mux_RegDst_out = mux_RegDst_reg;
	/* Control signals read from ID_EX register */
	//Write back
	assign wb_RegWrite_out = wb_RegWrite_reg;
	assign wb_MemtoReg_out = wb_MemtoReg_reg;
endmodule
