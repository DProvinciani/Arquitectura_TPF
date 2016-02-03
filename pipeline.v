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
		parameter B=32 // ancho de la direccion (PC)
	)
	(
	input wire clk,
	input wire reset,
	//////////////////////////// FOR TESTING
	output wire [31:0] test_pc,
	output wire [31:0] test_fetched_instruction,
	output wire [31:0] test_fetched_instruction_post_IF_ID,
	output wire [31:0] test_read_data1,
	output wire [31:0] test_read_data2,
	output wire [31:0] test_sign_extended,
	output wire [31:0] test_add_result,
	output wire [31:0] test_alu_result,
	output wire [31:0] test_read_memory_data,
	//ID-EX
	////Control signals
	output wire test_wb_RegWrite_ID_EX_out,
	output wire test_wb_MemtoReg_ID_EX_out,
	output wire test_m_Branch_ID_EX_out,
	output wire test_m_MemRead_ID_EX_out,
	output wire test_m_MemWrite_ID_EX_out,
	output wire test_ex_RegDst_ID_EX_out,
	output wire [1:0] test_ex_ALUOp_ID_EX_out,
	output wire test_ex_ALUSrc_ID_EX_out,
	////Data signals
	output wire [31:0] test_pc_incrementado_ID_EX_out,
	output wire [31:0] test_data1_ID_EX_out,
	output wire [31:0] test_data2_ID_EX_out,
	output wire [31:0] test_sign_extended_ID_EX_out,
	output wire [4:0] test_inst_15_11_ID_EX_out,
	output wire [4:0] test_inst_20_16_ID_EX_out,
	//EX-MEM
	output wire [B-1:0] test_alu_result_EX_MEM_out,
	//MEM-WB
	output wire [4:0]  test_MEM_WB_mux_RegDst_EX_MEM_out
    );
	
	wire [B-1:0] add_result_EX_MEM_out; //Cable que viene desde la etapa MEM
	wire PCSrc;							//1 si tomamos el salto, 0 en caso contrario
	wire [B-1:0] IF_pc_incrementado; //salida del modulo IF
	wire [B-1:0] IF_instruction;		//salida del modulo IF
	wire [B-1:0] IF_TEST_pc_wire;		//SACAR!
	
	instruction_fetch IF(
		.clk(clk),
		.reset(reset),
		//Inputs
		////Data
		.pc_branch(add_result_EX_MEM_out),	
		////Control
		.PCSrc(PCSrc),
		//Outputs
		////Data
		.pc_incrementado(IF_pc_incrementado),
		.instruction(IF_instruction),
		.pc_wire(IF_TEST_pc_wire)			//SACAR!
    );
	
	//Seniales de salida de latch IF-ID
	wire [B-1:0] pc_incrementado_out;
	wire [B-1:0] instruction_out;
	
	latch_IF_ID IF_ID(
	//Input
	.clk(clk),
	.reset(reset),
	.pc_incrementado_in(IF_pc_incrementado),
	.instruction_in(IF_instruction),
	//Output
	.pc_incrementado_out(pc_incrementado_out),
	.instruction_out(instruction_out)
	);
	
	//Control signals input ID
	wire MEM_WB_wb_RegWrite_out;
	//Data signals input ID
	wire [B-1:0] WB_mux_memToReg_out;
	wire [4:0] MEM_WB_mux_RegDst_EX_MEM_out;
	//Data signals output ID
	wire [B-1:0] reg_data1_out;
	wire [B-1:0] reg_data2_out;
	wire [B-1:0] sgn_extend_data_imm_out;
	wire [4:0] rd_out;
	wire [4:0] rt_out;
	//Control signals output ID
	////WB
	wire wb_RegWrite_out;
	wire wb_MemtoReg_out;
	////MEM
	wire m_Branch_out;
	wire m_MemRead_out;
	wire m_MemWrite_out;
	////EX
	wire ex_RegDst_out;
	//wire ex_ALUOp0_out;
	//wire ex_ALUOp1_out;
	wire [1:0] ex_ALUOp_out;
	wire ex_ALUSrc_out;
	
	
	instruction_decode ID(
		.clk(clk),
		.reset(reset),
		//Control signals input
		.RegWrite(MEM_WB_wb_RegWrite_out),
		//Data signals input
		.instruction(instruction_out),
		.address_write(MEM_WB_mux_RegDst_EX_MEM_out),
		.data_write(WB_mux_memToReg_out),
		//Control signals output
		.wb_RegWrite_out(wb_RegWrite_out),
		.wb_MemtoReg_out(wb_MemtoReg_out),
		.m_Branch_out(m_Branch_out),
		.m_MemRead_out(m_MemRead_out),
		.m_MemWrite_out(m_MemWrite_out),
		.ex_RegDst_out(ex_RegDst_out),
		.ex_ALUOp_out(ex_ALUOp_out),
		.ex_ALUSrc_out(ex_ALUSrc_out),
		//Data signals output
		.reg_data1(reg_data1_out),
		.reg_data2(reg_data2_out),
		.sgn_extend_data_imm(sgn_extend_data_imm_out),
		.rd(rd_out),
		.rt(rt_out)
    );
	
	//ID-EX Control signals
	//wire wb_RegWrite_in;
	//wire wb_MemtoReg_in;
	//wire m_Branch_in;
	//wire m_MemRead_in;
	//wire m_MemWrite_in;
	//wire ex_RegDst_in;
	//wire [1:0] ex_ALUOp_in;
	//wire ex_ALUSrc_in;
	wire wb_RegWrite_ID_EX_out;
	wire wb_MemtoReg_ID_EX_out;
	wire m_Branch_ID_EX_out;
	wire m_MemRead_ID_EX_out;
	wire m_MemWrite_ID_EX_out;
	wire ex_RegDst_ID_EX_out;
	wire [1:0] ex_ALUOp_ID_EX_out;
	wire ex_ALUSrc_ID_EX_out;
	//ID-EX Data signals
	wire [B-1:0] pc_next_out;
	wire [B-1:0] r_data1_out;
	wire [B-1:0] r_data2_out;
	wire [B-1:0] sign_ext_out;
	wire [4:0] inst_20_16_out;
	wire [4:0] inst_15_11_out;

	
	latch_ID_EX ID_EX(
	.clk(clk),
	.reset(reset),
	//Control signals input
	.wb_RegWrite_in(wb_RegWrite_out),
	.wb_MemtoReg_in(wb_MemtoReg_out),
	.m_Branch_in(m_Branch_out),
	.m_MemRead_in(m_MemRead_out),
	.m_MemWrite_in(m_MemWrite_out),
	.ex_RegDst_in(ex_RegDst_out),
	.ex_ALUOp_in(ex_ALUOp_out),
	.ex_ALUSrc_in(ex_ALUSrc_out),
	//Data signals input
	.pc_next_in(pc_incrementado_out),
	.r_data1_in(reg_data1_out),
	.r_data2_in(reg_data2_out),
	.sign_ext_in(sgn_extend_data_imm_out),
	.inst_20_16_in(rt_out),
	.inst_15_11_in(rd_out),
	//Control signals output
	.wb_RegWrite_out(wb_RegWrite_ID_EX_out),
	.wb_MemtoReg_out(wb_MemtoReg_ID_EX_out),
	.m_Branch_out(m_Branch_ID_EX_out),
	.m_MemRead_out(m_MemRead_ID_EX_out),
	.m_MemWrite_out(m_MemWrite_ID_EX_out),
	.ex_RegDst_out(ex_RegDst_ID_EX_out),
	.ex_ALUOp_out(ex_ALUOp_ID_EX_out),
	.ex_ALUSrc_out(ex_ALUSrc_ID_EX_out),
	//Data signals output
	.pc_next_out(pc_next_out),
	.r_data1_out(r_data1_out),
	.r_data2_out(r_data2_out),
	.sign_ext_out(sign_ext_out),
	.inst_20_16_out(inst_20_16_out),
	.inst_15_11_out(inst_15_11_out)
	);
	
	wire [B-1:0] add_result_out;
	wire zero_out;
	wire [B-1:0] alu_result_out;
	wire [B-1:0] reg2Out_out;
	wire [4:0] muxRegDstOut_out;
	//wire [1:0] ex_ALUOp;
	
	third_step EX(
		//Control signals input
		.aluSrc(ex_ALUSrc_out),
		.ALUOp(ex_ALUOp_ID_EX_out),
		.regDst(ex_RegDst_out),
		//Data signals input
		.pcPlusFour(pc_next_out),
		.reg1(r_data1_out),
		.reg2(r_data2_out),
		.signExtend(sign_ext_out),
		.regDst1(inst_20_16_out),
		.regDst2(inst_15_11_out),
		/*Signal output*/
		.addResult(add_result_out),
		.zero(zero_out),
		.aluResult(alu_result_out),
		.reg2Out(reg2Out_out),
		.muxRegDstOut(muxRegDstOut_out)
    );
	
	wire [B-1:0] alu_result_EX_MEM_out;
	wire [B-1:0] r_data2_EX_MEM_out;
	wire zero_EX_MEM_out;
	wire wb_RegWrite_EX_MEM_out;
	wire wb_MemtoReg_EX_MEM_out;
	wire m_Branch_EX_MEM_out;
	wire m_MemRead_EX_MEM_out;
	wire m_MemWrite_EX_MEM_out;
	wire [4:0] mux_RegDst_EX_MEM_out;
	
