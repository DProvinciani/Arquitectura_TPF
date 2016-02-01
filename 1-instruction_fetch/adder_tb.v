`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:07:18 01/29/2016
// Design Name:   adder
// Module Name:   /home/poche002/Desktop/ArqComp/Trabajo_final/arquitectura_tpf/adder_tb.v
// Project Name:  arquitectura_tpf
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
	reg [31:0] value1;
	//reg [31:0] value2;
	reg clk;

	// Outputs
	wire [31:0] result;

	// Instantiate the Unit Under Test (UUT)
	adder uut (
		.value1(value1), 
		.value2(1), 
		.clk(clk), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		value1 = 0;
		//value2 = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#10 value1=4;
		//#10 value2=2;
		
	end
	
	always
			#1 clk=~clk;

endmodule

