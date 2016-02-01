`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:22:12 01/30/2016 
// Design Name: 
// Module Name:    data_access 
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
module data_access
	#(
		parameter B=32, // ancho de la direccion
		parameter W=5	//ancho de 
	)
	(
		input wire clk,
		/*Data signals input*/
		input wire [B-1:0] addr_in,
		input wire [B-1:0] write_data,
		/*Control signals input*/
		input wire mem_write,
		//input wire mem_read,
		input wire zero,
		input wire branch_in,
		/*Data signals output*/
		output wire [B-1:0] data_out,
		output wire [B-1:0] alu_out,
		/*Control signals output*/
		output wire branch_out
    );
		
		wire [3:0] we;
		assign we[3]=mem_write;
		assign we[2]=mem_write;
		assign we[1]=mem_write;
		assign we[0]=mem_write;
		
		dataMemory dm(	.clka(clk), 
							.rsta(0),
							.ena(1),
							.wea(we),
							.addra(addr_in),
							.dina(write_data),
							.douta(data_out));
	
		assign branch_out = zero && branch_in;
		assign alu_out = addr_in;

endmodule
