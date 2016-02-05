`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:45:30 01/30/2016 
// Design Name: 
// Module Name:    third_step 
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
module third_step(
		/*Control signals input*/
		input wire aluSrc,		
		input wire [1:0] ALUOp,	
		input wire regDst,		
		/*Data signals input*/
		input wire [31:0] pcPlusFour,
		input wire [31:0] reg1,
		input wire [31:0] reg2,
		input wire [31:0] signExtend,
		input wire [4:0] regDst1,
		input wire [4:0] regDst2,
		/*Signal output*/
		output wire [31:0] addResult,
		output wire zero,
		output wire [31:0] aluResult,
		output wire [31:0] reg2Out,
		output wire [4:0] muxRegDstOut
    );
	
	mux #(5) muxRegDst (
		.select(regDst),
		.item_a(regDst1), 
		.item_b(regDst2), 
		.signal(muxRegDstOut)
	);
	
	wire [31:0] muxAluSrc2Out;
	
	mux muxAluSrc2 (
		.select(aluSrc),
		.item_a(reg2), 
		.item_b(signExtend), 
		.signal(muxAluSrc2Out)
	);
	
	wire [3:0] ALUcontrolOut;
	
	alu_control aluControl (
		.ALUOp(ALUOp), //TODO: conectar la seal de control correspondiente de la unidad de control
		.funct(signExtend[5:0]),
		.ALUcontrolOut(ALUcontrolOut)
	);
	
	alu aluModule (
		.op1(reg1),
		.op2(muxAluSrc2Out),
		.alu_control(ALUcontrolOut),
		.result(aluResult),
		.zero(zero)
	);
	
	wire [31:0] shiftLeftOut;
	
	shift_left shiftModule(
    	.shift_in(signExtend),
		.shift_out(shiftLeftOut)
    );
	
	adder #(32) adderModule(
		.value1(pcPlusFour),
		.value2(shiftLeftOut),
		.result(addResult)
	);
	
	assign reg2Out = reg2;

endmodule
