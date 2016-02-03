`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:47:57 01/29/2016
// Design Name:   instruction_fetch
// Module Name:   /home/poche002/Desktop/ArqComp/Trabajo_final/arquitectura_tpf/instruction_fetch_tb.v
// Project Name:  arquitectura_tpf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instruction_fetch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module instruction_fetch_tb;

	// Inputs
	reg [31:0] pc_branch;
	reg PCSrc;
	reg reset;
	reg clk;

	// Outputs
	wire [31:0] pc_incrementado;
	wire [31:0] instruction;
	wire [31:0] pc_wire;

	// Instantiate the Unit Under Test (UUT)
	instruction_fetch uut (
		.pc_branch(pc_branch), 
		.PCSrc(PCSrc), 
		.reset(reset), 
		.clk(clk), 
		.pc_incrementado(pc_incrementado), 
		.instruction(instruction),
		.pc_wire(pc_wire)
	);

	initial begin
		// Initialize Inputs
		pc_branch = 0;
		PCSrc = 0;
		reset = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
      	
		// Add stimulus here
		#10 reset = 1;
		#5 reset = 0;
		//#5 pc_branch = 10;
		//#5 PCSrc = 1;
		//#5 PCSrc = 0;

	end
		
		always
			#1 clk=~clk;
		
		
endmodule

