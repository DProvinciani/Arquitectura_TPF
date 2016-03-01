`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:54:57 02/01/2016 
// Design Name: 
// Module Name:    pipeline 
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
module pipeline
	#(
		parameter B=32, // ancho de la direccion (PC)
		parameter W=5
	)
	(
		input wire clk,
		input wire reset,
		input wire ena,
		//PC
		output wire [B-1:0] test_pc_PC,
		output wire [B-1:0] test_pc_incrementado_PC,
		//IF
		////Datos
		output wire [B-1:0] test_instruction_IF,
		
		//IF-ID
		////Datos
		output wire [B-1:0] test_pc_incrementado_IF_ID,
		output wire [B-1:0] test_instruction_IF_ID,
		//ID
		////Datos
		output wire [B-1:0] test_data1_ID,
		output wire [B-1:0] test_data2_ID,
		output wire [B-1:0] test_sign_extend_ID,
		output wire [W-1:0] test_instruction_25_21_ID,    //RsD
		output wire [W-1:0] test_instruction_20_16_ID,    //RtD
		output wire [W-1:0] test_instruction_15_11_ID,
		output wire [B-1:0] test_pc_jump_ID,
		output wire [B-1:0] test_pc_Branch_ID,
		/*
		////Control
		//////WB
		output wire test_wb_RegWrite_ID,
		output wire test_wb_MemtoReg_ID,
		//////MEM
		output wire test_m_Jump_ID,
		output wire test_m_Branch_ID,
		output wire test_m_MemRead_ID,
		output wire test_m_MemWrite_ID,
		//////EX
		output wire test_ex_RegDst_ID,
		output wire [5:0] test_ex_ALUOp_ID,
		output wire test_ex_ALUSrc_ID,
		*/
		//ID-EX (salidas)
		////Control signals
		/*
		output wire test_wb_RegWrite_ID_EX_out,
		output wire test_wb_MemtoReg_ID_EX_out,
		output wire test_m_Jump_ID_EX_out,
		output wire test_m_Branch_ID_EX_out,
		output wire test_m_MemRead_ID_EX_out,
		output wire test_m_MemWrite_ID_EX_out,
		output wire test_ex_RegDst_ID_EX_out,
		output wire [5:0] test_ex_ALUOp_ID_EX_out,
		output wire test_ex_ALUSrc_ID_EX_out,
		*/
		////Data signals
		output wire [31:0] test_pc_incrementado_ID_EX_out,
		output wire [31:0] test_data1_ID_EX_out,
		output wire [31:0] test_data2_ID_EX_out,
		output wire [31:0] test_sign_extended_ID_EX_out,
		output wire [4:0] test_inst_15_11_ID_EX_out,
		output wire [4:0] test_inst_20_16_ID_EX_out,
		//output wire [4:0] test_inst_25_21_ID_EX_out,
		//output wire [1:0] test_ForwardAE,
		//output wire [1:0] test_ForwardBE,
		//output wire test_flushE,
		//output wire test_stallD,
		//output wire test_stallF,
		//output wire test_wb_MemtoReg_ID_EX,
		//output wire test_wb_MemtoReg_IDEX,
		//EX
		////Data signals
		output wire [B-1:0] test_alu_result_EX,
		output wire [B-1:0] test_reg_data2_EX,
		output wire [W-1:0] test_reg_dest_addr_EX,
		//EX-MEM
		////Data signals
		output wire [B-1:0] test_alu_result_EXMEM,
		output wire [B-1:0] test_reg_data2_EXMEM,
		////Control
		//output wire [5:0] test_opcode_EX_MEM,
		//output wire test_wb_MemtoReg_EXMEM,
		
		//MEM
		output wire [B-1:0] test_data_MEM,
		
		//MEM-WB
		output wire [B-1:0] test_mem_data_MEM_WB,
		output wire [B-1:0] test_alu_result_MEM_WB,
		output wire [4:0] test_reg_dest_addr_MEM_WB,
		////Control signals
		//output wire test_memToReg_MEM_WB,
		
		
		//WB
		////Data signals
		output wire [B-1:0] test_mux_wb_data_WB,
		
		//HZ
		////Control
		//output wire test_flushE_HZ,
		//output wire test_stallD_HZ,
		//output wire test_stallF_HZ,
		//output wire [1:0] test_ForwardAE_HZ,
		//output wire [1:0] test_ForwardBE_HZ,
		
		//Registros (datos en los registros)
		output wire [B-1:0] reg_0,
		output wire [B-1:0] reg_1,
		output wire [B-1:0] reg_2,
		output wire [B-1:0] reg_3,
		output wire [B-1:0] reg_4,
		output wire [B-1:0] reg_5,
		output wire [B-1:0] reg_6,
		output wire [B-1:0] reg_7,
		output wire [B-1:0] reg_8,
		output wire [B-1:0] reg_9,
		output wire [B-1:0] reg_10,
		output wire [B-1:0] reg_11,
		output wire [B-1:0] reg_12,
		output wire [B-1:0] reg_13,
		output wire [B-1:0] reg_14,
		output wire [B-1:0] reg_15,
		output wire [B-1:0] reg_16,
		output wire [B-1:0] reg_17,
		output wire [B-1:0] reg_18,
		output wire [B-1:0] reg_19,
		output wire [B-1:0] reg_20,
		output wire [B-1:0] reg_21,
		output wire [B-1:0] reg_22,
		output wire [B-1:0] reg_23,
		output wire [B-1:0] reg_24,
		output wire [B-1:0] reg_25,
		output wire [B-1:0] reg_26,
		output wire [B-1:0] reg_27,
		output wire [B-1:0] reg_28,
		output wire [B-1:0] reg_29,
		output wire [B-1:0] reg_30,
		output wire [B-1:0] reg_31
    );
	
	//outputs de modulos posteriores estan declarados aca porque hazard los necesita
   wire [W-1:0] instruction_25_21_IDEX; //RsE
   wire [W-1:0] instruction_20_16_IDEX; //RtE
   wire wb_RegWrite_EXMEM;
   wire wb_RegWrite_MEMWB;
   wire [W-1:0] reg_dest_addr_MEMWB;
   wire [W-1:0] reg_dest_addr_EXMEM;
   wire [W-1:0] reg_dest_addr_EX;
	wire [W-1:0] instruction_25_21_ID;    //RsD
   wire [W-1:0] instruction_20_16_ID;    //RtD
	wire branch_ID;
	wire branch_taken_ID;
	wire wb_RegWrite_IDEX;
	wire wb_MemtoReg_EXMEM;
	wire wb_MemtoReg_IDEX;
   wire [5:0] opcode_ID;
	wire [5:0] func_ID;
   //output hazard unit
   wire [1:0] ForwardAE_HZ;
   wire [1:0] ForwardBE_HZ;
   wire stallF_HZ;
   wire stallD_HZ;
   wire flushIDEX_HZ;
	wire flushIFID_HZ;
	wire ForwardAD_HZ;
	wire ForwardBD_HZ;

	//HZ
	Hazard_unit HU(
		 //Input
		 ////Data
		 .RsE(instruction_25_21_IDEX),
		 .RtE(instruction_20_16_IDEX),
		 .RsD(instruction_25_21_ID),
		 .RtD(instruction_20_16_ID),
		 .WriteRegM(reg_dest_addr_EXMEM),
		 .WriteRegWB(reg_dest_addr_MEMWB),
		 .Opcode(opcode_ID), //HZ j y b
		 .Func(func_ID),
		 .branch_ID(branch_ID),
		 .branch_taken_ID(branch_taken_ID),
		 .WriteRegEX(reg_dest_addr_EX),
		 .MemtoRegM(wb_MemtoReg_EXMEM),
		 ////Control
		 .RegWriteE(wb_RegWrite_IDEX),
		 .RegWriteM(wb_RegWrite_EXMEM),
		 .RegWriteWB(wb_RegWrite_MEMWB),
		 .MemtoRegEX(wb_MemtoReg_IDEX),
		 //Output
		 .ForwardAE(ForwardAE_HZ),
		 .ForwardBE(ForwardBE_HZ),
		 .stallF(stallF_HZ),
		 .stallD(stallD_HZ),
		 .flushIDEX(flushIDEX_HZ),
		 .flushIFID(flushIFID_HZ),
		 .ForwardAD(ForwardAD_HZ),
		 .ForwardBD(ForwardBD_HZ)
   );
	
	//PC
	////Input
	wire jump_ID;
	wire [B-1:0] pc_jump_ID;
	wire [B-1:0] pc_Branch_ID;
	////Output
	wire [B-1:0] pc_incrementado_PC; //salida del modulo PC
	wire [B-1:0] pc_PC;					//salida del modulo PC
	
	PC_counter PC(
		//inputs
		.clk(clk),
		.reset(reset),
		.ena(ena),
		.disa(stallF_HZ),
		.pc_branch(pc_Branch_ID), //PC para tomar el salto
		.pc_jump(pc_jump_ID),
		.PCSrc(branch_taken_ID), 				//Senial de control para elegir el PC
		.jump(jump_ID),
		//outputs
		.pc_out(pc_PC),					//salida que va a IF
		.pc_incrementado(pc_incrementado_PC)	//salida que va directo a IF/ID
   );
	
	//IF
	////Output
	wire [B-1:0] instruction_IF;		//salida del modulo IF
	
	instruction_fetch IF(
		.clk(clk),
		//Inputs
		////Data
		.pc(pc_PC),
		//Outputs
		////Data
		.instruction(instruction_IF)
    );
	
	//IF-ID
	//Data OUTPUT
	wire [B-1:0] pc_incrementado_IFID;
	wire [B-1:0] instruction_IFID;
	
	latch_IF_ID IF_ID(
		.clk(clk),
		.reset(reset),
		.ena(ena),
		.flush(flushIFID_HZ), //////////////////////////////Aca
		.disa(stallD_HZ),
		//Data INPUT
		.pc_incrementado_in(pc_incrementado_PC),
		.instruction_in(instruction_IF),
		//Data OUTPUT
		.pc_incrementado_out(pc_incrementado_IFID),
		.instruction_out(instruction_IFID)
	);
	
	//ID
	//Data INPUT
	wire [B-1:0] data_to_write_WB;
	wire [B-1:0] alu_result_EXMEM; //salida de EX_MEM
	wire [B-1:0] alu_result_EX;
	//wire [W-1:0] reg_dest_addr_MEMWB;
	//Control INPUT
	//wire wb_RegWrite_MEMWB;
	//Data OUTPUT
	wire [B-1:0] reg_data1_ID;
	wire [B-1:0] reg_data2_ID;
	wire [B-1:0] sgn_extend_ID;
	wire [W-1:0] instruction_15_11_ID; //RdD; RsD y RtD definidas mas arriba, las usa HZ 
	//Control OUTPUT
	////WB
	wire wb_RegWrite_ID;
	wire wb_MemtoReg_ID;
	////MEM
	wire m_BranchNot_ID;
	wire m_MemRead_ID;
	wire m_MemWrite_ID;
	////EX
	wire ex_RegDst_ID;
	wire [5:0] ex_ALUOp_ID;
	wire ex_ALUSrc_ID;
	
	instruction_decode ID(
		.clk(clk),
		.reset(reset),
		//Control INPUT
		.RegWrite(wb_RegWrite_MEMWB),
		//Hazards
		.ForwardAD(ForwardAD_HZ),
		.ForwardBD(ForwardBD_HZ),
		//.stallD(stallD_HZ),
		.alu_result_EX(alu_result_EX),
		.reg_muxes_b(alu_result_EXMEM),
		//Data INPUT
		.instruction(instruction_IFID),
		.pc_incrementado(pc_incrementado_IFID),
		.address_write(reg_dest_addr_MEMWB),
		.data_write(data_to_write_WB),
		//Control OUTPUT
		.wb_RegWrite_out(wb_RegWrite_ID),
		.wb_MemtoReg_out(wb_MemtoReg_ID),
		.jump_out(jump_ID),
		.branch_taken_out(branch_taken_ID),
		.branch_out(branch_ID),
		//.m_MemRead_out(m_MemRead_ID),
		.m_MemWrite_out(m_MemWrite_ID),
		.ex_RegDst_out(ex_RegDst_ID),
		.ex_ALUOp_out(ex_ALUOp_ID),
		.ex_ALUSrc_out(ex_ALUSrc_ID),
		.opcode_out(opcode_ID),
		.func_out(func_ID),
		//Data OUTPUT
		.reg_data1(reg_data1_ID),
		.reg_data2(reg_data2_ID),
		.sgn_extend_data_imm(sgn_extend_ID),
		.rd(instruction_15_11_ID),
		.rt(instruction_20_16_ID),
		.rs(instruction_25_21_ID),
		.pc_jump(pc_jump_ID),
		.addResult_Pc_Branch_D(pc_Branch_ID),
		//Registros
		.reg_0(reg_0),
		.reg_1(reg_1),
		.reg_2(reg_2),
		.reg_3(reg_3),
		.reg_4(reg_4),
		.reg_5(reg_5),
		.reg_6(reg_6),
		.reg_7(reg_7),
		.reg_8(reg_8),
		.reg_9(reg_9),
		.reg_10(reg_10),
		.reg_11(reg_11),
		.reg_12(reg_12),
		.reg_13(reg_13),
		.reg_14(reg_14),
		.reg_15(reg_15),
		.reg_16(reg_16),
		.reg_17(reg_17),
		.reg_18(reg_18),
		.reg_19(reg_19),
		.reg_20(reg_20),
		.reg_21(reg_21),
		.reg_22(reg_22),
		.reg_23(reg_23),
		.reg_24(reg_24),
		.reg_25(reg_25),
		.reg_26(reg_26),
		.reg_27(reg_27),
		.reg_28(reg_28),
		.reg_29(reg_29),
		.reg_30(reg_30),
		.reg_31(reg_31)
    );
	
	//ID-EX 
	////Control
	//wire wb_RegWrite_IDEX;
	//wire wb_MemtoReg_IDEX;
	//wire m_Jump_IDEX;
	//wire m_Branch_IDEX;
	//wire m_BranchNot_IDEX;
	//wire m_MemRead_IDEX;
	wire m_MemWrite_IDEX;
	wire ex_RegDst_IDEX;
	wire [5:0] ex_ALUOp_IDEX;
	wire ex_ALUSrc_IDEX;
	wire [5:0] opcode_IDEX;
	////Data
	wire [B-1:0] pc_incrementado_IDEX;
	wire [B-1:0] reg_data1_IDEX;
	wire [B-1:0] reg_data2_IDEX;
	wire [B-1:0] sgn_extend_IDEX;
	//wire [W-1:0] instruction_20_16_IDEX;
	wire [W-1:0] instruction_15_11_IDEX;
	//wire [B-1:0] pc_jump_IDEX;
	
	latch_ID_EX ID_EX(
		.clk(clk),
		.reset(reset),
		.ena(ena),
		.flush(flushIDEX_HZ),
		//Control signals input
		.wb_RegWrite_in(wb_RegWrite_ID),
		.wb_MemtoReg_in(wb_MemtoReg_ID),
		//.m_Jump_in(m_Jump_ID),
		//.m_Branch_in(m_Branch_ID),
		//.m_BranchNot_in(m_BranchNot_ID),
		//.m_MemRead_in(m_MemRead_ID),
		.m_MemWrite_in(m_MemWrite_ID),
		.ex_RegDst_in(ex_RegDst_ID),
		.ex_ALUOp_in(ex_ALUOp_ID),
		.ex_ALUSrc_in(ex_ALUSrc_ID),
		.opcode_in(opcode_ID),
		//Data signals input
		.pc_next_in(pc_incrementado_IFID),
		.r_data1_in(reg_data1_ID),
		.r_data2_in(reg_data2_ID),
		.sign_ext_in(sgn_extend_ID),
		.inst_25_21_in(instruction_25_21_ID),
		.inst_20_16_in(instruction_20_16_ID),
		.inst_15_11_in(instruction_15_11_ID),
		//.pc_jump_in(pc_jump_ID),
		//Control signals output
		.wb_RegWrite_out(wb_RegWrite_IDEX),
		.wb_MemtoReg_out(wb_MemtoReg_IDEX),
		//.m_Jump_out(m_Jump_IDEX),
		//.m_Branch_out(m_Branch_IDEX),
		//.m_BranchNot_out(m_BranchNot_IDEX),
		//.m_MemRead_out(m_MemRead_IDEX),
		.m_MemWrite_out(m_MemWrite_IDEX),
		.ex_RegDst_out(ex_RegDst_IDEX),
		.ex_ALUOp_out(ex_ALUOp_IDEX),
		.ex_ALUSrc_out(ex_ALUSrc_IDEX),
		.opcode_out(opcode_IDEX),
		//Data signals output
		.pc_next_out(pc_incrementado_IDEX),
		.r_data1_out(reg_data1_IDEX),
		.r_data2_out(reg_data2_IDEX),
		.sign_ext_out(sgn_extend_IDEX),
		.inst_25_21_out(instruction_25_21_IDEX),
		.inst_20_16_out(instruction_20_16_IDEX),
		.inst_15_11_out(instruction_15_11_IDEX)
		//.pc_jump_out(pc_jump_IDEX)
	);
	
	//EX
	////Data
	//wire [B-1:0] add_result_EX;
	wire zero_EX;
	wire [B-1:0] reg_data2_EX;
	//wire [W-1:0] reg_dest_addr_EX;
	
	third_step EX(
		//Control INPUT
		.aluSrc(ex_ALUSrc_IDEX),
		.ALUOp(ex_ALUOp_IDEX),
		.regDst(ex_RegDst_IDEX),
		//Data INPUT
		//.pcPlusFour(pc_incrementado_IDEX),
		.reg1(reg_data1_IDEX),
		.reg2(reg_data2_IDEX),
		.signExtend(sgn_extend_IDEX),
		.regDst1(instruction_20_16_IDEX),
		.regDst2(instruction_15_11_IDEX),
		//Agregado apra hazards
		.reg_muxes_b(data_to_write_WB),
		.reg_muxes_d(alu_result_EXMEM),
		.ForwardAE(ForwardAE_HZ),
		.ForwardBE(ForwardBE_HZ),
		//Data OUTPUT
		//.addResult(add_result_EX),
		//.zero(zero_EX),
		.aluResult(alu_result_EX),
		.reg2Out(reg_data2_EX),
		.muxRegDstOut(reg_dest_addr_EX)
    );
	
	//EX-MEM
	////Data
	//wire [B-1:0] alu_result_EXMEM;   //Definida mas arriba
	wire [B-1:0] reg_data2_EXMEM;
	//wire [W-1:0] reg_dest_addr_EXMEM; //Definida mas arriba
	
	////Control
	//wire zero_EXMEM;
	//wire wb_RegWrite_EXMEM;	//Definida mas arriba
	//wire wb_MemtoReg_EXMEM;	//Definida mas arriba	
	//wire m_Branch_EXMEM;
	//wire m_BranchNot_EXMEM;
	//wire m_MemRead_EXMEM;
	wire m_MemWrite_EXMEM;
	wire [5:0] opcode_EXMEM;
	
	latch_EX_MEM EX_MEM(
		.clk(clk),
		.reset(reset),
		.ena(ena),
		/* Data signals INPUT */
		//.add_result_in(add_result_EX),
		.alu_result_in(alu_result_EX),
		.r_data2_in(reg_data2_EX),
		.mux_RegDst_in(reg_dest_addr_EX),
		//.pc_jump_in(pc_jump_IDEX),
		/* Control signals INPUT*/
		//.zero_in(zero_EX),
		//Write back
		.wb_RegWrite_in(wb_RegWrite_IDEX),
		.wb_MemtoReg_in(wb_MemtoReg_IDEX),
		//Memory
		//.m_Jump_in(m_Jump_IDEX),
		//.m_Branch_in(m_Branch_IDEX),
		//.m_BranchNot_in(m_BranchNot_IDEX),
		//.m_MemRead_in(m_MemRead_IDEX),
		.m_MemWrite_in(m_MemWrite_IDEX),
		//Other
		.opcode_in(opcode_IDEX),
		/* Data signals OUTPUT */
		//.add_result_out(add_result_EXMEM),
		.alu_result_out(alu_result_EXMEM),
		.r_data2_out(reg_data2_EXMEM),
		.mux_RegDst_out(reg_dest_addr_EXMEM),
		//.pc_jump_out(pc_jump_EXMEM),
		/* Control signals OUTPUT */
		//.zero_out(zero_EXMEM),
		//Write back
		.wb_RegWrite_out(wb_RegWrite_EXMEM),
		.wb_MemtoReg_out(wb_MemtoReg_EXMEM),
		//Memory
		//.m_Jump_out(m_Jump_EXMEM),
		//.m_Branch_out(m_Branch_EXMEM),
		//.m_BranchNot_out(m_BranchNot_EXMEM),
		//.m_MemRead_out(m_MemRead_EXMEM),
		.m_MemWrite_out(m_MemWrite_EXMEM),
		//Other
		.opcode_out(opcode_EXMEM)
	);
	
	//MEM
	wire [B-1:0] data_MEM;
	
	data_access MEM(
		.clk(clk),
		//Control signals input
		//.zero(zero_EXMEM),
		//.branch_in(m_Branch_EXMEM),
		//.branchNot_in(m_BranchNot_EXMEM),
		.mem_write(m_MemWrite_EXMEM),
		.opcode(opcode_EXMEM),
		//Data signals input
		.addr_in(alu_result_EXMEM),
		.write_data(reg_data2_EXMEM),
		//Output
		.data_out(data_MEM)
		//.pcSrc_out(pcSrc_MEM)
    );
	
	//MEM-WB
	////Data
	wire [B-1:0] data_MEMWB;
	wire [B-1:0] alu_result_MEMWB;
	////Control
	wire wb_MemtoReg_MEMWB;
	
	latch_MEM_WB MEM_WB(
		.clk(clk),
		.reset(reset),
		.ena(ena),
		/* Data signals INPUTS */
		.read_data_in(data_MEM),
		.alu_result_in(alu_result_EXMEM),
		.mux_RegDst_in(reg_dest_addr_EXMEM),
		/* Control signals INPUTS*/
		//Write back
		.wb_RegWrite_in(wb_RegWrite_EXMEM),
		.wb_MemtoReg_in(wb_MemtoReg_EXMEM),
		/* Data signals OUTPUTS */
		.read_data_out(data_MEMWB),
		.alu_result_out(alu_result_MEMWB),
		.mux_RegDst_out(reg_dest_addr_MEMWB),
		/* Control signals OUTPUTS */
		//Write back
		.wb_RegWrite_out(wb_RegWrite_MEMWB),
		.wb_MemtoReg_out(wb_MemtoReg_MEMWB)
	);
	
	//WB
	
	write_back WB(
		//.clk(clk),
		//Data INPUT
		.mem_data(data_MEMWB),
		.ALU_data(alu_result_MEMWB),
		//Control INPUT
		.MemtoReg(wb_MemtoReg_MEMWB),
		//Data OUTPUT
		.data_out(data_to_write_WB)
	);
	
	//PC
	assign test_pc_incrementado_PC = pc_incrementado_PC;
	assign test_pc_PC = pc_PC;
	//IF
	////Datos
	assign test_instruction_IF = instruction_IF;
	
	//IF-ID (salidas)
	////Datos
	assign test_pc_incrementado_IF_ID = pc_incrementado_IFID;
	assign test_instruction_IF_ID = instruction_IFID;
	
	//ID (salidas)
	////Datos
	assign test_data1_ID = reg_data1_ID;
	assign test_data2_ID = reg_data2_ID;
	assign test_sign_extend_ID = sgn_extend_ID;
	assign test_pc_jump_ID = pc_jump_ID;
	assign test_pc_Branch_ID = pc_Branch_ID; 
	////Control
	//assign test_wb_RegWrite_ID = wb_RegWrite_ID;
	//assign test_wb_MemtoReg_ID = wb_MemtoReg_ID;
	//////MEM
	//assign test_m_Jump_ID = m_Jump_ID;
	//assign test_m_Branch_ID = m_Branch_ID;
	//assign test_m_MemRead_ID = m_MemRead_ID;
	//assign test_m_MemWrite_ID = m_MemWrite_ID;
	//////EX
	//assign test_ex_RegDst_ID = ex_RegDst_ID;
	//assign test_ex_ALUOp_ID = ex_ALUOp_ID;
	//assign test_ex_ALUSrc_ID = ex_ALUSrc_ID;
		
	//ID-EX (salidas)
	////Control signals
	//assign test_wb_RegWrite_ID_EX_out = wb_RegWrite_IDEX;
	//assign test_wb_MemtoReg_ID_EX_out = wb_MemtoReg_IDEX;
	//assign test_m_Jump_ID_EX_out = m_Jump_IDEX;
	//assign test_m_Branch_ID_EX_out = m_Branch_IDEX;
	//assign test_m_MemRead_ID_EX_out = m_MemRead_IDEX;
	//assign test_m_MemWrite_ID_EX_out = m_MemWrite_IDEX;
	//assign test_ex_RegDst_ID_EX_out = ex_RegDst_IDEX;
	//assign test_ex_ALUOp_ID_EX_out = ex_ALUOp_IDEX;
	//assign test_ex_ALUSrc_ID_EX_out = ex_ALUSrc_IDEX;
	////Data signals
	assign test_pc_incrementado_ID_EX_out = pc_incrementado_IDEX;
	assign test_data1_ID_EX_out = reg_data1_IDEX;
	assign test_data2_ID_EX_out = reg_data2_IDEX;
	assign test_sign_extended_ID_EX_out = sgn_extend_IDEX;
	assign test_inst_15_11_ID_EX_out = instruction_15_11_IDEX;
	assign test_inst_20_16_ID_EX_out = instruction_20_16_IDEX;
	//assign test_inst_25_21_ID_EX_out = instruction_25_21_IDEX;
	
	//EX
	////Data signals
	assign test_alu_result_EX = alu_result_EX;
	assign test_reg_data2_EX = reg_data2_EX;
	assign test_reg_dest_addr_EX = reg_dest_addr_EX;
	
	//EX-MEM
	////Data signals
	assign test_alu_result_EXMEM = alu_result_EXMEM;
	assign test_reg_data2_EXMEM = reg_data2_EXMEM;
	////Control
	//assign test_opcode_EX_MEM = opcode_EXMEM;
	
	//MEM
	assign test_data_MEM = data_MEM;
	
	//MEM-WB
	////Data signals
	assign test_mem_data_MEM_WB = data_MEMWB;
	assign test_alu_result_MEM_WB = alu_result_MEMWB;
	assign test_reg_dest_addr_MEM_WB = reg_dest_addr_MEMWB;
	////Control
	//assign test_memToReg_MEM_WB = wb_MemtoReg_MEMWB;
	
	//WB
	////Data signals
	assign test_mux_wb_data_WB = data_to_write_WB;
	
	//HZ
	//assign test_ForwardAE = ForwardAE_HZ;
	//assign test_ForwardBE = ForwardBE_HZ;
	//assign test_flushE_HZ = flushE_HZ;
	//assign test_stallF_HZ = stallF_HZ;
	//assign test_stallD_HZ = stallD_HZ;
	assign test_instruction_25_21_ID = instruction_25_21_ID;
	assign test_instruction_20_16_ID = instruction_20_16_ID;
	assign test_instruction_15_11_ID = instruction_15_11_ID;
	//assign test_wb_MemtoReg_IDEX = wb_MemtoReg_IDEX ;
	//assign test_wb_MemtoReg_EXMEM = wb_MemtoReg_EXMEM;
	
endmodule
