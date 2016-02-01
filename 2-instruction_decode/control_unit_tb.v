`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:39:25 01/29/2016
// Design Name:   control_unit
// Module Name:   /home/poche002/Desktop/ArqComp/Trabajo_final/arquitectura_tpf/control_unit_tb.v
// Project Name:  arquitectura_tpf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_unit_tb;

	// Inputs
	reg clk;
	reg [31:0] instruction;

	// Outputs
	wire [3:0] ex_ctrl_sgnl;
	wire [2:0] mem_ctrl_sgnl;
	wire [1:0] wb_ctrl_sgnl;

	// Instantiate the Unit Under Test (UUT)
	control_unit uut (
		.clk(clk), 
		.instruction(instruction), 
		.ex_ctrl_sgnl(ex_ctrl_sgnl), 
		.mem_ctrl_sgnl(mem_ctrl_sgnl), 
		.wb_ctrl_sgnl(wb_ctrl_sgnl)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		instruction = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 instruction = 32'b00000000_00000000_00000000_00000000; 	//r-type
		#10 instruction = 32'b10001100_00000000_00000000_00000000; 	//lw
		#10 instruction = 32'b10101100_00000000_00000000_00000000;	//sw
		#10 instruction = 32'b00010000_00000000_00000000_00000000;	//beq
	end
     
	always
		#1 clk=~clk;
	
endmodule

