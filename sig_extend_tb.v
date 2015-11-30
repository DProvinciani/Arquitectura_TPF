`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:21:49 11/28/2015
// Design Name:   sig_extend
// Module Name:   /home/avre/Documents/arquitectura/Arquitectura_TPF/Arquitectura_TPF/sig_extend_tb.v
// Project Name:  Arquitectura_TPF
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sig_extend
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sig_extend_tb;

	// Inputs
	reg [15:0] reg_in;
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] reg_out;

	// Instantiate the Unit Under Test (UUT)
	sig_extend uut (
		.reg_in(reg_in), 
		.reg_out(reg_out), 
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		reg_in = 10;
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#1;
		reg_in = 15;
		#10
		reg_in = -20;
		#10
		reg_in = 50;
		#10
		reg_in = -32768;
		#10
		reg_in = 32767;
      #10
		reg_in = 0;
		#10
		reg_in = 1;
		#10
		reg_in = -1;		
		// Add stimulus here
		
	end
		always
		begin
			#1
			clk=~clk;	
		end
      
endmodule

