`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:07:10 01/18/2016
// Design Name:   registers_memory
// Module Name:   /home/avre/Documents/arquitectura/enero/instruction_memory/registers_memory_tb.v
// Project Name:  instruction_memory
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: registers_memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module registers_memory_tb;

	// Inputs
	reg clk;
	reg wr_en;
	reg [4:0] w_addr;
	reg [4:0] r_addr1;
	reg [4:0] r_addr2;
	reg [31:0] w_data;

	// Outputs
	wire [31:0] r_data1;
	wire [31:0] r_data2;
	// Instantiate the Unit Under Test (UUT)
	registers_memory uut (
		.clk(clk), 
		.wr_en(wr_en), 
		.w_addr(w_addr), 
		.r_addr1(r_addr1),
		.r_addr2(r_addr2),		
		.w_data(w_data), 
		.r_data1(r_data1),
		.r_data2(r_data2)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		wr_en = 0;
		w_addr = 0;
		r_addr1 = 0;
		r_addr2 = 1;
		w_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
		wr_en = 1; //escribo
		w_addr = 0;//escribo en el reg 0
		w_data = 25;//dato que escribo en reg 0
		#5 wr_en = 0; //leo
		#10
		wr_en = 1; //escribo
		w_addr = 1;//escribo en el reg 1
		r_addr1 = 0;//leo el reg 0
		r_addr2 = 1;//leo el reg 0
		w_data = 50;//dato que escribo en reg 0
		#5 wr_en = 0; //leo
		#10
		wr_en = 1; //escribo
		w_addr = 2;//escribo en el reg 1
		w_data = 100;//dato que escribo en reg 0
		#5 wr_en = 0; //leo
		#10
		wr_en = 1; //escribo
		w_addr = 3;//escribo en el reg 1
		w_data = 200;//dato que escribo en reg 0
		#5 wr_en = 0; //leo
		r_addr1 = 2;//leo el reg 0
		r_addr2 = 3;//leo el reg 0
		
		// Add stimulus here


	end
      always	//clock eterno
		begin
			#1
			clk=~clk;	
		end
endmodule

