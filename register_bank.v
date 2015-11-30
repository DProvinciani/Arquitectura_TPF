`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:20 11/29/2015 
// Design Name: 
// Module Name:    register_bank 
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
module register_bank(
		input wire [4:0] dir_read1,  //direccion para leer el reg 1
		input wire [4:0] dir_read2,  //direccion para leer el reg 2
		input wire [4:0] dir_write,  //direccion para escribir el registro
		input wire [31:0] write_data, //datos para escribir en el registro
		input wire wena,			//señal que habilita la escritura
		input wire clk,
		input wire rst,
		output wire [31:0] bus1,
		output wire [31:0] bus2
    );
		
		reg [4:0] addr1;
		reg [4:0] addr2;
		reg aux;
		
		register_bank_32x32bits bank(
		  .clka(clk),
		  .wea(wena),
		  .addra(addr1),
		  .dina(write_data),
		  .douta(bus1),
		  .clkb(clk),
		  .web(aux),
		  .addrb(addr2),
		  .dinb(write_data),
		  .doutb(bus2)
		);
		
		always @*
		begin
			if (wena) begin
				aux <= 0;
				addr2 <= dir_read2;
				addr1 <= dir_write;
			end
			else begin
				aux <= 0;
				addr2 <= dir_read2;
				addr1 <= dir_read1;
			end
		end
endmodule
