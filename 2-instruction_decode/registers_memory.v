`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:39 01/18/2016 
// Design Name: 
// Module Name:    registers_memory 
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
module registers_memory
	#(
	parameter B=32, // ancho de palabra en bits
				 W=5	 // bits de direccion, con 5 bits podemos 
						 // direccionar 32 registros
	)
	(
		input wire clk,	// clock del sistema
		input wire reset,
		input wire wr_en,	// seal de control para habilitar escritura
								// esta se testea en flanco de subida
		input wire [W-1:0] w_addr, r_addr1, r_addr2,
								// direccion lectura o escritura segun el caso
		input wire [B-1:0] w_data,
								// datos para escritura, si es el caso
		output wire [B-1:0] r_data1, r_data2
								// datos que se leen, siempre se lee
   );
	
	// declaracion de seniales
	reg [B-1:0] array_reg [0:31];
	integer i;
							// cantidad de registros direccionables segun W
							// para W=5 2**5=32 registros
	// operacion escritura
	
	always @(posedge clk,posedge reset)
	begin 		
			if (reset)
				begin
					for (i=0;i<32;i=i+1)
					begin
						array_reg[i] <= 0;
					end
				end
			else if (wr_en)
				array_reg[w_addr] <= w_data;
	end
	// operacion lectura
	assign r_data1 = array_reg[r_addr1];
	assign r_data2 = array_reg[r_addr2];
endmodule
