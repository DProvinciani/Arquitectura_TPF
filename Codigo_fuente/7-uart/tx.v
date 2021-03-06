`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:54 10/17/2015 
// Design Name: 
// Module Name:    tx 
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
module tx
  #(
    parameter DBIT = 8,        // cantidad de bits de datos
              SB_TICK = 16     // cantidad de ticks para enviar un bit fuera del shift register
  )
  (
    input wire clk, reset,
    input wire tx_start, s_tick,
    input wire [DBIT-1:0] data_in,
    output reg tx_done_tick,
    output wire tx
  );
  
  //Declaracin de estados simblicos
  localparam [1:0]
      idle  = 2'b00,
      start = 2'b01,
      data  = 2'b10,
      stop  = 2'b11;
      
  //Declaracin de seales
  reg [1:0] state_reg, state_next;
  reg [3:0] s_reg, s_next; //Numero de sampling ticks para hacer el oversampling
  reg [2:0] n_reg, n_next; //Numero de bits de datos recibidos en el estado data.
  reg [DBIT-1:0] b_reg, b_next;
  reg tx_reg, tx_next;     //Buffer de un bit para filtrar posibles fallos
  
  //Cuerpo
  //Registros de datos y Estado de la FSMD
  always @(posedge clk, posedge reset)
    if(reset)
		 begin
			state_reg <= idle;
			s_reg <= 0;
			n_reg <= 0;
			b_reg <= 0;
			tx_reg <= 1'b1;
		 end
    else
		 begin
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
			tx_reg <= tx_next;
		 end
      
  // FSMD next-state logic y unidades funcionales
  always @*
  begin
    state_next = state_reg;
    tx_done_tick = 1'b0;
    s_next = s_reg;
    n_next = n_reg;
    b_next = b_reg;
    tx_next = tx_reg;
    
    case (state_reg)
      idle:
      begin
        tx_next = 1'b1;
        if(tx_start)
        begin
          state_next = start;
          s_next = 0;
          b_next = data_in;
        end
      end
      
      start:
      begin
        tx_next = 1'b0;
        if(s_tick)
          if(s_reg == 15)
				 begin
					state_next = data;
					s_next = 0;
					n_next = 0;
				 end
          else
            s_next = s_reg + 4'b0001;
      end
      
      data:
      begin
        tx_next = b_reg[0];
        if(s_tick)
          if(s_reg == 15)
          begin
            s_next = 0;
            b_next = b_reg >> 1;
            if(n_reg == (DBIT - 1))
              state_next = stop;
            else
              n_next = n_reg + 3'b001;
          end
          
          else
            s_next = s_reg + 4'b0001;
      end     
            
      stop:
      begin
        tx_next = 1'b1;
        if(s_tick)
          if(s_reg == (SB_TICK - 1))
				 begin
					state_next = idle;
					tx_done_tick = 1'b1;
				 end
          else
            s_next = s_reg + 4'b0001;
      end
      
    endcase
  end
  
  //Salida
  assign tx = tx_reg;
  
endmodule
