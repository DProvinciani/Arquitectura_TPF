`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:05 01/29/2016 
// Design Name: 
// Module Name:    control_unit 
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
module control_unit
	#(
		parameter B=32 	// ancho de palabra de la instruccion
	)
	(
		input wire clk,
		input wire [5:0] opcode,
		input wire [5:0] func,
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
		//Jump
		output wire jr_jalr_out
    );
		
		wire [7:0] ex_ctrl_sgnl;   //------------ aluop1, aluop0, regdst, alusrc
		wire [4:0] mem_ctrl_sgnl;	//mem_read, mem_write, jump, branch, branchNot  
		wire [1:0] wb_ctrl_sgnl;	//reg_write, mem_to_reg
		wire jr_jalr_sgnl;
		
		//Asignando las señales de control internas con las señales de salida
		//Execution
		//Asignando las seÃ±ales de control internas con las seÃ±ales de salida
		//Execution
										//R-type
		assign ex_ctrl_sgnl = 	
										//I-Type
										(opcode == 6'b000_100) ? 8'b00010000 : //BEQ
										(opcode == 6'b000_101) ? 8'b00010100 : //BNE
										(opcode == 6'b001_000) ? 8'b00100001 : //ADDI
										(opcode == 6'b001_010) ? 8'b00101001 : //SLTI
										(opcode == 6'b001_100) ? 8'b00110001 : //ANDI
										(opcode == 6'b001_101) ? 8'b00110101 : //ORI
										(opcode == 6'b001_110) ? 8'b00111001 : //XORI
										(opcode == 6'b001_111) ? 8'b00111101 : //LUI
										(opcode == 6'b100_000) ? 8'b10000001 : //LB
										(opcode == 6'b100_001) ? 8'b10000101 : //LH
										(opcode == 6'b100_011) ? 8'b10001101 : //LW
										(opcode == 6'b100_100) ? 8'b10010001 : //LBU
										(opcode == 6'b100_101) ? 8'b10010101 : //LHU
										(opcode == 6'b100_111) ? 8'b10011101 : //LWU
										(opcode == 6'b101_000) ? 8'b10100001 : //SB
										(opcode == 6'b101_001) ? 8'b10100101 : //SH
										(opcode == 6'b101_011) ? 8'b10101101 : //SW 
										(opcode == 6'b000_010) ? 8'b00001010 : //J
										(opcode == 6'b000_011) ? 8'b00001110 : //JAL
										(	(func == 6'b000000) ? 8'b00000011 : //SLL
											(func == 6'b000010) ? 8'b00000011 : //SRL
											(func == 6'b000011) ? 8'b00000011 : //SRA
											//(func == 6'b000110) ? 8'b00000011 : //SRLV
											//(func == 6'b000111) ? 8'b00000011 : //SRAV
											//(func == 6'b000100) ? 8'b00000011 : //SLLV
											8'b00000010);
		
										//R-Type
		assign mem_ctrl_sgnl = 	(opcode == 6'b000_000) ? (	(func == 6'b001000) ? 5'b00001 :	//JR
																			(func == 6'b001001) ? 5'b00001 :	//JALR
																		  5'b00000) :  
										//I-Type
										(opcode == 6'b000_100) ? 5'b00100 : //BEQ
										(opcode == 6'b000_101) ? 5'b00010 : //BNE
										(opcode == 6'b001_000) ? 5'b00000 : //ADDI
										(opcode == 6'b001_010) ? 5'b00000 : //SLTI
										(opcode == 6'b001_100) ? 5'b00000 : //ANDI
										(opcode == 6'b001_101) ? 5'b00000 : //ORI
										(opcode == 6'b001_110) ? 5'b00000 : //XORI
										(opcode == 6'b001_111) ? 5'b00000 : //LUI
										(opcode == 6'b100_000) ? 5'b10000 : //LB
										(opcode == 6'b100_001) ? 5'b10000 : //LH
										(opcode == 6'b100_011) ? 5'b10000 : //LW
										(opcode == 6'b100_100) ? 5'b10000 : //LBU
										(opcode == 6'b100_101) ? 5'b10000 : //LHU
										(opcode == 6'b100_111) ? 5'b10000 : //LWU
										(opcode == 6'b101_000) ? 5'b01000 : //SB
										(opcode == 6'b101_001) ? 5'b01000 : //SH
										(opcode == 6'b101_011) ? 5'b01000 : //SW 
										(opcode == 6'b000_010) ? 5'b00001 : //J
										(opcode == 6'b000_011) ? 5'b00001 : //JAL
										5'b00000;
										
										//R-Type
		assign wb_ctrl_sgnl = 	(opcode == 6'b000_000) ? ((func == 6'b001000) ? 2'b00 : //JR
																		  2'b01) : 
										//I-Type
										(opcode == 6'b000_100) ? 2'b00 : //BEQ
										(opcode == 6'b000_101) ? 2'b00 : //BNE
										(opcode == 6'b001_000) ? 2'b01 : //ADDI
										(opcode == 6'b001_010) ? 2'b01 : //SLTI
										(opcode == 6'b001_100) ? 2'b01 : //ANDI
										(opcode == 6'b001_101) ? 2'b01 : //ORI
										(opcode == 6'b001_110) ? 2'b01 : //XORI
										(opcode == 6'b001_111) ? 2'b01 : //LUI
										(opcode == 6'b100_000) ? 2'b11 : //LB
										(opcode == 6'b100_001) ? 2'b11 : //LH
										(opcode == 6'b100_011) ? 2'b11 : //LW
										(opcode == 6'b100_100) ? 2'b11 : //LBU
										(opcode == 6'b100_101) ? 2'b11 : //LHU
										(opcode == 6'b100_111) ? 2'b11 : //LWU
										(opcode == 6'b101_000) ? 2'b00 : //SB
										(opcode == 6'b101_001) ? 2'b00 : //SH
										(opcode == 6'b101_011) ? 2'b00 : //SW 
										(opcode == 6'b000_010) ? 2'b00 : //J
										(opcode == 6'b000_011) ? 2'b01 : //JAL
										2'b00;
		
		assign jr_jalr_sgnl = 	(opcode == 6'b000_000) ? ((func == 6'b001000) ? 1'b1 :	//JR
																		  (func == 6'b001001) ? 1'b1 :	//JALR
																		  1'b0) :
										1'b0;
		
		//Ex
		assign ex_ALUOp_out = ex_ctrl_sgnl[7:2];
		assign ex_RegDst_out = ex_ctrl_sgnl[1];
		assign ex_ALUSrc_out = ex_ctrl_sgnl[0];
		//Memory
		assign m_MemRead_out = mem_ctrl_sgnl[4];
		assign m_MemWrite_out = mem_ctrl_sgnl[3];
		assign m_Branch_out = mem_ctrl_sgnl[2];
		assign m_BranchNot_out = mem_ctrl_sgnl[1];
		assign m_Jump_out = mem_ctrl_sgnl[0]; 
		
		//Write back
		assign wb_RegWrite_out = wb_ctrl_sgnl[0];
		assign wb_MemtoReg_out = wb_ctrl_sgnl[1];
		
		assign jr_jalr_out = jr_jalr_sgnl;
		
endmodule
