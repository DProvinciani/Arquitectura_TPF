`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:13:36 11/29/2015
// Design Name:   register_bank
// Module Name:   /home/poche002/Desktop/ArqComp/Trabajo_final/Arquitectura_TPF/register_bank_tb.v
// Project Name:  Arquitectura_TPF
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register_bank
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module register_bank_tb;

	// Inputs
	reg [4:0] dir_read1;
	reg [4:0] dir_read2;
	reg [4:0] dir_write;
	reg [31:0] write_data;
	reg wena;
	reg clk;
	reg rst;

	// Outputs
	wire [31:0] bus1;
	wire [31:0] bus2;

	// Instantiate the Unit Under Test (UUT)
	register_bank uut (
		.dir_read1(dir_read1), 
		.dir_read2(dir_read2), 
		.dir_write(dir_write), 
		.write_data(write_data), 
		.wena(wena), 
		.clk(clk), 
		.rst(rst), 
		.bus1(bus1), 
		.bus2(bus2)
	);

	initial begin
		// Initialize Inputs
		dir_read1 = 0;
		dir_read2 = 0;
		dir_write = 0;
		write_data = 0;
		wena = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 dir_write=5'b00001;
		#5 write_data=3;
		#5 wena=1'b1;
		#5 wena=1'b0;
		#5 
			begin
			dir_write=5'b00000;
		   write_data=0;
			end
		#5 dir_read1=5'b00001;
		#5 dir_read2=5'b00001;
		#5 dir_read1=5'b00011;
		#5 dir_read2=5'b00011;
		#5 dir_read1=5'b00000;
		#5 dir_read2=5'b00000;
	end
   
	always
		#1 clk=~clk;
	
endmodule

