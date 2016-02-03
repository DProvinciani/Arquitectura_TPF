`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:00:12 11/27/2015
// Design Name:   instruction_fetch
// Module Name:   D:/workspace-ISE/Pipeline/instruction_fetch_tb.v
// Project Name:  Pipeline
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
	reg [6:0] pc_in;
	reg enable;
	reg reset;
	reg clock;

	// Outputs
	wire [6:0] pc_next;
	wire [31:0] instruction;

	// Instantiate the Unit Under Test (UUT)
	instruction_fetch uut (
		.pc_in(pc_in), 
		.enable(enable), 
		.reset(reset), 
		.clock(clock), 
		.pc_next(pc_next), 
		.instruction(instruction)
	);

	initial begin
		// Initialize Inputs
		pc_in = 0;
		enable = 0;
		reset = 0;
		clock = 0;

		// Wait 100 ns for global reset to finish
		#50;
        enable = 1;
		#50;
		pc_in = 7'b0000000;
		clock = 1;
		#50;
		clock = 0;
		#50;
		pc_in = 7'b0000001;
		clock = 1;
		#50;
		clock = 0;
		#50;
		pc_in = 7'b0000010;
		clock = 1;
		#50;
		clock = 0;
		#50;
		pc_in = 7'b0000011;
		clock = 1;
		#50;
		clock = 0;
		#50;
		pc_in = 7'b0000100;
		clock = 1;
		#50;
		clock = 0;
		#50;
		pc_in = 7'b0000101;
		clock = 1;
		#50;
		clock = 0;
		#50;
		pc_in = 7'b0000110;
		clock = 1;
		#50;
		clock = 0;
		#50;
		pc_in = 7'b0000111;
		clock = 1;
		#50;
		clock = 0;
		// Add stimulus here
	end
	
//	always
//		begin
//			if (clock) clock = 0;
//			else clock = 1;
//		end
//	
//	always
//		begin
//			#100;
//			pc_in = 7'b0000000;
//			#100;
//			pc_in = 7'b0000001;
//			#100;
//			pc_in = 7'b0000010;
//			#100;
//			pc_in = 7'b0000011;
//			#100;
//			pc_in = 7'b0000100;
//			#100;
//			pc_in = 7'b0000101;
//			#100;
//			pc_in = 7'b0000110;
//			#100;
//			pc_in = 7'b0000111;
//		end
		
endmodule

