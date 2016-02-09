`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:08:50 01/30/2016
// Design Name:   data_access
// Module Name:   /home/poche002/Desktop/ArqComp/Trabajo_final/arquitectura_tpf/data_access_tb.v
// Project Name:  arquitectura_tpf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: data_access
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module data_access_tb;

	// Inputs
	reg clk;
	reg [31:0] addr_in;
	reg [31:0] write_data;
	reg mem_write;
	reg zero;
	reg branch_in;
	reg branchNot_in;
	
	// Outputs
	wire [31:0] data_out;
	wire pcSrc_out;

	// Instantiate the Unit Under Test (UUT)
	data_access uut (
		.clk(clk), 
		.addr_in(addr_in), 
		.write_data(write_data), 
		.mem_write(mem_write), 
		.zero(zero), 
		.branch_in(branch_in),
		.branchNot_in(branchNot_in), 		
		.data_out(data_out), 
		.pcSrc_out(pcSrc_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		addr_in = 0;
		write_data = 0;
		mem_write = 0;
		zero = 0;
		branch_in = 0;
		branchNot_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#5 addr_in = 0;
		#5 addr_in = 4;
		#5 
		begin
			addr_in = 0;
			mem_write = 1'b1;
			write_data = 3;
			branch_in = 1;
			zero = 1;
		end
		#5 mem_write = 1'b0;
		#5 addr_in = 4;
		#5 
		begin
			zero = 0;
			branchNot_in = 1;
			addr_in = 4;
			mem_write = 1'b1;
			write_data = 7;
		end
		#5 mem_write = 1'b0;
		#5 addr_in=0;
		#5 addr_in=4;
		#5 branch_in=1;
		#5 zero=1;
	end
      
		always
			#1 clk=~clk;
		
endmodule

