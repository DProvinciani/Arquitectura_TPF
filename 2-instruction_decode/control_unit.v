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
		output wire m_Branch_out,
		output wire m_MemRead_out,
		output wire m_MemWrite_out,
		//Execution
		output wire ex_RegDst_out,
		//output wire ex_ALUOp0_out,
		//output wire ex_ALUOp1_out,
		output wire ex_ALUOp_out,
		output wire ex_ALUSrc_out
    );
		
		reg [3:0] ex_ctrl_sgnl;   //aluop1, aluop0, regdst, alusrc
		reg [2:0] mem_ctrl_sgnl;	//branch, mem_read, mem_write 
		reg [1:0] wb_ctrl_sgnl;		//reg_write, mem_to_reg
		
		always @(posedge clk)
			begin
			case (opcode)
				6'b000_000: 			//R-Type
					begin
						ex_ctrl_sgnl <= 4'b1010;
						mem_ctrl_sgnl <= 3'b000;
						wb_ctrl_sgnl <= 2'b10;
					end
				6'b100_011:				//lw
					begin
						ex_ctrl_sgnl <= 4'b0001;
						mem_ctrl_sgnl <= 3'b010;
						wb_ctrl_sgnl <= 2'b11;
					end
				6'b101_011:				//sw
					begin
						ex_ctrl_sgnl <= 4'b0001;
						mem_ctrl_sgnl <= 3'b001;
						wb_ctrl_sgnl <= 2'b00;
					end
				6'b000_100:				//beq
					begin
						ex_ctrl_sgnl <= 4'b0100;
						mem_ctrl_sgnl <= 3'b100;
						wb_ctrl_sgnl <= 2'b00;
					end
				endcase
				end
		
		//Asignando las señales de control internas con las señales de salida
		//Execution
		//assign ex_ALUOp1_out = ex_ctrl_sgnl[3];
		//assign ex_ALUOp0_out = ex_ctrl_sgnl[2];
		assign ex_ALUOp_out = ex_ctrl_sgnl[3:2];
		assign ex_RegDst_out = ex_ctrl_sgnl[1];
		assign ex_ALUSrc_out = ex_ctrl_sgnl[0];
		//Memory
		assign m_Branch_out = mem_ctrl_sgnl[2];
		assign m_MemRead_out = mem_ctrl_sgnl[1];
		assign m_MemWrite_out = mem_ctrl_sgnl[0];
		//Write back
		assign wb_RegWrite_out = wb_ctrl_sgnl[1];
		assign wb_MemtoReg_out = wb_ctrl_sgnl[0];
		
endmodule
