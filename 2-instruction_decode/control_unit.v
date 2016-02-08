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
		/* Control signals OUTPUTS */
		//Write back
		output wire wb_RegWrite_out,
		output wire wb_MemtoReg_out,
		//Memory
		output wire m_Jump_out,
		output wire m_Branch_out,
		output wire m_MemRead_out,
		output wire m_MemWrite_out,
		//Execution
		output wire ex_RegDst_out,
		output wire [5:0] ex_ALUOp_out,
		output wire ex_ALUSrc_out
    );
		
		wire [7:0] ex_ctrl_sgnl;   //------------ aluop1, aluop0, regdst, alusrc
		wire [3:0] mem_ctrl_sgnl;	//jump, branch, mem_read, mem_write 
		wire [1:0] wb_ctrl_sgnl;	//reg_write, mem_to_reg
		
		//Asignando las señales de control internas con las señales de salida
		//Execution
		//Asignando las seÃ±ales de control internas con las seÃ±ales de salida
		//Execution
		assign ex_ctrl_sgnl = 	(opcode == 6'b000_000) ? 8'b00000010 : //R-type
										//I-Type
										(opcode == 6'b000_100) ? 8'b00010000 : //BEQ --> RegDst y ALUSrc ?
										(opcode == 6'b000_101) ? 8'b00010100 : //BNE --> RegDst y ALUSrc ?
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
										//J-Type
										(opcode == 6'b000_010) ? 8'b00000000 : //j
										8'b00000000;
		
		assign mem_ctrl_sgnl = 	(opcode == 6'b000_000) ? 4'b0000 :	//r-type
										(opcode == 6'b100_011) ? 4'b0010 :	//lw
										(opcode == 6'b101_011) ? 4'b0001 :	//sw
										(opcode == 6'b000_100) ? 4'b0100 :	//beq
										(opcode == 6'b000_010) ? 4'b1000 :	//jump
										4'b0000;
										
		assign wb_ctrl_sgnl = 	(opcode == 6'b000_000) ? 2'b10 :		//r-type
										(opcode == 6'b100_011) ? 2'b11 :		//lw
										(opcode == 6'b101_011) ? 2'b00 :		//sw
										(opcode == 6'b000_100) ? 2'b00 :		//beq
										(opcode == 6'b000_010) ? 2'b00 :		//jump
										2'b00;
		
		assign ex_ALUOp_out = ex_ctrl_sgnl[7:2];
		assign ex_RegDst_out = ex_ctrl_sgnl[1];
		assign ex_ALUSrc_out = ex_ctrl_sgnl[0];
		//Memory
		assign m_Jump_out = mem_ctrl_sgnl[3]; 
		assign m_Branch_out = mem_ctrl_sgnl[2];
		assign m_MemRead_out = mem_ctrl_sgnl[1];
		assign m_MemWrite_out = mem_ctrl_sgnl[0];
		//Write back
		assign wb_RegWrite_out = wb_ctrl_sgnl[1];
		assign wb_MemtoReg_out = wb_ctrl_sgnl[0];
		
endmodule
