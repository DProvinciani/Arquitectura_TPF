`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:08:01 02/19/2016
// Design Name:   tp_final
// Module Name:   /home/poche002/Desktop/ArqComp/Trabajo_final/arquitectura_tpf/tp_final_tb.v
// Project Name:  arquitectura_tpf
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: tp_final
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tp_final_tb;

	// Inputs
	reg clk;
	reg reset;
	reg rx;

	// Outputs
	wire tx;
	
	//Para test
	//wire [1:0] op;
	//wire ena_pip_test;
	//wire [31:0] pc_PC_out_test;
	//wire [31:0] instruction_IF_test;
	//wire [31:0] write_data_WB_out_test;
	//wire stallF_HZ_out_test;
	//wire [2:0] state_reg_test;
	//wire rx_empty_test;
	//wire rx_done_tick_test;
	//wire [7:0] rx_data_out_test;
	//wire [7:0] write_data_test;
	//wire [3:0] byteN_test;
	//wire [7:0] reg_0;
	//wire [7:0] reg_1;
	//wire [7:0] reg_2;
	//wire [7:0] reg_3;
	
	//wire tick_test;
	integer ciclo;
	//wire [7:0] fifo_data;
	//wire fifo_full;
	//wire [1:0] state_test;
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	tp_final uut (
		.clk(clk),
		.reset(reset),
		.rx(rx), 
		.tx(tx),
		.led(led)
		//.op(op),
		//.ena_pip_test(ena_pip_test),
		//.pc_incrementado_PC_out_test(pc_PC_out_test),
		//.instruction_IF_test(instruction_IF_test),
		//.write_data_WB_out_test(write_data_WB_out_test)
		//.stallF_HZ_out_test(stallF_HZ_out_test)
		//.state_reg_test(state_reg_test)
		//.rx_empty_test(rx_empty_test),
		//.btn_read_reg_test(btn_read_reg_test),
		//.write_data_test(write_data_test),
		//.byteN_test(byteN_test)
		//.reg_0(reg_0),
		//.reg_1(reg_1),
		//.reg_2(reg_2),
		//.reg_3(reg_3),
		//.rx_done_tick_test(rx_done_tick_test),
		//.rx_data_out_test(rx_data_out_test),
		//.tick_test(tick_test),
		//.fifo_data(fifo_data),
		//.fifo_full(fifo_full),
		//.state_test(state_test)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rx = 1;
		reset = 0;
		ciclo= 0;

		// Wait 100 ns for global reset to finish
		#1 reset = 1;
		#1 reset = 0;
		//1 byte 0000_0010
		
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		
		#8000
		//0000_0010
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		
		#8000
		//0000_0010
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		
		#8000
		//0000_0010
		#64 rx=0;
		#64 rx=1;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		//0000_0011
		/*
		#64 rx=0;
		#64 rx=1;
		#64 rx=1;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=0;
		#64 rx=1;
		*/
		//#10000 reset = 1'b1;
		//#2 reset = 1'b0;
        
		// Add stimulus here

	end
	
	always
		begin
		#1
		clk=~clk;
		#1
		clk=~clk;
		ciclo = ciclo + 1;
      end
		
endmodule

