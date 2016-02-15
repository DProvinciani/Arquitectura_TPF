`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:39:03 10/18/2015 
// Design Name: 
// Module Name:    uart 
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
module uart
	#(	//Default setting:
		// 9600 baud, 8 data bits, 1 stop bit, 2 2 FIFO
		parameter 	DBIT = 8,		//Num of data bits
						SB_TICK = 16,	//Num of ticks for stop bits
						DVSR = 651,    //Baud rate divisor
											//DVSR = 100M/(16*baud_rate)
						DVSR_BIT = 8,	// Num bits of DVSR
						FIFO_W = 3		//Num addr bits of FIFO
											//Num words in FIFO=2^FIFO_W
	)
	(
		input wire clk, reset,// boton1,
		input wire rd_uart,rx, wr_uart,
		input wire [DBIT-1:0] w_data,
		output wire rx_empty, tx_full, tx,
		output wire [DBIT-1:0] r_data
    );
	 
	 //signal declaration
	wire tick, rx_done_tick, tx_done_tick;
	wire tx_empty, tx_fifo_not_empty;
	wire [DBIT-1:0] rx_data_out, tx_fifo_out;
	
	//body
	baud_rate_gen #(.M(DVSR)) baud_gen_unit
		(	.clk(clk), .reset(reset), .tick(tick));
	
	rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
		(	.clk(clk), .reset(reset), .rx(rx), .s_tick(tick), //.boton1(boton1),
			.rx_done_tick(rx_done_tick), .dout(rx_data_out));
	
	fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit
		(	.clk(clk), .reset(reset), .rd(rd_uart), 
			.wr(rx_done_tick), .w_data(rx_data_out),
			.empty(rx_empty), .full(), .r_data(r_data));
	
	fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit
		(	.clk(clk), .reset(reset), .rd(tx_done_tick),
			.wr(wr_uart), .w_data(w_data),
			.empty(tx_empty), .full(tx_full), .r_data(tx_fifo_out));
			
	tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
		(	.clk(clk), .reset(reset), .tx_start(tx_fifo_not_empty),
			.s_tick(tick), .data_in(tx_fifo_out), 
			.tx_done_tick(tx_done_tick), .tx(tx));
	
	assign tx_fifo_not_empty = ~tx_empty;

endmodule
