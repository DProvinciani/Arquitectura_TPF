`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:31:36 10/21/2015 
// Design Name: 
// Module Name:    uart_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_test
	(
	input wire clk, reset,// boton1,
	input wire rx,
	input wire btn,
	output wire tx,
	output wire [7:0] sseg, led
	);
	//signal declaration
	wire tx_full, rx_empty, btn_tick;
	wire [7:0] rec_data, rec_data1;
	//reg rx;
	
	//always @(posedge reset)
	//begin
	//	rx <= 0;
	//end

	//body 
	//instantiate uart
	uart uart_unit
		(.clk(clk), .reset(reset), .rd_uart(btn_tick), //.boton1(boton1),
		 .wr_uart(btn_tick), .rx(rx), .w_data(rec_data1),
		 .tx_full(tx_full), .rx_empty(rx_empty),
		 .r_data(rec_data), .tx(tx));
	//instantiate debounce circuit
	debounce btn_db_unit
		(.clk(clk), .reset(reset), .sw(btn),
		 .db_level(), .db_tick(btn_tick));
	//incremented data loops back
	assign rec_data1 = rec_data + 8'b0000_0001;
	// LED display
	assign led = rec_data;
	assign sseg = {1'b1, ~tx_full, 2'b11, ~rx_empty, 3'b111};  

endmodule
