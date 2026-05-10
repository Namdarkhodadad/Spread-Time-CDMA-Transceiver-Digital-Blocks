`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    09:28:32 01/07/2025 
// Design Name: 
// Module Name:    Inputs 
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
module Inputs(
		input clk,
		input reset,
		input valid,
		output reg flag,
		output reg main
    );
	 
	 reg [7:0] index;
	 reg inputs [0:127];
	 
	 always @(posedge clk or posedge reset)
		begin
			if(reset)
				begin
					index <= 8'b00000000;
					
					inputs[0] <= 1'b0;
inputs[1] <= 1'b1;
inputs[2] <= 1'b1;
inputs[3] <= 1'b0;
inputs[4] <= 1'b1;
inputs[5] <= 1'b1;
inputs[6] <= 1'b0;
inputs[7] <= 1'b1;
inputs[8] <= 1'b0;
inputs[9] <= 1'b1;
inputs[10] <= 1'b1;
inputs[11] <= 1'b1;
inputs[12] <= 1'b1;
inputs[13] <= 1'b0;
inputs[14] <= 1'b1;
inputs[15] <= 1'b0;
inputs[16] <= 1'b0;
inputs[17] <= 1'b1;
inputs[18] <= 1'b1;
inputs[19] <= 1'b1;
inputs[20] <= 1'b0;
inputs[21] <= 1'b0;
inputs[22] <= 1'b1;
inputs[23] <= 1'b0;
inputs[24] <= 1'b0;
inputs[25] <= 1'b0;
inputs[26] <= 1'b1;
inputs[27] <= 1'b0;
inputs[28] <= 1'b0;
inputs[29] <= 1'b1;
inputs[30] <= 1'b0;
inputs[31] <= 1'b0;
inputs[32] <= 1'b1;
inputs[33] <= 1'b0;
inputs[34] <= 1'b1;
inputs[35] <= 1'b0;
inputs[36] <= 1'b0;
inputs[37] <= 1'b0;
inputs[38] <= 1'b0;
inputs[39] <= 1'b0;
inputs[40] <= 1'b1;
inputs[41] <= 1'b1;
inputs[42] <= 1'b0;
inputs[43] <= 1'b1;
inputs[44] <= 1'b0;
inputs[45] <= 1'b0;
inputs[46] <= 1'b0;
inputs[47] <= 1'b0;
inputs[48] <= 1'b0;
inputs[49] <= 1'b1;
inputs[50] <= 1'b0;
inputs[51] <= 1'b0;
inputs[52] <= 1'b0;
inputs[53] <= 1'b0;
inputs[54] <= 1'b0;
inputs[55] <= 1'b0;
inputs[56] <= 1'b1;
inputs[57] <= 1'b1;
inputs[58] <= 1'b0;
inputs[59] <= 1'b1;
inputs[60] <= 1'b1;
inputs[61] <= 1'b0;
inputs[62] <= 1'b0;
inputs[63] <= 1'b1;
inputs[64] <= 1'b1;
inputs[65] <= 1'b1;
inputs[66] <= 1'b1;
inputs[67] <= 1'b1;
inputs[68] <= 1'b1;
inputs[69] <= 1'b0;
inputs[70] <= 1'b0;
inputs[71] <= 1'b0;
inputs[72] <= 1'b0;
inputs[73] <= 1'b1;
inputs[74] <= 1'b0;
inputs[75] <= 1'b0;
inputs[76] <= 1'b1;
inputs[77] <= 1'b0;
inputs[78] <= 1'b1;
inputs[79] <= 1'b0;
inputs[80] <= 1'b0;
inputs[81] <= 1'b1;
inputs[82] <= 1'b1;
inputs[83] <= 1'b0;
inputs[84] <= 1'b1;
inputs[85] <= 1'b0;
inputs[86] <= 1'b0;
inputs[87] <= 1'b0;
inputs[88] <= 1'b1;
inputs[89] <= 1'b1;
inputs[90] <= 1'b1;
inputs[91] <= 1'b0;
inputs[92] <= 1'b1;
inputs[93] <= 1'b0;
inputs[94] <= 1'b1;
inputs[95] <= 1'b1;
inputs[96] <= 1'b1;
inputs[97] <= 1'b1;
inputs[98] <= 1'b0;
inputs[99] <= 1'b1;
inputs[100] <= 1'b1;
inputs[101] <= 1'b1;
inputs[102] <= 1'b1;
inputs[103] <= 1'b0;
inputs[104] <= 1'b1;
inputs[105] <= 1'b1;
inputs[106] <= 1'b1;
inputs[107] <= 1'b1;
inputs[108] <= 1'b0;
inputs[109] <= 1'b0;
inputs[110] <= 1'b1;
inputs[111] <= 1'b0;
inputs[112] <= 1'b1;
inputs[113] <= 1'b1;
inputs[114] <= 1'b1;
inputs[115] <= 1'b1;
inputs[116] <= 1'b1;
inputs[117] <= 1'b1;
inputs[118] <= 1'b0;
inputs[119] <= 1'b0;
inputs[120] <= 1'b0;
inputs[121] <= 1'b1;
inputs[122] <= 1'b1;
inputs[123] <= 1'b0;
inputs[124] <= 1'b0;
inputs[125] <= 1'b0;
inputs[126] <= 1'b1;
inputs[127] <= 1'b0;
					
				end
			else if(valid && (!reset))
				begin
					if(index <= 127)
						begin
							index  <= index + 1;
							main   <= inputs[index];
							flag	 <= 1'b0;
						end
					else
						begin
							main <= 1'b0;
							flag <= 1'b1;
						end
				end 
		end


endmodule
