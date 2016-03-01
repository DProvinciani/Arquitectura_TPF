`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:17:40 02/18/2016 
// Design Name: 
// Module Name:    tp_final 
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
module tp_final
	(
		input wire clk,
		input wire reset,
		//Debugger unit
		input wire rx,
		output wire tx,
		output wire [7:0] led
		
		//Para test
		//output wire ena_pip_test,
		//output wire [31:0] pc_incrementado_PC_out_test,
		//output wire [31:0] instruction_IF_test,
		//output wire [31:0] write_data_WB_out_test
		//output wire stallF_HZ_out_test
		//output wire [2:0] state_reg_test
	 );
		
		//Para test
		//assign ena_pip_test = ena_pip;
		//assign pc_incrementado_PC_out_test = pc_incrementado_PC_out;
		//assign instruction_IF_test = instruction_IF;
		//assign write_data_WB_out_test = write_data_WB_out;
		//assign stallF_HZ_out_test = stallF_HZ_out;
		
		//Debugger
		wire ena_pip;
		
		///////////////////////
		//Cables del pipeline//
		///////////////////////
		
		//PC
		wire [31:0] pc_incrementado_PC_out;
		
		//Modulo IF
		wire [31:0] pc_PC_out;
		wire [31:0] instruction_IF;
		
		//Modulo ID
		////Input
		wire [31:0] pc_incrementado_ID_in;
		wire [31:0] instruction_ID_in;
		wire [31:0] write_data_ID_in;
		wire [4:0] write_addr_ID_in;
		wire [31:0] alu_result_EX_in;
		//wire reg_write_ID_in;
		////Output
		wire [31:0] reg_data1_ID_out;
		wire [31:0] reg_data2_ID_out;
		wire [31:0] sign_extend_ID_out;
		wire [4:0] inst_25_21_ID_out;
		wire [4:0] inst_20_16_ID_out;
		wire [4:0] inst_15_11_ID_out;
		wire [31:0] pc_jump_ID_out;
		wire [31:0] pc_branch_ID_out;
		//wire [7:0] ex_aluOp_ID_out;
		//wire ex_aluSrc_ID_out;
		//wire ex_regDst_ID_out;
		//wire m_mem_write_ID_out;
		//wire m_branch_ID_out;
		//wire m_branchNot_ID_out;
		//wire m_jump_ID_out;
		//wire [5:0] m_opcode_ID_out;
		//wire wb_regWrite_ID_out;
		//wire wb_memToReg_ID_out;
		
		//Modulo EX
		wire [31:0] pc_incrementado_EX_in;
		wire [31:0] reg_data1_EX_in;
		wire [31:0] reg_data2_EX_in;
		wire [31:0] sign_extend_EX_in;
		wire [4:0] rt_EX_in;
		wire [4:0] rd_EX_in;
		//wire aluSrc_EX_in;
		//wire regDst_EX_in;
		//wire [7:0] aluOp_EX_in;
		//wire [31:0] add_result_EX_out;
		//wire [31:0] alu_result_EX_out;
		wire [31:0] reg_data2_EX_out;
		wire [4:0] rt_or_rd_EX_out;
		wire zero;
		
		//Modulo MEM
		wire [31:0] addres_MEM_in;
		wire [31:0] write_data_MEM_in;
		//wire mem_write_MEM_in;
		//wire [5:0] opcode_MEM_in;
		wire [31:0] read_data_MEM_out;
		
		//Modulo WB
		wire [31:0] mem_data_WB_in;
		wire [31:0] alu_result_WB_in;
		//wire memToReg_WB_in;
		wire [31:0] write_data_WB_out;
		
		//HZ
		////Control
		//output wire flushE_HZ_out;
		//output wire stallD_HZ_out;
		//wire stallF_HZ_out;
		//output wire [1:0] ForwardAE_HZ_out;
		//output wire [1:0] ForwardBE_HZ_out;
		
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
		
		debugger_unit db (
			.clk(clk), 
			.reset(reset), 
			.ena_pip(ena_pip),
			.led(led),
			.rx(rx), 
			.tx(tx),
			
			//PC
			.pc_incrementado_PC_out(pc_incrementado_ID_in),
			
			//Modulo IF
			////Input
			.pc_PC_out(pc_PC_out),
			////Output
			.instruction_IF_out(instruction_IF),
			
			//Modulo ID
			////Input
			.pc_incrementado_ID_in(pc_incrementado_ID_in), 
			.instruction_ID_in(instruction_ID_in), 
			.write_data_ID_in(write_data_ID_in), 
			.write_addr_ID_in(write_addr_ID_in), 
			.alu_result_EX_in(alu_result_EX_in),
			//.reg_write_ID_in(reg_write_ID_in),
			////Output
			.reg_data1_ID_out(reg_data1_ID_out), 
			.reg_data2_ID_out(reg_data2_ID_out), 
			.sign_extend_ID_out(sign_extend_ID_out), 
			.inst_25_21_ID_out(inst_25_21_ID_out),
			.inst_20_16_ID_out(inst_20_16_ID_out), 
			.inst_15_11_ID_out(inst_15_11_ID_out),
			.pc_jump_ID_out(pc_jump_ID_out),
			.pc_branch_ID_out(pc_branch_ID_out),
			//.ex_aluOp_ID_out(ex_aluOp_ID_out), 
			//.ex_aluSrc_ID_out(ex_aluSrc_ID_out), 
			//.ex_regDst_ID_out(ex_regDst_ID_out), 
			//.m_mem_write_ID_out(m_mem_write_ID_out), 
			//.m_branch_ID_out(m_branch_ID_out), 
			//.m_branchNot_ID_out(m_branchNot_ID_out), 
			//.jump_ID_out(m_jump_ID_out), 
			//.m_opcode_ID_out(m_opcode_ID_out), 
			//.wb_regWrite_ID_out(wb_regWrite_ID_out), 
			//.wb_memToReg_ID_out(wb_memToReg_ID_out), 
			
			//Modulo EX
			.pc_incrementado_EX_in(pc_incrementado_EX_in), 
			.reg_data1_EX_in(reg_data1_EX_in), 
			.reg_data2_EX_in(reg_data2_EX_in), 
			.sign_extend_EX_in(sign_extend_EX_in), 
			.rt_EX_in(rt_EX_in), 
			.rd_EX_in(rd_EX_in), 
			//.aluSrc_EX_in(aluSrc_EX_in), 
			//.regDst_EX_in(regDst_EX_in), 
			//.aluOp_EX_in(aluOp_EX_in), 
			//.add_result_EX_out(add_result_EX_out), 
			.alu_result_EX_out(alu_result_EX_in), 
			.reg_data2_EX_out(reg_data2_EX_out), 
			.rt_or_rd_EX_out(rt_or_rd_EX_out), 
			.zero(8'b0000_0000), 
			
			//Modulo MEM
			.addres_MEM_in(addres_MEM_in), 
			.write_data_MEM_in(write_data_MEM_in), 
			//.mem_write_MEM_in(mem_write_MEM_in), 
			//.opcode_MEM_in(opcode_MEM_in),  
			.read_data_MEM_out(read_data_MEM_out), 
			
			//WB
			.mem_data_WB_in(mem_data_WB_in), 
			.alu_result_WB_in(alu_result_WB_in), 
			//.memToReg_WB_in(memToReg_WB_in), 
			.write_data_WB_out(write_data_ID_in),
			
			//HZ
			//.stallF_HZ_out(stallF_HZ_out),
			
			//Registros
			.reg_0_out(reg_0_out),
			.reg_1_out(reg_1_out),
			.reg_2_out(reg_2_out),
			.reg_3_out(reg_3_out),
			.reg_4_out(reg_4_out),
			.reg_5_out(reg_5_out),
			.reg_6_out(reg_6_out),
			.reg_7_out(reg_7_out),
			.reg_8_out(reg_8_out),
			.reg_9_out(reg_9_out),
			.reg_10_out(reg_10_out),
			.reg_11_out(reg_11_out),
			.reg_12_out(reg_12_out),
			.reg_13_out(reg_13_out),
			.reg_14_out(reg_14_out),
			.reg_15_out(reg_15_out),
			.reg_16_out(reg_16_out),
			.reg_17_out(reg_17_out),
			.reg_18_out(reg_18_out),
			.reg_19_out(reg_19_out),
			.reg_20_out(reg_20_out),
			.reg_21_out(reg_21_out),
			.reg_22_out(reg_22_out),
			.reg_23_out(reg_23_out),
			.reg_24_out(reg_24_out),
			.reg_25_out(reg_25_out),
			.reg_26_out(reg_26_out),
			.reg_27_out(reg_27_out),
			.reg_28_out(reg_28_out),
			.reg_29_out(reg_29_out),
			.reg_30_out(reg_30_out),
			.reg_31_out(reg_31_out)
		);
		
		pipeline pip
		(
			.clk(clk),
			.reset(reset),
			.ena(ena_pip),
			
			//.test_pc_incrementado_PC(pc_incrementado_PC_out),
			
			//Modulo IF
			.test_pc_PC(pc_PC_out),
			.test_instruction_IF(instruction_IF),
			
			//Modulo ID
			////Input
			.test_pc_incrementado_PC(pc_incrementado_ID_in), 
			.test_instruction_IF_ID(instruction_ID_in), 
			.test_mux_wb_data_WB(write_data_ID_in), 
			.test_reg_dest_addr_MEM_WB(write_addr_ID_in), 
			.test_alu_result_EX(alu_result_EX_in),
			//.reg_write_ID_in(reg_write_ID_in),
			////Output
			.test_data1_ID(reg_data1_ID_out), 
			.test_data2_ID(reg_data2_ID_out), 
			.test_sign_extend_ID(sign_extend_ID_out), 
			.test_instruction_25_21_ID(inst_25_21_ID_out),
			.test_instruction_20_16_ID(inst_20_16_ID_out), 
			.test_instruction_15_11_ID(inst_15_11_ID_out),
			.test_pc_jump_ID(pc_jump_ID_out),
			.test_pc_Branch_ID(pc_branch_ID_out),
			
			//Modulo EX
			////Input
			.test_pc_incrementado_ID_EX_out(pc_incrementado_EX_in), 
			.test_data1_ID_EX_out(reg_data1_EX_in), 
			.test_data2_ID_EX_out(reg_data2_EX_in), 
			.test_sign_extended_ID_EX_out(sign_extend_EX_in), 
			.test_inst_20_16_ID_EX_out(rt_EX_in), 
			.test_inst_15_11_ID_EX_out(rd_EX_in), 
			////Output
			//.test_alu_result_EX(alu_result_EX_out), 
			.test_reg_data2_EX(reg_data2_EX_out), 
			.test_reg_dest_addr_EX(rt_or_rd_EX_out), 
			
			//Modulo MEM
			////Input
			.test_alu_result_EXMEM(addres_MEM_in), 
			.test_reg_data2_EXMEM(write_data_MEM_in), 
			////Output
			.test_data_MEM(read_data_MEM_out),
			
			//WB
			.test_mem_data_MEM_WB(mem_data_WB_in), 
			.test_alu_result_MEM_WB(alu_result_WB_in), 
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

endmodule
