`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:55 02/11/2016 
// Design Name: 
// Module Name:    PC_counter 
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
module PC_counter
	#(
		parameter B=32 // ancho de la direccion (PC)
	)
	(
	input wire clk,
	input wire reset,
	input wire disa,
	input wire [B-1:0] pc_branch, //PC para tomar el salto
	input wire [B-1:0] pc_jump,
	input wire PCSrc, 				//Senial de control para elegir el PC
	input wire jump,
	output wire [B-1:0] pc_out,
	output wire [B-1:0] pc_incrementado
   );
	reg [B-1:0] pc;	//registro PC
	
	//mux mux_pc_src(.item_a(pc_incrementado), .item_b(pc_branch), .select(PCSrc), .signal(pc_wire));
	adder add (
		.value1(pc),
		.value2(4),
		.result(pc_incrementado)
		);

	always@(posedge clk)
	if (reset == 1) 
		pc <= 0;		//Si entro por reset, resetea el PC
	else if (disa == 1)
		pc <= pc;//do nothing
	else
	begin
		if (PCSrc == 1) pc <= pc_branch;
		else if (jump == 1) pc <= pc_jump;
		else pc <= pc_incrementado;			//Si entro por clk, actualiza el PC con el nuevo valor
	end
	assign pc_out = pc;
endmodule
