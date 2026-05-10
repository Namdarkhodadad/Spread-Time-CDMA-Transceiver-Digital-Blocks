`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    20:56:06 01/24/2025 
// Design Name: 
// Module Name:    My_DDS 
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
module My_DDS(
		input clk,
		input reset,
		input valid,
		output reg [9:0] main_I
    );
		
		reg [3:0] index;
		reg [9:0] inputs_I [0:9];
		
		
		always @(posedge clk or posedge reset)
		begin
			if(reset)
				begin
					index <= 4'b0000;
					main_I   <= 10'b0000000000;
					
					inputs_I[0] <= 10'b0111111111;
					inputs_I[1] <= 10'b0110011110;
					inputs_I[2] <= 10'b0010011110;
					inputs_I[3] <= 10'b1101100010;
					inputs_I[4] <= 10'b1001100010;
					inputs_I[5] <= 10'b1000000000;
					inputs_I[6] <= 10'b1001100010;
					inputs_I[7] <= 10'b1101100010;
					inputs_I[8] <= 10'b0010011110;
					inputs_I[9] <= 10'b0110011110;
				end
				
				else if(valid && (!reset))
				begin
					if(index < 9)
						begin
							index    <= index + 1;
							main_I   <= inputs_I[index];
						end
					else if(index == 9)
						begin
							index    <= 4'b0000;
							main_I   <= inputs_I[index];
						end
					else
						begin
							index    <= 4'b0000;
							main_I   <= 10'b0000000000;
						end
				end 
		end
		

endmodule
