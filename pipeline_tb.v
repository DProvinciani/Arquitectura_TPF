`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:13:45 02/02/2016
// Design Name:   pipeline
// Module Name:   D:/workspace-ISE/Pipeline/pipeline_tb.v
// Project Name:  Pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pipeline_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] test_pc;
	wire [31:0] test_fetched_instruction;
	wire [31:0] test_fetched_instruction_post_IF_ID;
	wire [31:0] test_read_data1;
	wire [31:0] test_read_data2;
	wire [31:0] test_sign_extended;
	wire [31:0] test_add_result;
	wire [31:0] test_alu_result;
	wire [31:0] test_read_memory_data;
	
	// Instantiate the Unit Under Test (UUT)
	pipeline uut (
		.clk(clk), 
		.reset(reset), 
		.test_pc(test_pc), 
		.test_fetched_instruction(test_fetched_instruction), 
		.test_fetched_instruction_post_IF_ID(test_fetched_instruction_post_IF_ID),
		.test_read_data1(test_read_data1), 
		.test_read_data2(test_read_data2), 
		.test_sign_extended(test_sign_extended), 
		.test_add_result(test_add_result), 
		.test_alu_result(test_alu_result), 
		.test_read_memory_data(test_read_memory_data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish

		#5;
		reset = 0;		
		// Add stimulus here

	end
	
	always
		begin
			#1
			clk=~clk;	
		end
      
endmodule

