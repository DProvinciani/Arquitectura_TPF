`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:51 11/28/2015 
// Design Name: 
// Module Name:    alu 
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
module alu #(parameter bits = 32)
	(
	input [bits-1:0] Operando1,
	input [bits-1:0] Operando2,
	input [5:0] Instruccion,
	output [bits-1:0] Resultado
	);
	
	reg [bits-1:0] aux;
	
	always@(Operando1, Operando2, Instruccion)
		begin
			case (Instruccion)
				//ADDU
				6'b100001:
					aux <= Operando1 + Operando2;
				//SUBU
				6'b100011:
					aux <= Operando1 - Operando2;
				//AND
				6'b100100:
					aux <= Operando1 & Operando2;
				//OR
				6'b100101:
					aux <= Operando1 | Operando2;
				//XOR
				6'b100110:
					aux <= Operando1 ^ Operando2;
				//SLTU
				6'b101011:
					aux <= (Operando1 < Operando2) ? 1 : 0;
				//NOR
				6'b100111:
					aux <= ~(Operando1 | Operando2);
			default:
				aux <= {bits{1}};
		endcase
	end
	
	assign Resultado = aux;
	
endmodule