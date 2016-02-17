`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:10:30 02/08/2016 
// Design Name: 
// Module Name:    Hazard_unit 
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
module Hazard_unit(
	//Forwarding INPUTS
	input wire [4:0] RsE,	//rs en etapa ex
	input wire [4:0] RtE,	//rt en etapa ex
	input wire [4:0] WriteRegM,
	input wire [4:0] WriteRegWB,
	input wire RegWriteM,
	input wire RegWriteWB,
	input wire MemtoRegEX,	//para saber si es una lw
	//Stalling INPUTS
	input wire [4:0] RsD,	//rs en etapa decode
	input wire [4:0] RtD,	//rt en etapa decode, tambien usa RtE
	//Forwarding OUTPUTS
	output [1:0] ForwardAE,
	output [1:0] ForwardBE,
	//Stalling OUTPUTS
	output stallF,
	output stallD,
	output flushE
   );
/*
	always@(*)
	begin
		if (MemtoRegEX & ((RtE == RsD) | (RtE == RtD)))
		begin
			stallD = 1'b1;
			flushE = 1'b1;
			stallF = 1'b1;
		end
		else
		begin
			stallD = 1'b0;
			flushE = 1'b0;
			stallF = 1'b0;
		end
	end
*/
	assign ForwardAE = ((RsE != 5'b00000) & (RsE == WriteRegM) & RegWriteM) ? 2'b10 :
							 ((RsE != 5'b00000) & (RsE == WriteRegWB) & RegWriteWB) ? 2'b01 :
							 2'b00;
	assign ForwardBE = ((RtE != 5'b00000) & (RtE == WriteRegM) & RegWriteM) ? 2'b10 :
							 ((RtE != 5'b00000) & (RtE == WriteRegWB) & RegWriteWB) ? 2'b01 :
							 2'b00;

	assign stallF = (((RtE == RsD) | (RtE == RtD)) & MemtoRegEX) ? 1'b1 : 1'b0;
	assign stallD = (((RtE == RsD) | (RtE == RtD)) & MemtoRegEX) ? 1'b1 : 1'b0;
	assign flushE = (((RtE == RsD) | (RtE == RtD)) & MemtoRegEX) ? 1'b1 : 1'b0;

endmodule
