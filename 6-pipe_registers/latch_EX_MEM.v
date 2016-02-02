`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:18:58 01/29/2016 
// Design Name: 
// Module Name:    latch_EX_MEM 
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
module latch_EX_MEM
	#(
	parameter B=32, W=7
   )
	(
	input wire clk,
	/* Data signals INPUTS */
	input wire [B-1:0]add_result_in,
	input wire [B-1:0]alu_result_in,
	input wire [B-1:0]r_data2_in,
	input wire [B-1:0]mux_RegDst_in,
	/* Data signals OUTPUTS */
	output wire [B-1:0]add_result_out,
	output wire [B-1:0]alu_result_out,
	output wire [B-1:0]r_data2_out,
	output wire [B-1:0]mux_RegDst_out,
	/* Control signals INPUTS*/
	input wire zero_in,
	//Write back
	input wire wb_RegWrite_in,
	input wire wb_MemtoReg_in,
	//Memory
	input wire m_Branch_in,
	input wire m_MemRead_in,
	input wire m_MemWrite_in,
	/* Control signals OUTPUTS */
	output wire zero_out,
	//Write back
	output wire wb_RegWrite_out,
	output wire wb_MemtoReg_out,
	//Memory
	output wire m_Branch_out,
	output wire m_MemRead_out,
	output wire m_MemWrite_out
	);
	/* Data REGISTERS */
	reg [B-1:0]add_result_reg;
	reg [B-1:0]alu_result_reg;
	reg [B-1:0]r_data2_reg;
	reg [B-1:0]mux_RegDst_reg;
	/* Control REGISTERS */
	reg zero_reg;
	//Write back
	reg wb_RegWrite_reg;
	reg wb_MemtoReg_reg;
	//Memory
	reg m_Branch_reg;
	reg m_MemRead_reg;
	reg m_MemWrite_reg;
	
	always @(posedge clk)
	begin
		/* Data signals write to ID_EX register */
		add_result_reg <= add_result_in;
		alu_result_reg <= alu_result_in;
		r_data2_reg <= r_data2_in;
		mux_RegDst_reg <= mux_RegDst_in;
		/* Control signals write to ID_EX register */
		zero_reg <= zero_in;
		//Write back
		wb_RegWrite_reg <= wb_RegWrite_in;
		wb_MemtoReg_reg <= wb_MemtoReg_in;
		//Memory
		m_Branch_reg <= m_Branch_in;
		m_MemRead_reg <= m_MemRead_in;
		m_MemWrite_reg <= m_MemWrite_in;
		
	end
	/* Data signals read from ID_EX register */	
	assign add_result_out = add_result_reg;
	assign alu_result_out = alu_result_reg;
	assign r_data2_out = r_data2_reg;
	assign mux_RegDst_out = mux_RegDst_reg;
	
	/* Control signals read from ID_EX register */
	assign zero_out = zero_reg;
	//Write back
	assign wb_RegWrite_out = wb_RegWrite_reg;
	assign wb_MemtoReg_out = wb_MemtoReg_reg;
	//Memory
	assign m_Branch_out = m_Branch_reg;
	assign m_MemRead_out = m_MemRead_reg;
	assign m_MemWrite_out = m_MemWrite_reg;


endmodule
