`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:18:01 11/27/2015
// Design Name:   adder
// Module Name:   D:/workspace-ISE/Pipeline/adder_tb.v
// Project Name:  Pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adder_tb;

	// Inputs
	reg [6:0] pc;

	// Outputs
	wire [6:0] pc_next;

	// Instantiate the Unit Under Test (UUT)
	adder uut (
		.pc(pc), 
		.pc_next(pc_next)
	);

	initial begin
		// Initialize Inputs
		pc = 7'b0000000;
		#100;
        pc = 7'b0000001;
		#100;
		pc = 7'b0000010;
		#100;
		pc = 7'b0000011;
		#100;
		pc = 7'b0000100;
		#100;
		pc = 7'b0000101;
		#100;
		pc = 7'b0000110;
		#100;
		pc = 7'b0000111;
		#100;
		pc = 7'b0001000;
		#100;
		pc = 7'b1111111;
		#100;
		// Add stimulus here

	end
      
endmodule

