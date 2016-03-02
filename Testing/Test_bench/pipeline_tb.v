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
	reg ena;
	integer ciclo;
	
	//HZ
	//wire [1:0] test_ForwardAE;
	//wire [1:0] test_ForwardBE;
	//wire test_stallF;
	//wire test_stallD;
	//wire test_flushE;
	//wire [4:0] test_instruction_25_21_ID;
	//wire [4:0] test_instruction_20_16_ID;
	//wire test_wb_MemtoReg_IDEX;
	
	//IF (salidas)
	////Datos
	wire [31:0] test_pc_PC;
	wire [31:0] test_pc_incrementado_PC;
	wire [31:0] test_instruction_IF;
	
	//IF-ID (salidas)
	////Datos
	wire [31:0] test_pc_incrementado_IF_ID;
	wire [31:0] test_instruction_IF_ID;
	

	////Datos
	wire [31:0] test_sign_extend_ID;
	
	//ID-EX
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
	wire [31:0] test_alu_result_EXMEM;
	
	//MEM-WB
	////Data signals
	wire [31:0] test_mem_data_MEM_WB;
	wire [4:0] test_reg_dest_addr_MEM_WB;
	
	//WB
	////Data signals
	wire [31:0] test_mux_wb_data_WB;
	
	//Registros
	wire [31:0] reg_0_out;
	wire [31:0] reg_1_out;
	wire [31:0] reg_2_out;
	wire [31:0] reg_3_out;
	wire [31:0] reg_4_out;
	wire [31:0] reg_5_out;
	wire [31:0] reg_6_out;
	wire [31:0] reg_7_out;
	wire [31:0] reg_8_out;
	wire [31:0] reg_9_out;
	wire [31:0] reg_10_out;
	wire [31:0] reg_11_out;
	wire [31:0] reg_12_out;
	wire [31:0] reg_13_out;
	wire [31:0] reg_14_out;
	wire [31:0] reg_15_out;
	wire [31:0] reg_16_out;
	wire [31:0] reg_17_out;
	wire [31:0] reg_18_out;
	wire [31:0] reg_19_out;
	wire [31:0] reg_20_out;
	wire [31:0] reg_21_out;
	wire [31:0] reg_22_out;
	wire [31:0] reg_23_out;
	wire [31:0] reg_24_out;
	wire [31:0] reg_25_out;
	wire [31:0] reg_26_out;
	wire [31:0] reg_27_out;
	wire [31:0] reg_28_out;
	wire [31:0] reg_29_out;
	wire [31:0] reg_30_out;
	wire [31:0] reg_31_out;
	
	
	// Instantiate the Unit Under Test (UUT)
	pipeline pip
		(
			.clk(clk),
			.reset(reset),
			.ena(ena),
			
			.test_pc_incrementado_PC(test_pc_incrementado_PC),
			
			//Modulo IF
			.test_pc_PC(test_pc_PC),
			.test_instruction_IF(test_instruction_IF),
			
			//Modulo ID
			////Input
			.test_pc_incrementado_IF_ID(test_pc_incrementado_IF_ID), 
			.test_instruction_IF_ID(test_instruction_IF_ID), 
			.test_mux_wb_data_WB(test_mux_wb_data_WB), 
			.test_reg_dest_addr_MEM_WB(test_reg_dest_addr_MEM_WB), 
			.test_alu_result_EX(test_alu_result_EX),
			//.reg_write_ID_in(reg_write_ID_in),
			////Output
			.test_data1_ID(test_data1_ID), 
			.test_data2_ID(test_data2_ID), 
			.test_sign_extend_ID(test_sign_extend_ID), 
			.test_instruction_25_21_ID(test_instruction_25_21_ID),
			.test_instruction_20_16_ID(test_instruction_20_16_ID), 
			.test_instruction_15_11_ID(test_instruction_15_11_ID),
			.test_pc_jump_ID(test_pc_jump_ID),
			.test_pc_Branch_ID(test_pc_Branch_ID),
			
			//Modulo EX
			////Input
			.test_pc_incrementado_ID_EX_out(test_pc_incrementado_ID_EX_out), 
			.test_data1_ID_EX_out(test_data1_ID_EX_out), 
			.test_data2_ID_EX_out(test_data2_ID_EX_out), 
			.test_sign_extended_ID_EX_out(test_sign_extended_ID_EX_out), 
			.test_inst_20_16_ID_EX_out(test_inst_20_16_ID_EX_out), 
			.test_inst_15_11_ID_EX_out(test_inst_15_11_ID_EX_out), 
			////Output
			//.test_alu_result_EX(alu_result_EX_out), 
			.test_reg_data2_EX(test_reg_data2_EX), 
			.test_reg_dest_addr_EX(test_reg_dest_addr_EX), 
			
			//Modulo MEM
			////Input
			.test_alu_result_EXMEM(test_alu_result_EXMEM), 
			.test_reg_data2_EXMEM(test_reg_data2_EXMEM), 
			////Output
			.test_data_MEM(test_data_MEM),
			
			//WB
			.test_mem_data_MEM_WB(test_mem_data_MEM_WB), 
			.test_alu_result_MEM_WB(test_alu_result_MEM_WB), 
			//.test_mux_wb_data_WB(write_data_WB_out),
			
			//HZ
			//.test_stallF_HZ(stallF_HZ_out),
			
			//Registros
			.reg_0(reg_0_out),
			.reg_1(reg_1_out),
			.reg_2(reg_2_out),
			.reg_3(reg_3_out),
			.reg_4(reg_4_out),
			.reg_5(reg_5_out),
			.reg_6(reg_6_out),
			.reg_7(reg_7_out),
			.reg_8(reg_8_out),
			.reg_9(reg_9_out),
			.reg_10(reg_10_out),
			.reg_11(reg_11_out),
			.reg_12(reg_12_out),
			.reg_13(reg_13_out),
			.reg_14(reg_14_out),
			.reg_15(reg_15_out),
			.reg_16(reg_16_out),
			.reg_17(reg_17_out),
			.reg_18(reg_18_out),
			.reg_19(reg_19_out),
			.reg_20(reg_20_out),
			.reg_21(reg_21_out),
			.reg_22(reg_22_out),
			.reg_23(reg_23_out),
			.reg_24(reg_24_out),
			.reg_25(reg_25_out),
			.reg_26(reg_26_out),
			.reg_27(reg_27_out),
			.reg_28(reg_28_out),
			.reg_29(reg_29_out),
			.reg_30(reg_30_out),
			.reg_31(reg_31_out)
		);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		ciclo = 0;
		ena = 1'b0;

		// Wait 100 ns for global reset to finish

		#2;
		begin
		reset = 1'b0;
		//ena = 1'b0;
		end
		#4
		ena = 1'b1;
		// Add stimulus here

	end
	
	always
		begin
			#1
			clk=~clk;
			#1
			clk=~clk;
			ciclo = ciclo + 1;
		end
      
endmodule

