`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:13:54 11/29/2015 
// Design Name: 
// Module Name:    memory_access 
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
module memory_access(
		input [6:0] address, 	//indica la direccion que se va a leer o escribir
		input [31:0] write_data,//datos que se van a escribir a la memoria
		input mem_write,			//si es 1 se escribe en memoria, si es 0 se lee
		input reset,
		input clk,
		output [31:0] data_out 
    );
data_memory dm (
	.clka(clk),
	.wea(mem_write),
	.addra(address),
	.dina(write_data),
	.douta(data_out)
	);

endmodule
