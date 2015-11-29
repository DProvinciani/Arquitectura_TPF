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
module instruction_decode(
	 input wire [31:0] instruction,
	 input wire clock,
	 input wire enable,
	 input wire reset,
	 output wire [31:0]reg_data1,
	 output wire [31:0]reg_data2,
	 output wire [31:0]sgn_data_imm,
	 output wire [4:0]rs,
	 output wire [4:0]rd,
	 output wire [5:0]ctrl_aluOp,
	 output wire ctrl_aluSrc
    );
	
	control_unit cu (.opcode(instruction[31:26]), .clk(clock), .ena(enable), .rst(reset) )
	reg_bank rb (.read_read_reg1(instruction[25:21]), .read_reg_reg2(instrction[20:16]), .write_reg(), .write_data(), .data1(), .data2())
	sig_extend sig(.reg_in(instruction[15:0]), .reg_out(sgn_data_imm))
	
		
	



endmodule
