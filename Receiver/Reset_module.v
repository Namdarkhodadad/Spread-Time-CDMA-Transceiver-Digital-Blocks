`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    10:04:46 01/21/2025 
// Design Name: 
// Module Name:    Reset_module 
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
module Reset_module(
		input clk,
		input rst_in,
		output wire rst_out
    );
	 
	 reg rst_main = 1'b1;
	 
	 assign rst_out = rst_main;
	 
	 always @(negedge rst_in)
		begin
			if(!rst_in)
				begin
					rst_main <= 1'b0;
				end
		end


endmodule
