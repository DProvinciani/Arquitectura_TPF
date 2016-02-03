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
	//	input wire [B-1:0] pc_incrementado_in,		//se pasa a la etapa ex
		input wire [B-1:0] instruction,
		input wire [W-1:0] address_write,			//registro a escribir en el WB
		input wire [B-1:0] data_write,			//datos a escribir en el WB 
		
		//output wire [B-1:0] pc_incrementado_out,		//se pasa a la etapa ex
		/*Data signals output*/
		output wire [B-1:0]reg_data1,					//dato 1 del reg
		output wire [B-1:0]reg_data2,					//dato 2 del reg
		output wire [B-1:0]sgn_extend_data_imm,		//Inmediato de 32bits
		output wire [W-1:0]rd,
		output wire [W-1:0]rt,
		/* Control signals OUTPUTS */
		//Write back
		output wire wb_RegWrite_out,
		output wire wb_MemtoReg_out,
		//Memory
		output wire m_Branch_out,
		output wire m_MemRead_out,
		output wire m_MemWrite_out,
		//Execution
		output wire ex_RegDst_out,
		output wire [1:0] ex_ALUOp_out,
		output wire ex_ALUSrc_out
    );
	
	control_unit cu (.clk(clk),
						  .opcode(instruction[31:26]), 
						  //Write back
						  .wb_RegWrite_out(wb_RegWrite_out),
						  .wb_MemtoReg_out(wb_MemtoReg_out),
						  //Memory
						  .m_Branch_out(m_Branch_out),
						  .m_MemRead_out(m_MemRead_out),
						  .m_MemWrite_out(m_MemWrite_out),
						  //Execution
						  .ex_RegDst_out(ex_RegDst_out),
						  .ex_ALUOp_out(ex_ALUOp_out),
						  .ex_ALUSrc_out(ex_ALUSrc_out)
						  );
	registers_memory rb (.clk(clk),
								.reset(reset),
								.wr_en(RegWrite),
								.r_addr1(instruction[25:21]), 
								.r_addr2(instruction[20:16]), 
								.w_addr(address_write), .w_data(data_write), 
								.r_data1(reg_data1), 
								.r_data2(reg_data2));
	sig_extend sig(.clk(clk),
						.reset(reset),
						.reg_in(instruction[15:0]), 		//toma el inmediato de 16bits y le realiza
						.reg_out(sgn_extend_data_imm));	//la operacion de signo extendido
	
	
	
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	//assign pc_incrementado_out = pc_incrementado_in;
	

endmodule
