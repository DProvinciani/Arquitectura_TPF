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
		/*Data signals input*/
		input wire [B-1:0] instruction,
		input wire [W-1:0] address_write,			//registro a escribir en el WB
		input wire [B-1:0] data_write,			//datos a escribir en el WB 
		input wire [B-1:0] pc_incrementado,
		
		//output wire [B-1:0] pc_incrementado_out,		//se pasa a la etapa ex
		/*Data signals output*/
		output wire [B-1:0]reg_data1,					//dato 1 del reg
		output wire [B-1:0]reg_data2,					//dato 2 del reg
		output wire [B-1:0]sgn_extend_data_imm,		//Inmediato de 32bits
		output wire [W-1:0]rd,
		output wire [W-1:0]rt,
		output wire [B-1:0] pc_jump,
		/* Control signals OUTPUTS */
		//Write back
		output wire wb_RegWrite_out,
		output wire wb_MemtoReg_out,
		//Memory
		output wire m_Jump_out,
		output wire m_Branch_out,
		output wire m_BranchNot_out,
		output wire m_MemRead_out,
		output wire m_MemWrite_out,
		//Execution
		output wire ex_RegDst_out,
		output wire [5:0] ex_ALUOp_out,
		output wire ex_ALUSrc_out,
		//Other
		output wire [5:0] opcode_out,
		
		//Para testing
		output wire [B-1:0] reg_16,
		output wire [B-1:0] reg_17,
		output wire [B-1:0] reg_18,
		output wire [B-1:0] reg_19,
		output wire [B-1:0] reg_20
    );
	
	wire jump;
	wire jr_jalr_out;
	wire [B-1:0] data1;
	wire [B-1:0] data2;
	
	assign opcode_out = instruction[31:26];
	
	control_unit cu (.clk(clk),
						  .opcode(instruction[31:26]),
						  .func(instruction[5:0]),
						  //Write back
						  .wb_RegWrite_out(wb_RegWrite_out),
						  .wb_MemtoReg_out(wb_MemtoReg_out),
						  //Memory
						  .m_Jump_out(jump),
						  .m_Branch_out(m_Branch_out),
						  .m_BranchNot_out(m_BranchNot_out),
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
								.reg_16(reg_16),
								.reg_17(reg_17),
								.reg_18(reg_18),
								.reg_19(reg_19),
								.reg_20(reg_20)
								);
	sig_extend sig(.reg_in(instruction[15:0]), 		//toma el inmediato de 16bits y le realiza
						.reg_out(sgn_extend_data_imm));	//la operacion de signo extendido
	
	assign rt = instruction[20:16];
	wire [W-1:0] rdaux;
	assign rdaux = instruction[15:11];
	assign m_Jump_out = jump;
	
	//Calc pc_j
	wire [B-1:0] pc_j;
	wire [B-1:0] shiftLeftOut;
	shift_left shiftModule(
    	.shift_in(instruction),
		.shift_out(shiftLeftOut)
    );
	assign pc_j = {pc_incrementado[31:28], shiftLeftOut[27:0]};
	
	//Select pc_j or pc_jr
	mux j_or_jr(
		.select(jr_jalr_out),
		.item_a(pc_j),
		.item_b(data1), //pc_jr se obtiene del dato1 del registro
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

endmodule
