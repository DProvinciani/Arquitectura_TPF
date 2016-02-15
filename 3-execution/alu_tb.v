`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:52:00 02/15/2016
// Design Name:   alu
// Module Name:   D:/workspace-ISE/Pipeline/alu_tb.v
// Project Name:  Pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_tb;

	// Inputs
	reg [31:0] op1;
	reg [31:0] op2;
	reg [3:0] alu_control;

	// Outputs
	wire [31:0] result;
	wire zero;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.op1(op1), 
		.op2(op2), 
		.alu_control(alu_control), 
		.result(result), 
		.zero(zero)
	);

	initial begin
		// Initialize Inputs
		op1 = 32'b10000000000000000000000000000000;
		op2 = 32'b00000000000000000000000000000000;
		alu_control = 4'b1001;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		op2 = 32'b00000000000000000000000011000000;
		
		#50;
		
		op2 = 32'b00000000000000000000000000010000;
		alu_control = 4'b1100;

	end
      
endmodule

