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
	//DATA HAZARDS
	//datos
	input wire [4:0] RsE,			//rs en etapa ex
	input wire [4:0] RtE,			//rt en etapa ex
	input wire [4:0] WriteRegM,		
	input wire [4:0] WriteRegWB,
	//control
	input wire RegWriteM,	
	input wire RegWriteWB,
	//outputs
	output reg [1:0] ForwardAE,
	output reg [1:0] ForwardBE,

	//LWSTALL
	//datos
	input wire [4:0] RsD,	//rs en etapa decode
	input wire [4:0] RtD,	//rt en etapa decode, tambien usa RtE
						//RtE, ya esta definido
	//control
	input wire MemtoRegEX,	//para saber si es una lw
				//RegWriteM, ya esta definido
				//RegWriteWB, ya esta definido
	//outputs
	output reg stallF,
	output reg stallD,
	output reg flushIDEX,
				//ForwardAE, ya esta definido
				//ForwardBE, ya esta definido
								
	//JUMP
	//data
	input wire [5:0] Opcode,
	input wire [5:0] Func,
	//output
	output reg flushIFID,
	
	//BRANCH
	//data
						//RsD, ya esta definido
						//RtD, ya esta definido
	input wire [4:0] WriteRegEX,
						//WriteRegE, ya esta definido
	//control
				//RegWriteM, ya esta definido
	input wire MemtoRegM,
	input wire RegWriteE,
	input wire branch_ID,		
	input wire branch_taken_ID,
							
	//output						
				//flushIDEX, ya esta definido
	output reg ForwardAD,
	output reg ForwardBD
	
   );
	
	//LW Y BRANCH STALL  
	reg lwstall;
	reg branchstall;
	
	always@(*)
	begin
	lwstall = ((RtE == RsD) | (RtE == RtD)) & MemtoRegEX;
	branchstall = (branch_ID & RegWriteE & (WriteRegEX == RsD | WriteRegEX == RtD)) | 
					  (branch_ID & MemtoRegM & (WriteRegM == RsD | WriteRegM == RtD));
	stallF = (lwstall | branchstall);
	stallD = (lwstall | branchstall);
	flushIDEX = (lwstall | branchstall);
	end
	
	
	//Forwarding
	always@(*)
	begin
		if ((RsE != 5'b00000) & (RsE == WriteRegM) & RegWriteM)
			ForwardAE = 2'b10;
		else if ((RsE != 5'b00000) & (RsE == WriteRegWB) & RegWriteWB)
			ForwardAE = 2'b01;
		else 
			ForwardAE = 2'b00;
		
		if ((RtE != 5'b00000) & (RtE == WriteRegM) & RegWriteM)
			ForwardBE = 2'b10;
		else if ((RtE != 5'b00000) & (RtE == WriteRegWB) & RegWriteWB)
			ForwardBE = 2'b01;
		else 
			ForwardBE = 2'b00;
	end

	//Jumps y branches
	
	always@(*)
	begin
		if ((Opcode == 6'b000010) | //J
			(Opcode == 6'b000011) | //JAL
			(((Opcode == 6'b000100) |(Opcode == 6'b000101)) & branch_taken_ID)| //BEQ BNE
			(Opcode == 6'b000000 & Func == 6'b001000)  |// JR
			(Opcode == 6'b000000 & Func == 6'b001001) )// JALR
			flushIFID = 1'b1;
		else
			flushIFID = 1'b0;
		if (stallD == 1'b1)		//si hay un stall no se flushea
			flushIFID = 1'b0;
	end


	always@(*)
	begin
		if ((RsD != 0) & (RsD == WriteRegM | WriteRegEX) & RegWriteM)
			ForwardAD = 1'b1;
		else 
			ForwardAD = 1'b0;
		
		if ((RtD != 0) & (RtD == WriteRegM | WriteRegEX) & RegWriteM)
			ForwardBD = 1'b1;
		else 
			ForwardBD = 1'b0;
	end
	
endmodule
