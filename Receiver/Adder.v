`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    17:12:34 12/09/2024 
// Design Name: 
// Module Name:    Adder 
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
module Adder(
	input        clk,
	input        reset,
	input			 Valid,
	input signed 	 [17:0] Mult_out_I,
	input signed 	 [17:0] Mult_out_Q,
	input 	    	 [6:0]  Mult_N,
	output 	reg  signed  [25:0] final_sum_I,
	output 	reg  signed  [25:0] final_sum_Q,
	output	reg    final_sum_ready,
	output   reg    [7:0]  current_state
    );
	 
	 reg signed [25:0] sum_I;
	 reg signed [25:0] sum_Q;
	 
	 
	 
	 //assign sum_I = (!reset) ? (Mult_out_I + sum_I) : {26{1'b0}};
	 //assign sum_Q = (!reset) ? (Mult_out_Q + sum_Q) : {26{1'b0}};

	 
	 always@(posedge clk or posedge reset or posedge Valid)
		begin
		if(reset)
			begin
				current_state   <= 8'b0000000;
				sum_I				 <= 26'b00000000000000000000000000;
				sum_Q				 <= 26'b00000000000000000000000000;
				final_sum_I				 <= 26'b00000000000000000000000000;
				final_sum_Q				 <= 26'b00000000000000000000000000;
				final_sum_ready <= 1'b0;
			end
		 else if(Valid)
			begin
			if(current_state < 8'b10000000)
			begin
				final_sum_ready <= 1'b0;
				current_state <= current_state + 1'b1;
				sum_I <= {{8{Mult_out_I[17]}},Mult_out_I} + sum_I;
				sum_Q <= {{8{Mult_out_Q[17]}},Mult_out_Q} + sum_Q;
				final_sum_I				 <= 26'b00000000000000000000000000;
				final_sum_Q				 <= 26'b00000000000000000000000000;
			end
			else if(current_state == 8'b10000000)
			begin
				final_sum_ready 	<= 1'b1;
				final_sum_I			<= {{8{Mult_out_I[17]}},Mult_out_I} + sum_I;
				final_sum_Q			<= {{8{Mult_out_Q[17]}},Mult_out_Q} + sum_Q;
				current_state     <= 8'b000000000;
				sum_I				 	<= 26'b00000000000000000000000000;
				sum_Q				 	<= 26'b00000000000000000000000000;
			end
		 end
		end


endmodule
