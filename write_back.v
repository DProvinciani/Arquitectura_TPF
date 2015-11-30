`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:00:23 11/29/2015 
// Design Name: 
// Module Name:    write_back 
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
module write_back(
	input [31:0] data_in,	//dato que se obtiene de la memoria
	input [31:0] dir,			//datos que se van a escribir al bco de registros
									//esto lei del paper, yo entiendo que este es el input de
									//datos como resultado de algo que hizo la alu, y data_in
									//seria algo traido de ram.
	input mem_to_reg,			//activa el mux selecciona entre data_in(1) y dir(0)
	input rst,					//reset del modulo
	input clk,
	output [31:0] data_out	//datos de salida segun mem_to_reg
   );
	reg [31:0] data = 0;
	always@(posedge clk or posedge rst)
	if (rst == 1) 
		data <= 0;
	else
	begin
		if (mem_to_reg) 
			data <= data_in;
		else
			data <= dir;
	end
	
	assign data_out = data;
	
endmodule
