`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:38:53 11/29/2015
// Design Name:   write_back
// Module Name:   /home/avre/Documents/arquitectura/Arquitectura_TPF/write_back_tb.v
// Project Name:  Arquitectura_TPF
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: write_back
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module write_back_tb;

	// Inputs
	reg [31:0] data_in;
	reg [31:0] dir;
	reg mem_to_reg;
	reg rst;
	reg clk;

	// Outputs
	wire [31:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	write_back uut (
		.data_in(data_in), 
		.dir(dir), 
		.mem_to_reg(mem_to_reg), 
		.rst(rst), 
		.clk(clk), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		data_in = 5;
		dir = 8;
		mem_to_reg = 0;
		rst = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
      #10 mem_to_reg =1;  
		// Add stimulus here

	end
      always
		begin
		#1 clk=~clk;
		end
		
endmodule

