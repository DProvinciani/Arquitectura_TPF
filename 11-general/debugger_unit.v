`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:55:26 02/13/2016 
// Design Name: 
// Module Name:    debugger_unit 
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
module debugger_unit
	#(
		parameter B=32,
		parameter W=5
	)
	(
		input wire clk,
		input wire reset,
		output wire ena_pip,
		output wire [7:0] led,
		//uart
		input wire rx,
		output wire tx,
		
		//PC
		input wire [B-1:0] pc_incrementado_PC_out,
		
		//IF
		////Input
		//////Datos
		input wire [B-1:0] pc_PC_out,
		////Output
		//////Datos
		input wire [B-1:0] instruction_IF_out,
		
		//ID
		////Input
		//////Datos
		input wire [B-1:0] pc_incrementado_ID_in,
		input wire [B-1:0] instruction_ID_in,
		input wire [B-1:0] write_data_ID_in,
		input wire [W-1:0] write_addr_ID_in,
		input wire [B-1:0] alu_result_EX_in,
		////Output
		//////Datos
		input wire [B-1:0] reg_data1_ID_out,
		input wire [B-1:0] reg_data2_ID_out,
		input wire [B-1:0] sign_extend_ID_out,
		input wire [W-1:0] inst_25_21_ID_out,
		input wire [W-1:0] inst_20_16_ID_out,
		input wire [W-1:0] inst_15_11_ID_out,
		input wire [B-1:0] pc_jump_ID_out,
		input wire [B-1:0] pc_branch_ID_out,
		
		//EX
		////Input
		//////Datos
		input wire [B-1:0] pc_incrementado_EX_in,
		input wire [B-1:0] reg_data1_EX_in,
		input wire [B-1:0] reg_data2_EX_in,
		input wire [B-1:0] sign_extend_EX_in,
		input wire [W-1:0] rt_EX_in,
		input wire [W-1:0] rd_EX_in,
		////Output
		//////Datos
		//input wire [B-1:0] alu_result_EX_out,
		input wire [B-1:0] reg_data2_EX_out,
		input wire [W-1:0] rt_or_rd_EX_out,
		input wire zero,
		
		//MEM
		////Input
		//////Datos
		input wire [B-1:0] addres_MEM_in,
		input wire [B-1:0] write_data_MEM_in,
		////Output
		//////Datos
		input wire [B-1:0] read_data_MEM_out,
		
		//WB
		////Input
		//////Datos
		input wire [B-1:0] mem_data_WB_in,
		input wire [B-1:0] alu_result_WB_in,
		////Output
		//////Datos
		input wire [B-1:0] write_data_WB_out,
		
		//Registros
		input wire [B-1:0] reg_0_out,
		input wire [B-1:0] reg_1_out,
		input wire [B-1:0] reg_2_out,
		input wire [B-1:0] reg_3_out,
		input wire [B-1:0] reg_4_out,
		input wire [B-1:0] reg_5_out,
		input wire [B-1:0] reg_6_out,
		input wire [B-1:0] reg_7_out,
		input wire [B-1:0] reg_8_out,
		input wire [B-1:0] reg_9_out,
		input wire [B-1:0] reg_10_out,
		input wire [B-1:0] reg_11_out,
		input wire [B-1:0] reg_12_out,
		input wire [B-1:0] reg_13_out,
		input wire [B-1:0] reg_14_out,
		input wire [B-1:0] reg_15_out,
		input wire [B-1:0] reg_16_out,
		input wire [B-1:0] reg_17_out,
		input wire [B-1:0] reg_18_out,
		input wire [B-1:0] reg_19_out,
		input wire [B-1:0] reg_20_out,
		input wire [B-1:0] reg_21_out,
		input wire [B-1:0] reg_22_out,
		input wire [B-1:0] reg_23_out,
		input wire [B-1:0] reg_24_out,
		input wire [B-1:0] reg_25_out,
		input wire [B-1:0] reg_26_out,
		input wire [B-1:0] reg_27_out,
		input wire [B-1:0] reg_28_out,
		input wire [B-1:0] reg_29_out,
		input wire [B-1:0] reg_30_out,
		input wire [B-1:0] reg_31_out
    );
		
		reg btn_read_reg, btn_read_next;		//Bit para obtener dato de la uart
		reg ena_pip_reg, ena_pip_next;		//Bit para habilitar el pipeline
		reg send_data_reg, send_data_next; 	//Bit para enviar dato por uart
		reg [1:0] op_next;
		reg [1:0] op_reg;
		wire rx_empty;
		wire tx_done_tick;
		wire [7:0] rec_data;
		reg [7:0] write_data_reg; 
		reg [7:0] write_data_next;
		wire reset_uart;
		reg reset_u;
		integer byteN_reg, byteN_next;
		reg [7:0] rec_data_test_reg, rec_data_test_next;
		
		//Para transmitir
		//Estado
		reg [2:0] state_next;
		reg [2:0] state_reg;
		//Array a transmitir
		reg [7:0] datos[0:227];
		//Estados
		localparam [2:0]
			idle  = 3'b000,
			start = 3'b001,
			transmiting  = 3'b010,
			waiting = 3'b011,
			waiting_for_data = 3'b100,
			waiting_for_data2 = 3'b101;
			
		uart uart_unit
		(
			.clk(clk), 
			.reset(reset), 
			.rd_uart(btn_read_reg),
			.r_data(rec_data), 
			.wr_uart(send_data_reg), 
			.rx(rx), 
			.w_data(write_data_reg),
			.tx_done_tick(tx_done_tick),
			.rx_empty(rx_empty),
			.tx(tx)
		);
		
		always@(posedge clk, posedge reset)
		begin
			if (reset)
				begin
				btn_read_reg <= 0;
				op_reg <= 0;
				ena_pip_reg <=0;
				rec_data_test_reg <= 0; ///////////////para test
				//Para envio de datos
				byteN_reg <= 0;
				state_reg <= 3'b000;
				send_data_reg <= 1'b0;
				write_data_reg <= 0;
				end
			else
				begin
				btn_read_reg <= btn_read_next;
				op_reg <= op_next;
				ena_pip_reg <= ena_pip_next;
				rec_data_test_reg <= rec_data_test_next;   //////para tests
				//Para envio de datos
				state_reg <= state_next;
				byteN_reg <= byteN_next;
				send_data_reg <= send_data_next;
				write_data_reg <= write_data_next;
				end
		end
		
		always@(*)
		begin
			op_next = op_reg;
			ena_pip_next = ena_pip_reg;
			rec_data_test_next = rec_data_test_reg; //////////////////////////Para test
			
			//si viene un dato lo leo (si termino el programa no leo el dato)
			if (~rx_empty & ~btn_read_reg)		
				begin
				btn_read_next = 1'b1; //flag marcar el dato como leido
				rec_data_test_next = rec_data;  //////////////////////////Para test
				if (op_reg != 2'b11) //si no finalizo el programa..
					case (rec_data)	//leo el dato y actualizo el estado
						8'b00000010: //case next
							op_next = 2'b10;
						8'b00000001: //case continue
							op_next = 2'b01;
						default:
							op_next = 2'b00;
					endcase
				end
			else if(pc_incrementado_PC_out==508) //si el PC+4 llega a 512 termino el programa
				begin
				op_next = 2'b11;
				ena_pip_next = 1'b0;
				end
			else
				begin
				btn_read_next = 1'b0;
				case (op_reg)
					2'b00://idle
						begin
							op_next = 2'b00;
							ena_pip_next = 1'b0;
						end
					2'b10://next
						begin
							op_next = 2'b00;
							ena_pip_next = 1'b1;
						end
					2'b01://continue
						begin
							op_next = 2'b01;
							ena_pip_next = 1'b1;
						end
					2'b11://finish
					begin
						op_next = 2'b11;
						ena_pip_next = 1'b0;
					end
				endcase
				end
		end
		
		//Envio de datos
		always@(*)
		begin
			send_data_next = 1'b0;
			byteN_next = byteN_reg;
			write_data_next = write_data_reg;
			case (state_reg)
				idle:
					begin
						state_next = state_reg;
						if (btn_read_reg==1)
							begin
							state_next = waiting_for_data;
							end
					end
				waiting_for_data:
					begin
					state_next = start;
					end
				start:
					begin
					//Cargo datos
					//datos[0] = instruction_IF_out[7:0];
					//reg0
					datos[0] = reg_0_out[31:24];
					datos[1] = reg_0_out[23:16];
					datos[2] = reg_0_out[15:8];
					datos[3] = reg_0_out[7:0];
					//reg1
					datos[4] = reg_1_out[31:24];
					datos[5] = reg_1_out[23:16];
					datos[6] = reg_1_out[15:8];
					datos[7] = reg_1_out[7:0];
					//reg2
					datos[8] = reg_2_out[31:24];
					datos[9] = reg_2_out[23:16];
					datos[10] = reg_2_out[15:8];
					datos[11] = reg_2_out[7:0];
					//reg3
					datos[12] = reg_3_out[31:24];
					datos[13] = reg_3_out[23:16];
					datos[14] = reg_3_out[15:8];
					datos[15] = reg_3_out[7:0];
					//reg4
					datos[16] = reg_4_out[31:24];
					datos[17] = reg_4_out[23:16];
					datos[18] = reg_4_out[15:8];
					datos[19] = reg_4_out[7:0];
					//reg5
					datos[20] = reg_5_out[31:24];
					datos[21] = reg_5_out[23:16];
					datos[22] = reg_5_out[15:8];
					datos[23] = reg_5_out[7:0];
					//reg6
					datos[24] = reg_6_out[31:24];
					datos[25] = reg_6_out[23:16];
					datos[26] = reg_6_out[15:8];
					datos[27] = reg_6_out[7:0];
					//reg7
					datos[28] = reg_7_out[31:24];
					datos[29] = reg_7_out[23:16];
					datos[30] = reg_7_out[15:8];
					datos[31] = reg_7_out[7:0];
					//reg8
					datos[32] = reg_8_out[31:24];
					datos[33] = reg_8_out[23:16];
					datos[34] = reg_8_out[15:8];
					datos[35] = reg_8_out[7:0];
					//reg9
					datos[36] = reg_9_out[31:24];
					datos[37] = reg_9_out[23:16];
					datos[38] = reg_9_out[15:8];
					datos[39] = reg_9_out[7:0];
					//reg10
					datos[40] = reg_10_out[31:24];
					datos[41] = reg_10_out[23:16];
					datos[42] = reg_10_out[15:8];
					datos[43] = reg_10_out[7:0];
					//reg11
					datos[44] = reg_11_out[31:24];
					datos[45] = reg_11_out[23:16];
					datos[46] = reg_11_out[15:8];
					datos[47] = reg_11_out[7:0];
					//reg12
					datos[48] = reg_12_out[31:24];
					datos[49] = reg_12_out[23:16];
					datos[50] = reg_12_out[15:8];
					datos[51] = reg_12_out[7:0];
					//reg13
					datos[52] = reg_13_out[31:24];
					datos[53] = reg_13_out[23:16];
					datos[54] = reg_13_out[15:8];
					datos[55] = reg_13_out[7:0];
					//reg14
					datos[56] = reg_14_out[31:24];
					datos[57] = reg_14_out[23:16];
					datos[58] = reg_14_out[15:8];
					datos[59] = reg_14_out[7:0];
					//reg15
					datos[60] = reg_15_out[31:24];
					datos[61] = reg_15_out[23:16];
					datos[62] = reg_15_out[15:8];
					datos[63] = reg_15_out[7:0];
					//reg16
					datos[64] = reg_16_out[31:24];
					datos[65] = reg_16_out[23:16];
					datos[66] = reg_16_out[15:8];
					datos[67] = reg_16_out[7:0];
					//reg17
					datos[68] = reg_17_out[31:24];
					datos[69] = reg_17_out[23:16];
					datos[70] = reg_17_out[15:8];
					datos[71] = reg_17_out[7:0];
					//reg18
					datos[72] = reg_18_out[31:24];
					datos[73] = reg_18_out[23:16];
					datos[74] = reg_18_out[15:8];
					datos[75] = reg_18_out[7:0];
					//reg19
					datos[76] = reg_19_out[31:24];
					datos[77] = reg_19_out[23:16];
					datos[78] = reg_19_out[15:8];
					datos[79] = reg_19_out[7:0];
					//reg20
					datos[80] = reg_20_out[31:24];
					datos[81] = reg_20_out[23:16];
					datos[82] = reg_20_out[15:8];
					datos[83] = reg_20_out[7:0];
					//reg21
					datos[84] = reg_21_out[31:24];
					datos[85] = reg_21_out[23:16];
					datos[86] = reg_21_out[15:8];
					datos[87] = reg_21_out[7:0];
					//reg22
					datos[88] = reg_22_out[31:24];
					datos[89] = reg_22_out[23:16];
					datos[90] = reg_22_out[15:8];
					datos[91] = reg_22_out[7:0];
					//reg23
					datos[92] = reg_23_out[31:24];
					datos[93] = reg_23_out[23:16];
					datos[94] = reg_23_out[15:8];
					datos[95] = reg_23_out[7:0];
					//reg24
					datos[96] = reg_24_out[31:24];
					datos[97] = reg_24_out[23:16];
					datos[98] = reg_24_out[15:8];
					datos[99] = reg_24_out[7:0];
					//reg25
					datos[100] = reg_25_out[31:24];
					datos[101] = reg_25_out[23:16];
					datos[102] = reg_25_out[15:8];
					datos[103] = reg_25_out[7:0];
					//reg26
					datos[104] = reg_26_out[31:24];
					datos[105] = reg_26_out[23:16];
					datos[106] = reg_26_out[15:8];
					datos[107] = reg_26_out[7:0];
					//reg27
					datos[108] = reg_27_out[31:24];
					datos[109] = reg_27_out[23:16];
					datos[110] = reg_27_out[15:8];
					datos[111] = reg_27_out[7:0];
					//reg28
					datos[112] = reg_28_out[31:24];
					datos[113] = reg_28_out[23:16];
					datos[114] = reg_28_out[15:8];
					datos[115] = reg_28_out[7:0];
					//reg29
					datos[116] = reg_29_out[31:24];
					datos[117] = reg_29_out[23:16];
					datos[118] = reg_29_out[15:8];
					datos[119] = reg_29_out[7:0];
					//reg30
					datos[120] = reg_30_out[31:24];
					datos[121] = reg_30_out[23:16];
					datos[122] = reg_30_out[15:8];
					datos[123] = reg_30_out[7:0];
					//reg31
					datos[124] = reg_31_out[31:24];
					datos[125] = reg_31_out[23:16];
					datos[126] = reg_31_out[15:8];
					datos[127] = reg_31_out[7:0];
					
					//IF
					////PC_in
					datos[128] = pc_PC_out[31:24];
					datos[129] = pc_PC_out[23:16];
					datos[130] = pc_PC_out[15:8];
					datos[131] = pc_PC_out[7:0];
					////Instruction_out
					datos[132] = instruction_IF_out[31:24];
					datos[133] = instruction_IF_out[23:16];
					datos[134] = instruction_IF_out[15:8];
					datos[135] = instruction_IF_out[7:0];
					
					//ID
					////PC_incrementado_in
					datos[136] = pc_incrementado_ID_in[31:24];
					datos[137] = pc_incrementado_ID_in[23:16];
					datos[138] = pc_incrementado_ID_in[15:8];
					datos[139] = pc_incrementado_ID_in[7:0];
					////instruction_in
					datos[140] = instruction_ID_in[31:24];
					datos[141] = instruction_ID_in[23:16];
					datos[142] = instruction_ID_in[15:8];
					datos[143] = instruction_ID_in[7:0];
					////write data
					datos[144] = write_data_ID_in[31:24];
					datos[145] = write_data_ID_in[23:16];
					datos[146] = write_data_ID_in[15:8];
					datos[147] = write_data_ID_in[7:0];
					////write address
					datos[148] = {3'b000, write_addr_ID_in};
					////alu result
					datos[149] = alu_result_EX_in[31:24];
					datos[150] = alu_result_EX_in[23:16];
					datos[151] = alu_result_EX_in[15:8];
					datos[152] = alu_result_EX_in[7:0];
					////reg data 1
					datos[153] = reg_data1_ID_out[31:24];
					datos[154] = reg_data1_ID_out[23:16];
					datos[155] = reg_data1_ID_out[15:8];
					datos[156] = reg_data1_ID_out[7:0];
					////reg data 2
					datos[157] = reg_data2_ID_out[31:24];
					datos[158] = reg_data2_ID_out[23:16];
					datos[159] = reg_data2_ID_out[15:8];
					datos[160] = reg_data2_ID_out[7:0];
					////sign ext
					datos[161] = sign_extend_ID_out[31:24];
					datos[162] = sign_extend_ID_out[23:16];
					datos[163] = sign_extend_ID_out[15:8];
					datos[164] = sign_extend_ID_out[7:0];
					////inst 25-21
					datos[165] = {3'b000, inst_25_21_ID_out};
					////inst 20-16
					datos[166] = {3'b000, inst_20_16_ID_out};
					////inst 15-11
					datos[167] = {3'b000, inst_15_11_ID_out};
					////pc jump
					datos[168] = pc_jump_ID_out[31:24];
					datos[169] = pc_jump_ID_out[23:16];
					datos[170] = pc_jump_ID_out[15:8];
					datos[171] = pc_jump_ID_out[7:0];
					////pc branch
					datos[172] = pc_branch_ID_out[31:24];
					datos[173] = pc_branch_ID_out[23:16];
					datos[174] = pc_branch_ID_out[15:8];
					datos[175] = pc_branch_ID_out[7:0];
					
					//EX
					////pc incrementado
					datos[176] = pc_incrementado_EX_in[31:24];
					datos[177] = pc_incrementado_EX_in[23:16];
					datos[178] = pc_incrementado_EX_in[15:8];
					datos[179] = pc_incrementado_EX_in[7:0];
					////reg data 1
					datos[180] = reg_data1_EX_in[31:24];
					datos[181] = reg_data1_EX_in[23:16];
					datos[182] = reg_data1_EX_in[15:8];
					datos[183] = reg_data1_EX_in[7:0];
					////reg data 2
					datos[184] = reg_data2_EX_in[31:24];
					datos[185] = reg_data2_EX_in[23:16];
					datos[186] = reg_data2_EX_in[15:8];
					datos[187] = reg_data2_EX_in[7:0];
					////sign ext
					datos[188] = sign_extend_EX_in[31:24];
					datos[189] = sign_extend_EX_in[23:16];
					datos[190] = sign_extend_EX_in[15:8];
					datos[191] = sign_extend_EX_in[7:0];
					////rt
					datos[192] = {3'b000, rt_EX_in};
					////rd
					datos[193] = {3'b000, rd_EX_in};
					////zero signal
					datos[194] = {7'b0000_000, zero};
					////alu result
					datos[195] = alu_result_EX_in[31:24];
					datos[196] = alu_result_EX_in[23:16];
					datos[197] = alu_result_EX_in[15:8];
					datos[198] = alu_result_EX_in[7:0];
					////reg data 2
					datos[199] = reg_data2_EX_out[31:24];
					datos[200] = reg_data2_EX_out[23:16];
					datos[201] = reg_data2_EX_out[15:8];
					datos[202] = reg_data2_EX_out[7:0];
					////rt ot rd
					datos[203] = {3'b000, rt_or_rd_EX_out};
					
					//MEM
					////mem address
					datos[204] = addres_MEM_in[31:24];
					datos[205] = addres_MEM_in[23:16];
					datos[206] = addres_MEM_in[15:8];
					datos[207] = addres_MEM_in[7:0];
					////write data
					datos[208] = write_data_MEM_in[31:24];
					datos[209] = write_data_MEM_in[23:16];
					datos[210] = write_data_MEM_in[15:8];
					datos[211] = write_data_MEM_in[7:0];
					////mem data
					datos[212] = read_data_MEM_out[31:24];
					datos[213] = read_data_MEM_out[23:16];
					datos[214] = read_data_MEM_out[15:8];
					datos[215] = read_data_MEM_out[7:0];
		
					//WB
					////mem data
					datos[216] = mem_data_WB_in[31:24];
					datos[217] = mem_data_WB_in[23:16];
					datos[218] = mem_data_WB_in[15:8];
					datos[219] = mem_data_WB_in[7:0];
					////alu result
					datos[220] = alu_result_WB_in[31:24];
					datos[221] = alu_result_WB_in[23:16];
					datos[222] = alu_result_WB_in[15:8];
					datos[223] = alu_result_WB_in[7:0];
					////write data
					datos[224] = write_data_WB_out[31:24];
					datos[225] = write_data_WB_out[23:16];
					datos[226] = write_data_WB_out[15:8];
					datos[227] = write_data_WB_out[7:0];
					
					//Comienzo a transmitir
					byteN_next = 0;
					state_next = transmiting;
					end
				transmiting:
					begin
						write_data_next = datos[byteN_reg];
						send_data_next = 1'b1;
						byteN_next = byteN_reg + 1;
						if (byteN_reg == 227) //ant de datos a transmitir
							state_next = idle;
						else
							state_next = waiting;
					end
				waiting:
					begin
						if (tx_done_tick)
							state_next = transmiting;
						else
							state_next = waiting;
					end
			endcase
		end
		
		assign led = rec_data_test_reg;
		assign ena_pip = ena_pip_reg;

endmodule
