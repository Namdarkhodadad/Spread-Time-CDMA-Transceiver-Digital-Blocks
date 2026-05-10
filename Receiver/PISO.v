`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    15:48:31 01/05/2025 
// Design Name: 
// Module Name:    PISO 
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
module PISO(
		input clk,
		input Reset,
		input load,
		input first_sequence,
		input data_valid_FFT,
		input wire signed [9:0] DC_in_I,
		input wire signed [9:0] DC_in_Q,
		output reg signed [9:0] PISO_I,
		output reg signed [9:0] PISO_Q,
		output reg load_out,
		output reg [7:0] PISO_counter
    );
	 
	 reg signed [9:0] out_I [0:127]; 
	 reg signed [9:0] out_Q [0:127]; 
	 
	 reg [7:0] counter;
	 
	 integer k;
	 
	 always @(posedge clk or posedge Reset)
		begin
			if(Reset)
				begin
					PISO_I			<= 10'b0000000000;
					PISO_Q			<= 10'b0000000000;
					counter			<=  8'b01111110;
					PISO_counter   <= 8'b00000000;
				end
			else if(load)
				begin
					load_out <= 1'b1;
					for(k=127;k>0;k=k-1)
						begin
							out_I[k] <= out_I[k-1];
							out_Q[k] <= out_Q[k-1];
						end
					out_I[0] <= DC_in_I;
					out_Q[0] <= DC_in_Q;
					PISO_I	<= out_I[126];
					PISO_Q	<= out_Q[126];
					if(PISO_counter < 8'b10000000)
						begin
							PISO_counter <= PISO_counter + 1'b1;
						end
				end
				
			else if(data_valid_FFT && load_out && first_sequence) //data_valid_FFT &&
					begin
						if(counter >= 8'b00000000)
							begin
								counter <= counter-1;
								PISO_I  <= out_I[counter];
								PISO_Q  <= out_Q[counter];
								if(counter == 8'b00000000)
									begin
										load_out <= 1'b0;
										counter  <= 8'b01111110;
									end
							end
					end
		end
		
			
endmodule
