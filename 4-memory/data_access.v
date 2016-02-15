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
		input wire [5:0] opcode,
		input wire mem_write,
		//input wire mem_read,
		input wire zero,
		input wire branch_in,
		input wire branchNot_in,
		/*Data signals output*/
		output wire [B-1:0] data_out,
		/*Control signals output*/
		output wire pcSrc_out
    );
		
		wire [3:0] we;
		assign we[3]=mem_write;
		assign we[2]=mem_write;
		assign we[1]=mem_write;
		assign we[0]=mem_write;
		
		//Manejo de los "store"
		wire [B-1:0] sb;
		wire [B-1:0] sh;
		
		sig_extend #(8) sb_sign
		(
			.reg_in(write_data[7:0]),
			.reg_out(sb)
		);
		sig_extend sh_sign
		(
			.reg_in(write_data[15:0]),
			.reg_out(sh)
		);
		wire [B-1:0] write_data_mem;
		mux4 mux_store 
		(
			.sel(opcode[1:0]),
			.item_a(sb),
			.item_b(sh),
			.item_c(),
			.item_d(write_data),
			.signal(write_data_mem)
		);
		
		wire [B-1:0] data_mem;
		dataMemory dm(	.clka(~clk), 
							.rsta(1'b0),
							.ena(1'b1),
							.wea(we),
							.addra(addr_in),
							.dina(write_data_mem),
							.douta(data_mem));
		
		//Manejo de los "load"
		wire [B-1:0] lb;
		wire [B-1:0] lh;
		wire [B-1:0] lbu;
		wire [B-1:0] lhu;
		wire [B-1:0] l;
		wire [B-1:0] lu;
		
		sig_extend #(8) lb_sign
		(
			.reg_in(data_mem[7:0]),
			.reg_out(lb)
		);
		sig_extend lh_sign
		(
			.reg_in(data_mem[15:0]),
			.reg_out(lh)
		);
		assign lbu = {{(24){1'b0}}, data_mem[7:0]};
		assign lhu = {{(16){1'b0}}, data_mem[15:0]};
		
		mux4 mux_l
		(
			.sel(opcode[1:0]),
			.item_a(lb),
			.item_b(lh),
			.item_c(),
			.item_d(data_mem),
			.signal(l)
		);
		mux4 mux_lu
		(
			.sel(opcode[1:0]),
			.item_a(lbu),
			.item_b(lhu),
			.item_c(),
			.item_d(data_mem),
			.signal(lu)
		);
		
		mux mux_data_out
		(
			.select(opcode[2]),
			.item_a(l),
			.item_b(lu),
			.signal(data_out)
		);
		
		//Manejo de beq y bne
		wire and1;
		assign and1 = branch_in && zero;
		
		wire and2; 
		assign and2 = branchNot_in && (~zero);
		
		assign pcSrc_out = and1 || and2;

endmodule