//ACA NOS QUEDAMOS HAY MUCHOS ERRORES DE REPETIR LAS SEALES QUE ESTAMOS SOLUCIONANDO
	latch_EX_MEM EX_MEM(
	.clk(clk),
	.reset(reset),
	/* Data signals INPUTS */
	.add_result_in(add_result_out),
	.alu_result_in(alu_result_out),
	.r_data2_in(reg2Out_out),
	.mux_RegDst_in(muxRegDstOut_out),
	/* Control signals INPUTS*/
	.zero_in(zero_out),
	//Write back
	.wb_RegWrite_in(wb_RegWrite_ID_EX_out),
	.wb_MemtoReg_in(wb_MemtoReg_ID_EX_out),
	//Memory
	.m_Branch_in(m_Branch_ID_EX_out),
	.m_MemRead_in(m_MemRead_ID_EX_out),
	.m_MemWrite_in(m_MemWrite_ID_EX_out),
	/* Data signals OUTPUTS */
	.add_result_out(add_result_EX_MEM_out),
	.alu_result_out(alu_result_EX_MEM_out),
	.r_data2_out(r_data2_EX_MEM_out),
	.mux_RegDst_out(mux_RegDst_EX_MEM_out),
	/* Control signals OUTPUTS */
	.zero_out(zero_EX_MEM_out),
	//Write back
	.wb_RegWrite_out(wb_RegWrite_EX_MEM_out),
	.wb_MemtoReg_out(wb_MemtoReg_EX_MEM_out),
	//Memory
	.m_Branch_out(m_Branch_EX_MEM_out),
	.m_MemRead_out(m_MemRead_EX_MEM_out),
	.m_MemWrite_out(m_MemWrite_EX_MEM_out)
	);
	
	wire [B-1:0] MEM_data_out;
	
	data_access MEM(
		.clk(clk),
		//Control signals input
		.zero(zero_EX_MEM_out),
		.branch_in(m_Branch_EX_MEM_out),
		.mem_write(m_MemWrite_EX_MEM_out),
		//Data signals input
		.addr_in(alu_result_EX_MEM_out),
		.write_data(r_data2_EX_MEM_out),
		//Output
		.data_out(MEM_data_out),
		.branch_out(PCSrc)
    );
	
	wire [31:0] MEM_WB_read_data_out;
	wire [31:0] MEM_WB_alu_result_out;
	//wire [4:0] MEM_WB_mux_RegDst_out;
	/* Control signals OUTPUTS */
	//Write back
	wire MEM_WB_wb_MemtoReg_out;
	
	latch_MEM_WB MEM_WB(
		.clk(clk),
		.reset(reset),
		/* Data signals INPUTS */
		.read_data_in(MEM_data_out),
		.alu_result_in(alu_result_EX_MEM_out),
		.mux_RegDst_in(mux_RegDst_EX_MEM_out),
		/* Control signals INPUTS*/
		//Write back
		.wb_RegWrite_in(wb_RegWrite_EX_MEM_out),
		.wb_MemtoReg_in(wb_MemtoReg_EX_MEM_out),
		/* Data signals OUTPUTS */
		.read_data_out(MEM_WB_read_data_out),
		.alu_result_out(MEM_WB_alu_result_out),
		.mux_RegDst_out(MEM_WB_mux_RegDst_EX_MEM_out),
		/* Control signals OUTPUTS */
		//Write back
		.wb_RegWrite_out(MEM_WB_wb_RegWrite_out),
		.wb_MemtoReg_out(MEM_WB_wb_MemtoReg_out)
	);
	
	write_back WB(
	.clk(clk),
	.mem_data(MEM_WB_read_data_out),
	.ALU_data(MEM_WB_alu_result_out),
	.MemtoReg(MEM_WB_wb_MemtoReg_out),
	.data_out(WB_mux_memToReg_out)
	);
	
	assign test_pc = IF_TEST_pc_wire;
	assign test_fetched_instruction = IF_instruction;
	assign test_fetched_instruction_post_IF_ID = instruction_out;
	assign test_read_data1 = reg_data1_out;
	assign test_read_data2 = reg_data2_out;
	assign test_sign_extended = sgn_extend_data_imm_out;
	assign test_add_result = add_result_out;
	assign test_alu_result = alu_result_out;
	assign test_alu_result_EX_MEM_out = alu_result_EX_MEM_out;
	assign test_read_memory_data = MEM_data_out;
	assign test_MEM_WB_mux_RegDst_EX_MEM_out = MEM_WB_mux_RegDst_EX_MEM_out;
	assign test_inst_15_11_out = inst_15_11_out;
	assign test_inst_20_16_out = inst_20_16_out;
	
	//ID-EX
	////Control signals
	assign test_wb_RegWrite_ID_EX_out = wb_RegWrite_ID_EX_out;
	assign test_wb_MemtoReg_ID_EX_out = wb_MemtoReg_ID_EX_out;
	assign test_m_Branch_ID_EX_out = m_Branch_ID_EX_out;
	assign test_m_MemRead_ID_EX_out = m_MemRead_ID_EX_out;
	assign test_m_MemWrite_ID_EX_out = m_MemWrite_ID_EX_out;
	assign test_ex_RegDst_ID_EX_out = ex_RegDst_ID_EX_out;
	assign test_ex_ALUOp_ID_EX_out = ex_ALUOp_ID_EX_out;
	assign test_ex_ALUSrc_ID_EX_out = ex_ALUSrc_ID_EX_out;
	////Data signals
	assign test_pc_incrementado_ID_EX_out = pc_next_out;
	assign test_data1_ID_EX_out = r_data1_out;
	assign test_data2_ID_EX_out = r_data2_out;
	assign test_sign_extended_ID_EX_out = sign_ext_out;
	assign test_inst_15_11_ID_EX_out = inst_15_11_out;
	assign test_inst_20_16_ID_EX_out = inst_20_16_out;
	
endmodule
