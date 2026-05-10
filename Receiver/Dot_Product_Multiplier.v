`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    14:14:45 12/09/2024 
// Design Name: 
// Module Name:    Dot_Product_Multiplier 
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
module Dot_Product_Multiplier(
		input  clk,
		input  rst,
		input signed [17:0] FFT_out_I,
		input signed [17:0] FFT_out_Q,
		input  	  Sequential_Dot_Variable,
		input  	  Sequential_Dot_Sign,
		input 	  [6:0]  N_cnt,
		output wire signed    [17:0] Each_Dot_Value_I,
		output wire signed	 [17:0] Each_Dot_Value_Q,
		output	wire  Valid,
		output	reg  Packet_Done,
		output	reg  [6:0]  N_Mult
    );



//wire [17:0] Minus_FFT_out_real;
//wire [17:0] Minus_FFT_out_imag;
//wire [17:0] Each_Dot_Value_real;
//wire [17:0] Each_Dot_Value_imag;

//assign Minus_FFT_out_real	  = 18'b00000000000000000 - FFT_out_real;
//assign Minus_FFT_out_imag	  = 18'b00000000000000000 - FFT_out_imag;
	 
//assign Each_Dot_Value = (Sequential_Dot_Variable==0) ?  FFT_out_real: (Sequential_Dot_Sign	 ==1)	?  Minus_FFT_out_real: 18'b00000000000000000;
//assign Each_Dot_Value = (Sequential_Dot_Variable==0) ?  FFT_out_real: (Sequential_Dot_Sign	 ==1)	?  Minus_FFT_out_real: 18'b00000000000000000;

assign Each_Dot_Value_I = ((Sequential_Dot_Variable) && (!Sequential_Dot_Sign)) ? FFT_out_I:	
								  ((Sequential_Dot_Variable) && (Sequential_Dot_Sign))  ? (~FFT_out_I + 1):
								  {18{1'b0}};
assign Each_Dot_Value_Q = ((Sequential_Dot_Variable) && (!Sequential_Dot_Sign)) ? FFT_out_Q:	
								  ((Sequential_Dot_Variable) && (Sequential_Dot_Sign))  ? (~FFT_out_Q + 1):
								  {18{1'b0}};
						
assign Valid = (N_cnt > 1'b0) ? 1'b1 : 1'b0;

	always @(posedge clk)
    begin
			if(rst)
				begin
					N_Mult 			<= 7'b0000000;
					Packet_Done		<= 1'b0;
				end
			
			else if((Sequential_Dot_Variable) && (Sequential_Dot_Sign))
				begin
					N_Mult <= N_Mult + 1'b1;
				end
			else if((Sequential_Dot_Variable) && (!Sequential_Dot_Sign))
				begin
					N_Mult <= N_Mult + 1'b1;
				end
			else if(!Sequential_Dot_Variable)
				begin
					//Each_Dot_Value_I <= {18{1'b0}};
					//Each_Dot_Value_Q <= {18{1'b0}};
					N_Mult <= N_Mult + 1'b1;
					//Valid <= 1'b1;
				end
				
			if(N_cnt == N_Mult)
				begin
					Packet_Done		<= 1'b1;
					N_Mult			<= 7'b0000000;
				end
			
	 end
										 
									


endmodule
