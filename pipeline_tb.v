`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:13:45 02/02/2016
// Design Name:   pipeline
// Module Name:   D:/workspace-ISE/Pipeline/pipeline_tb.v
// Project Name:  Pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pipeline_tb;

	// Inputs
	reg clk;
	reg reset;
	
	//IF (salidas)
	////Datos
	wire [31:0] test_pc_incrementado_IF;
	wire [31:0] test_instruction_IF;
	
	//IF-ID (salidas)
	////Datos
	wire [31:0] test_pc_incrementado_IF_ID;
	wire [31:0] test_instruction_IF_ID;
	
	//ID (salidas)
	////Control
	wire test_wb_RegWrite_ID;
	wire test_wb_MemtoReg_ID;
	//////MEM
	wire test_m_Branch_ID;
	wire test_m_MemRead_ID;
	wire test_m_MemWrite_ID;
	//////EX
	wire test_ex_RegDst_ID;
	wire [1:0] test_ex_ALUOp_ID;
	wire test_ex_ALUSrc_ID;
	////Datos
	wire [31:0] test_sign_extend_ID;
	
	//ID-EX
	////Control signals
	wire test_wb_RegWrite_ID_EX_out;
	wire test_wb_MemtoReg_ID_EX_out;
	wire test_m_Branch_ID_EX_out;
	wire test_m_MemRead_ID_EX_out;
	wire test_m_MemWrite_ID_EX_out;
	wire test_ex_RegDst_ID_EX_out;
	wire [1:0] test_ex_ALUOp_ID_EX_out;
	wire test_ex_ALUSrc_ID_EX_out;
	////Data signals
	wire [31:0] test_pc_incrementado_ID_EX_out;
	wire [31:0] test_data1_ID_EX_out;
	wire [31:0] test_data2_ID_EX_out;
	wire [31:0] test_sign_extended_ID_EX_out;
	wire [4:0] test_inst_15_11_ID_EX_out;
	wire [4:0] test_inst_20_16_ID_EX_out;
	
	//EX
	////Data signals
	wire [31:0] test_alu_result_EX;
		
	//EX-MEM
	////Data signals
	wire [31:0] test_alu_result_EX_MEM;
	
	//MEM-WB
	////Data signals
	wire [31:0] test_mem_data_MEM_WB;
	wire [4:1] test_reg_dest_addr_MEM_WB;
	////Control
	wire test_memToReg_MEM_WB;
	
	//WB
	////Data signals
	wire [31:0] test_mux_wb_data_WB;
	
	// Instantiate the Unit Under Test (UUT)
	pipeline uut (
		.clk(clk), 
		.reset(reset),
		//IF (salidas)
		////Datos
		.test_pc_incrementado_IF(test_pc_incrementado_IF),
		.test_instruction_IF(test_instruction_IF),
		
		//IF-ID (salidas)
		////Datos
		.test_pc_incrementado_IF_ID(test_pc_incrementado_IF_ID),
		.test_instruction_IF_ID(test_instruction_IF_ID),
		
		//ID (salidas)
		////Control
		.test_wb_RegWrite_ID(test_wb_RegWrite_ID),
		.test_wb_MemtoReg_ID(test_wb_MemtoReg_ID),
		//////MEM
		.test_m_Branch_ID(test_m_Branch_ID),
		.test_m_MemRead_ID(test_m_MemRead_ID),
		.test_m_MemWrite_ID(test_m_MemWrite_ID),
		//////EX
		.test_ex_RegDst_ID(test_ex_RegDst_ID),
		.test_ex_ALUOp_ID(test_ex_ALUOp_ID),
		.test_ex_ALUSrc_ID(test_ex_ALUSrc_ID),
		////Datos
		.test_sign_extend_ID(test_sign_extend_ID),
		
		//ID-EX
		////Control signals
		.test_wb_RegWrite_ID_EX_out(test_wb_RegWrite_ID_EX_out),
		.test_wb_MemtoReg_ID_EX_out(test_wb_MemtoReg_ID_EX_out),
		.test_m_Branch_ID_EX_out(test_m_Branch_ID_EX_out),
		.test_m_MemRead_ID_EX_out(test_m_MemRead_ID_EX_out),
		.test_m_MemWrite_ID_EX_out(test_m_MemWrite_ID_EX_out),
		.test_ex_RegDst_ID_EX_out(test_ex_RegDst_ID_EX_out),
		.test_ex_ALUOp_ID_EX_out(test_ex_ALUOp_ID_EX_out),
		.test_ex_ALUSrc_ID_EX_out(test_ex_ALUSrc_ID_EX_out),
		////Data signals
		.test_pc_incrementado_ID_EX_out(test_pc_incrementado_ID_EX_out),
		.test_data1_ID_EX_out(test_data1_ID_EX_out),
		.test_data2_ID_EX_out(test_data2_ID_EX_out),
		.test_sign_extended_ID_EX_out(test_sign_extended_ID_EX_out),
		.test_inst_15_11_ID_EX_out(test_inst_15_11_ID_EX_out),
		.test_inst_20_16_ID_EX_out(test_inst_20_16_ID_EX_out),
		
		//EX
		////Data signals
		.test_alu_result_EX(test_alu_result_EX),
		
		//EX-MEM
		////Data signals
		.test_alu_result_EX_MEM(test_alu_result_EX_MEM),
		
		//MEM-WB
		////Data signals
		.test_mem_data_MEM_WB(test_mem_data_MEM_WB),
		.test_reg_dest_addr_MEM_WB(test_reg_dest_addr_MEM_WB),
		////Control signals
		.test_memToReg_MEM_WB(test_memToReg_MEM_WB),
		
		//WB
		.test_mux_wb_data_WB(test_mux_wb_data_WB)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish

		#2;
		reset = 0;		
		// Add stimulus here

	end
	
	always
		begin
			#1
			clk=~clk;	
		end
      
endmodule

