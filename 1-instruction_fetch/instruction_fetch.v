`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:11 11/27/2015 
// Design Name: 
// Module Name:    instruction_fetch 
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
module instruction_fetch
	#(
		parameter B=32 // ancho de la direccion (PC)
	)
	(
		input wire [B-1:0] pc_branch, 	//PC para tomar el salto
		input wire PCSrc, 				//Senial de control para elegir el PC
		//input wire enable,
		input wire reset,
		input wire clk,
		output wire [B-1:0] pc_incrementado, //PC para enviar al registro IF/ID
		output [B-1:0] instruction,
		output wire [31:0] pc_wire			/////SACAR!
    );
	
	reg [B-1:0] pc;							//registro PC
												
	adder add (.value1(pc), .value2(4), .result(pc_incrementado));
	instructionMemory im (.addra(pc), .clka(clk), .douta(instruction), .ena(1));
	
	always@(posedge clk or posedge reset)
	if (reset == 1) pc <= 0;		//Si entro por reset, resetea el PC
	else
	begin
		if (PCSrc == 1) pc <= pc_branch;
		else pc <= pc_incrementado;						//Si entro por clk, actualiza el PC con el nuevo valor
	end
	
	assign pc_wire = pc;
	
endmodule
