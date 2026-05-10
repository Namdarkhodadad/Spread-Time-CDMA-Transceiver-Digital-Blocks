`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad 
// Create Date:    11:50:31 12/16/2024 
// Design Name: 
// Module Name:    Integrator_2 
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
module Integrator_DDS(
		input clk,
		input reset,
		input in_valid,
		input signed  [7:0] integrator_in,
		output reg signed [19:0] integrator_out
    );
	 
	 reg signed [20:0] in_sum;
	 reg flag_start;
	 reg [4:0] counter;
	 
	 wire change;
	 
	 assign change = (integrator_in == 8'b00000000) ? 0 : 1;
	 
	 
	 always @(posedge clk , posedge reset)
	begin
		if (reset)
			begin 
				integrator_out <= 20'b00011001100110011010; //00001010001111010111=1.99999MHz
				in_sum <= 21'b00000000000000000000; //2.08333MHz = 00011001100110011010 @20.833MHz
				flag_start <= 1'b0;
				counter <= 5'b00000;
			end
		
		else
			begin
				if(change)
					begin
						counter <= counter + 1;
					end
				
				if((!in_valid) && (!flag_start))
					begin
						integrator_out <= 20'b00011001100110011010; //00001101010101010100=2.60410MHz
					end
				else if((flag_start) && (in_valid)) //00001100101101110011=2.4825MHz   00011000100100110111=1.99999MHz @20.8333MHz
					begin
						if(counter > 5'b11010)
							begin
								in_sum <= in_sum + integrator_in;
								integrator_out <= in_sum[19:0] + 20'b00011001100110011010; // 00001011000000000000=2.14MHz
								counter <= 5'b00000;
							end
						else
							begin
								integrator_out <= in_sum[19:0] + 20'b00011001100110011010;
							end
					end
				else if((flag_start) && (!in_valid))
					begin
						integrator_out <= in_sum[19:0] + 20'b00011001100110011010; // 00001010110001110111=2.105MHz
					end
				else if(in_valid)
					begin
						flag_start <= 1'b1;
					end
			end
	end


endmodule
