`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    15:40:34 01/04/2025 
// Design Name: 
// Module Name:    RAM_Decoding 
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
module RAM_Decoding(
		input wire clk,
		input wire reset,
		input wire [6:0] N,
		output Sequential_Dot_Variable,
		output Sequential_Dot_Sign,
		output Sequence_Done
    );
	 
	 reg [1:0] cd [0:127];
	  
	 assign Sequential_Dot_Variable = cd[N][0];
	 assign Sequential_Dot_Sign	  = cd[N][1];
	 assign Sequence_Done			  = (N == 7'b1111111) ? 1'b1 : 1'b0;
	 
	 always @(posedge clk or posedge reset)
		begin
				if(reset)
					begin
cd[0] <= 2'b00;
cd[1] <= 2'b01;
cd[2] <= 2'b11;
cd[3] <= 2'b01;
cd[4] <= 2'b11;
cd[5] <= 2'b11;
cd[6] <= 2'b01;
cd[7] <= 2'b11;
cd[8] <= 2'b01;
cd[9] <= 2'b00;
cd[10] <= 2'b00;
cd[11] <= 2'b00;
cd[12] <= 2'b00;
cd[13] <= 2'b00;
cd[14] <= 2'b00;
cd[15] <= 2'b00;
cd[16] <= 2'b00;
cd[17] <= 2'b00;
cd[18] <= 2'b00;
cd[19] <= 2'b00;
cd[20] <= 2'b00;
cd[21] <= 2'b01;
cd[22] <= 2'b11;
cd[23] <= 2'b01;
cd[24] <= 2'b11;
cd[25] <= 2'b11;
cd[26] <= 2'b01;
cd[27] <= 2'b01;
cd[28] <= 2'b11;
cd[29] <= 2'b01;
cd[30] <= 2'b11;
cd[31] <= 2'b01;
cd[32] <= 2'b11;
cd[33] <= 2'b00;
cd[34] <= 2'b00;
cd[35] <= 2'b00;
cd[36] <= 2'b00;
cd[37] <= 2'b00;
cd[38] <= 2'b00;
cd[39] <= 2'b00;
cd[40] <= 2'b00;
cd[41] <= 2'b00;
cd[42] <= 2'b00;
cd[43] <= 2'b00;
cd[44] <= 2'b00;
cd[45] <= 2'b00;
cd[46] <= 2'b00;
cd[47] <= 2'b00;
cd[48] <= 2'b00;
cd[49] <= 2'b00;
cd[50] <= 2'b00;
cd[51] <= 2'b00;
cd[52] <= 2'b00;
cd[53] <= 2'b00;
cd[54] <= 2'b00;
cd[55] <= 2'b00;
cd[56] <= 2'b00;
cd[57] <= 2'b00;
cd[58] <= 2'b00;
cd[59] <= 2'b00;
cd[60] <= 2'b00;
cd[61] <= 2'b00;
cd[62] <= 2'b00;
cd[63] <= 2'b00;
cd[64] <= 2'b00;
cd[65] <= 2'b00;
cd[66] <= 2'b00;
cd[67] <= 2'b00;
cd[68] <= 2'b00;
cd[69] <= 2'b00;
cd[70] <= 2'b00;
cd[71] <= 2'b00;
cd[72] <= 2'b00;
cd[73] <= 2'b00;
cd[74] <= 2'b00;
cd[75] <= 2'b00;
cd[76] <= 2'b00;
cd[77] <= 2'b00;
cd[78] <= 2'b00;
cd[79] <= 2'b00;
cd[80] <= 2'b00;
cd[81] <= 2'b00;
cd[82] <= 2'b00;
cd[83] <= 2'b00;
cd[84] <= 2'b00;
cd[85] <= 2'b00;
cd[86] <= 2'b00;
cd[87] <= 2'b00;
cd[88] <= 2'b00;
cd[89] <= 2'b00;
cd[90] <= 2'b00;
cd[91] <= 2'b00;
cd[92] <= 2'b00;
cd[93] <= 2'b00;
cd[94] <= 2'b00;
cd[95] <= 2'b00;
cd[96] <= 2'b11;
cd[97] <= 2'b01;
cd[98] <= 2'b11;
cd[99] <= 2'b01;
cd[100] <= 2'b11;
cd[101] <= 2'b01;
cd[102] <= 2'b01;
cd[103] <= 2'b11;
cd[104] <= 2'b11;
cd[105] <= 2'b01;
cd[106] <= 2'b11;
cd[107] <= 2'b01;
cd[108] <= 2'b00;
cd[109] <= 2'b00;
cd[110] <= 2'b00;
cd[111] <= 2'b00;
cd[112] <= 2'b00;
cd[113] <= 2'b00;
cd[114] <= 2'b00;
cd[115] <= 2'b00;
cd[116] <= 2'b00;
cd[117] <= 2'b00;
cd[118] <= 2'b00;
cd[119] <= 2'b00;
cd[120] <= 2'b01;
cd[121] <= 2'b11;
cd[122] <= 2'b01;
cd[123] <= 2'b11;
cd[124] <= 2'b11;
cd[125] <= 2'b01;
cd[126] <= 2'b11;
cd[127] <= 2'b01;
					end
		end
	 

endmodule
