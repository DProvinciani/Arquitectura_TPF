`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:16:49 11/28/2015 
// Design Name: 
// Module Name:    instruction_decode 
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
module instruction_decode
	#(
		parameter B=32, 	// ancho de palabra de los registros y la instruccion
		parameter W=5		// cantidad de bits de direccion de registros
	)
	(
		input wire clk,
		input wire reset,
		/*Control signals input*/
		input wire RegWrite,					//Señal de control de WB
		//Hazards signals
		input wire [B-1:0] alu_result_EX,
		input wire ForwardAD,
		input wire ForwardBD,
		input wire stallD,
		
		/*Data signals input*/
		input wire [B-1:0] instruction,
		input wire [W-1:0] address_write,			//registro a escribir en el WB
		input wire [B-1:0] data_write,			//datos a escribir en el WB 
		input wire [B-1:0] pc_incrementado,
		input wire [B-1:0] reg_muxes_b,		//para los muxes de branch
		
		//output wire [B-1:0] pc_incrementado_out,		//se pasa a la etapa ex
		/*Data signals output*/
		output wire [B-1:0] reg_data1,					//dato 1 del reg
		output wire [B-1:0] reg_data2,					//dato 2 del reg
		output wire [B-1:0] sgn_extend_data_imm,		//Inmediato de 32bits
		output wire [W-1:0] rd,
		output wire [W-1:0] rt,
		output wire [W-1:0] rs,
		output wire [B-1:0] pc_jump,
		output wire [B-1:0] addResult_Pc_Branch_D,		//PcBranchD que va a PC
		/* Control signals OUTPUTS */
		//Write back
		output wire wb_RegWrite_out,
		output wire wb_MemtoReg_out,
		//Memory
		output wire branch_out,
		output wire branch_taken_out,
		output wire jump_out,
		output wire m_MemRead_out,
		output wire m_MemWrite_out,
		//Execution
		output wire ex_RegDst_out,
		output wire [5:0] ex_ALUOp_out,
		output wire ex_ALUSrc_out,
		//Other
		output wire [5:0] opcode_out,
		output wire [5:0] func_out,
		
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
	
	wire jump;
	wire jr_jalr_out;
	wire [B-1:0] data1;
	wire [B-1:0] data2;
	//para hazards
	wire [B-1:0] mux_reg1_out;
	wire [B-1:0] mux_reg2_out;
	wire comparador;
	
	wire branch_signal;
	wire branchNot_signal;
	assign branch_out = branch_signal | branchNot_signal;
	
	
	assign opcode_out = instruction[31:26];
	assign func_out = instruction[5:0];
	
	control_unit cu (.clk(clk),
						  .opcode(instruction[31:26]),
						  .func(instruction[5:0]),
						  //Write back
						  .wb_RegWrite_out(wb_RegWrite_out),
						  .wb_MemtoReg_out(wb_MemtoReg_out),
						  //Memory
						  .m_Jump_out(jump),
						  .m_Branch_out(branch_signal),
						  .m_BranchNot_out(branchNot_signal),
						  .m_MemRead_out(m_MemRead_out),
						  .m_MemWrite_out(m_MemWrite_out),
						  //Execution
						  .ex_RegDst_out(ex_RegDst_out),
						  .ex_ALUOp_out(ex_ALUOp_out),
						  .ex_ALUSrc_out(ex_ALUSrc_out),
						  //Other
						  .jr_jalr_out(jr_jalr_out)
						  );
	registers_memory rb (.clk(clk),
								.reset(reset),
								.wr_en(RegWrite),
								.r_addr1(instruction[25:21]), 
								.r_addr2(instruction[20:16]), 
								.w_addr(address_write), .w_data(data_write), 
								.r_data1(data1), 
								.r_data2(data2),
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
	sig_extend sig(.reg_in(instruction[15:0]), 		//toma el inmediato de 16bits y le realiza
						.reg_out(sgn_extend_data_imm));	//la operacion de signo extendido
	
	assign rt = instruction[20:16];
	assign rs = instruction[25:21];
	wire [W-1:0] rdaux;
	assign rdaux = instruction[15:11];
	assign jump_out = jump;
	
	//Calc pc_j
	wire [B-1:0] pc_j;
	wire [B-1:0] shiftLeftOut;
	shift_left shiftModule(
    	.shift_in(instruction),
		.shift_out(shiftLeftOut)
    );
	assign pc_j = {pc_incrementado[31:28], shiftLeftOut[27:0]};
	
	wire Forward;	
	wire [31:0] jump_forwarded;
	assign Forward = (ForwardAD == 1'b1 | ForwardBD == 1'b1)? 1'b1:1'b0;
	mux jr_forwarded(
		.select(Forward),
		.item_a(data1),
		.item_b(alu_result_EX), //pc_jr se obtiene del dato1 del registro
		.signal(jump_forwarded)
	);
	
	//Select pc_j or pc_jr
	mux j_or_jr(
		.select(jr_jalr_out),
		.item_a(pc_j),
		.item_b(jump_forwarded), //pc_jr se obtiene del dato1 del registro
		.signal(pc_jump)
	);
	
	//PC+4 or data1
	mux pc_or_data1(
		.select(jump),
		.item_a(data1),
		.item_b(pc_incrementado),
		.signal(reg_data1)
	);
	//4 or data2
	mux four_or_data2(
		.select(jump),
		.item_a(data2),
		.item_b(32'b00000000_00000000_00000000_00000100),
		.signal(reg_data2)
	);
	
	//rd or 31
	wire sel;
	assign sel = jump&(~jr_jalr_out);
	mux #(5) rd_or_31(
		.select(sel),
		.item_a(rdaux),
		.item_b(5'b11111), //31
		.signal(rd)
	);
	
	mux mux_reg_1(
		.select(ForwardAD),
		.item_a(reg_data1),
		.item_b(reg_muxes_b),
		.signal(mux_reg1_out)
	);
		
	mux mux_reg_2(
		.select(ForwardBD),
		.item_a(reg_data2),
		.item_b(reg_muxes_b),
		.signal(mux_reg2_out)
	);

	wire [B-1:0] shiftLeftOutBranch;
	
	shift_left shiftModuleBranch(
    	.shift_in(sgn_extend_data_imm),
		.shift_out(shiftLeftOutBranch)
    );

	adder #(32) adderModule(
		.value1(pc_incrementado),
		.value2(shiftLeftOutBranch),
		.result(addResult_Pc_Branch_D)
	);
		
	//si los registros son iguales comparador = 1, si no 0
	assign comparador = (mux_reg1_out == mux_reg2_out) ? 1'b1 : 1'b0;
	wire and_BEQ;
	//si comparador dio 1 y es Branch equal
	assign and_BEQ = branch_signal & comparador;
	
	wire and_BNE; 
	assign and_BNE = branchNot_signal & (~comparador);
	assign branch_taken_out = (and_BEQ | and_BNE); //& (~stallD); si esta al pedo hay que sacar este cable
	
endmodule
