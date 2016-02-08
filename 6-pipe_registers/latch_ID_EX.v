`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:01:09 01/26/2016 
// Design Name: 
// Module Name:    latch_ID_EX 
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
module latch_ID_EX
	#(
	parameter B=32,W=5
   )
	(
	input wire clk,
	input wire reset,
	/* Data signals INPUTS */
	input wire [B-1:0]pc_next_in,
	input wire [B-1:0]r_data1_in,
	input wire [B-1:0]r_data2_in,
	input wire [B-1:0]sign_ext_in,
	input wire [W-1:0]inst_20_16_in,
	input wire [W-1:0]inst_15_11_in,
	input wire [B-1:0] pc_jump_in,
	/* Data signals OUTPUTS */	
	output wire [B-1:0] pc_next_out,
	output wire [B-1:0] r_data1_out,
	output wire [B-1:0] r_data2_out,
	output wire [B-1:0] sign_ext_out,
	output wire [W-1:0] inst_20_16_out,
	output wire [W-1:0] inst_15_11_out,
	output wire [B-1:0] pc_jump_out,
	/* Control signals INPUTS*/
	//Write back
	input wire wb_RegWrite_in,
	input wire wb_MemtoReg_in,
	//Memory
	input wire m_Jump_in,
	input wire m_Branch_in,
	input wire m_MemRead_in,
	input wire m_MemWrite_in,
	//Execution
	input wire ex_RegDst_in,
	input wire [5:0] ex_ALUOp_in,
	input wire ex_ALUSrc_in,
	/* Control signals OUTPUTS */
	//Write back
	input wire wb_RegWrite_out,
	input wire wb_MemtoReg_out,
	//Memory
	input wire m_Jump_out,
	input wire m_Branch_out,
	input wire m_MemRead_out,
	input wire m_MemWrite_out,
	//Execution
	input wire ex_RegDst_out,
	input wire [5:0] ex_ALUOp_out,
	input wire ex_ALUSrc_out
	);
	/* Data REGISTERS */
	reg [B-1:0] pc_next_reg;
	reg [B-1:0] r_data1_reg;
	reg [B-1:0] r_data2_reg;
	reg [B-1:0] sign_ext_reg;
	reg [W-1:0] inst_20_16_reg;
	reg [W-1:0] inst_15_11_reg;
	reg [B-1:0] pc_jump_reg;
	/* Control REGISTERS */
	//Write back
	reg wb_RegWrite_reg;
	reg wb_MemtoReg_reg;
	//Memory
	reg m_Jump_reg;
	reg m_Branch_reg;
	reg m_MemRead_reg;
	reg m_MemWrite_reg;
	//Execution
	reg ex_RegDst_reg;
	reg [5:0] ex_ALUOp_reg;
	reg ex_ALUSrc_reg;
	
	always @(posedge clk, posedge reset)
	begin
		if (reset)
		begin
				pc_next_reg <= 0;
				r_data1_reg <= 0;
				r_data2_reg <= 0;
				sign_ext_reg <= 0;
				inst_20_16_reg <= 0;
				inst_15_11_reg <= 0;
				pc_jump_reg <=0;
				wb_RegWrite_reg <= 0;
				wb_MemtoReg_reg <= 0;
				m_Jump_reg <= 0;
				m_Branch_reg <= 0;
				m_MemRead_reg <= 0;
				m_MemWrite_reg <= 0;
				ex_RegDst_reg <= 0;
				ex_ALUOp_reg <= 0;
				ex_ALUSrc_reg <= 0;
		end
		else
		begin
		/* Data signals write to ID_EX register */
		pc_next_reg <= pc_next_in;
		r_data1_reg <= r_data1_in;
		r_data2_reg <= r_data2_in;
		sign_ext_reg <= sign_ext_in;
		inst_20_16_reg <= inst_20_16_in;
		inst_15_11_reg <= inst_15_11_in;
		pc_jump_reg <= pc_jump_in;
		
		/* Control signals write to ID_EX register */
		//Write back
		wb_RegWrite_reg <= wb_RegWrite_in;
		wb_MemtoReg_reg <= wb_MemtoReg_in;
		//Memory
		m_Jump_reg <= m_Jump_in;
		m_Branch_reg <= m_Branch_in;
		m_MemRead_reg <= m_MemRead_in;
		m_MemWrite_reg <= m_MemWrite_in;
		//Execution
		ex_RegDst_reg <= ex_RegDst_in;
		ex_ALUOp_reg <= ex_ALUOp_in;
		ex_ALUSrc_reg <= ex_ALUSrc_in;
		end
	end
	/* Data signals read from ID_EX register */	
	assign pc_next_out = pc_next_reg;
	assign r_data1_out = r_data1_reg;
	assign r_data2_out = r_data2_reg;
	assign sign_ext_out = sign_ext_reg;
	assign inst_20_16_out = inst_20_16_reg;
	assign inst_15_11_out = inst_15_11_reg;
	assign pc_jump_out = pc_jump_reg;
	
	/* Control signals read from ID_EX register */
	//Write back
	assign wb_RegWrite_out = wb_RegWrite_reg;
	assign wb_MemtoReg_out = wb_MemtoReg_reg;
	//Memory
	assign m_Jump_out = m_Jump_reg;
	assign m_Branch_out = m_Branch_reg;
	assign m_MemRead_out = m_MemRead_reg;
	assign m_MemWrite_out = m_MemWrite_reg;
	//Execution
	assign ex_RegDst_out = ex_RegDst_reg;
	assign ex_ALUOp_out = ex_ALUOp_reg;
	assign ex_ALUSrc_out = ex_ALUSrc_reg;
	
	
endmodule
