`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:42:11 01/30/2016
// Design Name:   instruction_decode
// Module Name:   /home/poche002/Desktop/ArqComp/Trabajo_final/arquitectura_tpf/instruction_decode_tb.v
// Project Name:  arquitectura_tpf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instruction_decode
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module instruction_decode_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] pc_incrementado_in;
	reg [31:0] instruction;
	reg RegWrite;
	reg [4:0] address_write;
	reg [31:0] data_write;
	

	// Outputs
	wire [31:0] pc_incrementado_out;
	wire [31:0] reg_data1;
	wire [31:0] reg_data2;
	wire [31:0] sgn_extend_data_imm;
	wire [4:0] rd;
	wire [4:0] rt;
	wire wb_RegWrite_out;
	wire wb_MemtoReg_out;
	wire m_Branch_out;
	wire m_MemRead_out;
	wire m_MemWrite_out;
	wire ex_RegDst_out;
	wire ex_ALUOp0_out;
	wire ex_ALUOp1_out;
	wire ex_ALUSrc_out;

	// Instantiate the Unit Under Test (UUT)
	instruction_decode uut (
		.clk(clk), 
		.reset(reset), 
		.pc_incrementado_in(pc_incrementado_in), 
		.instruction(instruction), 
		.RegWrite(RegWrite), 
		.address_write(address_write), 
		.data_write(data_write), 
		.pc_incrementado_out(pc_incrementado_out), 
		.reg_data1(reg_data1), 
		.reg_data2(reg_data2), 
		.sgn_extend_data_imm(sgn_extend_data_imm), 
		.rd(rd), 
		.rt(rt), 
		.wb_RegWrite_out(wb_RegWrite_out), 
		.wb_MemtoReg_out(wb_MemtoReg_out), 
		.m_Branch_out(m_Branch_out), 
		.m_MemRead_out(m_MemRead_out), 
		.m_MemWrite_out(m_MemWrite_out), 
		.ex_RegDst_out(ex_RegDst_out), 
		.ex_ALUOp0_out(ex_ALUOp0_out), 
		.ex_ALUOp1_out(ex_ALUOp1_out), 
		.ex_ALUSrc_out(ex_ALUSrc_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		pc_incrementado_in = 0;
		instruction = 0;
		RegWrite = 0;
		address_write = 0;
		data_write = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#5
		begin
			pc_incrementado_in = 32'b00000000_00000000_00000000_00000100;
			instruction = 32'b00000000_00000000_00000000_00000000;
			address_write = 5'b00100;
			data_write = 1024;
		end
		#5 RegWrite = 1;
		#3 RegWrite = 0;
		#5 instruction = 32'b10001100_10000100_00000000_00000000;
		#5 instruction = 32'b10101100_10000100_00000000_00000000;
		#5 instruction = 32'b00010000_10000100_00000000_00000000;
	end
      
		always
			#1 clk=~clk;
			
endmodule

