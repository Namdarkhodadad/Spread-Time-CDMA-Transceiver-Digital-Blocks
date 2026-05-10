`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nommy Khodadad
// 
// Create Date:    09:28:06 01/07/2025 
// Design Name: 
// Module Name:    Top 
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
module Top(
		input clk,
		input reset,
		input clock2,
		//output wire Clock_20MHz,
		//output wire [19:0] Extention_Header,
		output wire [7:0] to_DAC
		//output reg [3:0] LED
    );
	 
	 wire main;
	 wire [7:0] out_code;
	 wire [7:0] m_axis_data_tdata;
	 wire m_axis_data_tvalid;
	 wire Clock_100MHz;
	 wire Clock_50MHz;
	 wire Clock_20MHz;		
	 //wire [7:0] to_DAC;
	 wire flag;
	 wire [35:0] CONTROL0;
	 wire [7:0] in_DAC;

	 
	 reg [15:0]  cnt = 16'h0000;
	 reg [19:0] counter_main = 20'h00000;
	 reg [9:0] address = 10'b0000000000;
	 reg main_reg;
	 reg valid;
	 reg [7:0] coded = 8'h00;
	 reg [11:0] small_counter = 12'b000000000000;
	 reg [19:0] s_Extention_Header;
	 
	 reg [3:0] LED;
	 wire [19:0] Extention_Header;
	 
	 assign in_DAC = 8'b00000000;
	 
	 always @(posedge CLK_20MHz or posedge reset)
		begin
			if(reset)
				begin
					valid <= 1'b1;
					cnt   <= 16'h0000;
					counter_main <= 20'h00000;
					address <= 10'b0000000000;
					coded <= 8'h00;
					small_counter <= 12'b000000000000;
					LED[0] <= 1'b1;
				end
			else
			begin
				if(counter_main <= 20'h03FFD) //39322-2
				begin 
					LED[0] <= 1'b0;
					valid <= 1'b0;
					small_counter <= small_counter + 1'b1;
					counter_main <= counter_main + 1'b1;
					if(small_counter > 12'b000000011110) //011111111111 0101110
						begin
							address <= address + 1'b1;
							small_counter <= 12'b000000000000;
							cnt   <= cnt + 1'b1;
							if(cnt > 16'h0200)
								begin
									cnt <= 16'h0000;
									address <= 10'b0000000000;
								end
						end
					
					if(main_reg == 0)
						begin
							coded <= ~out_code + 1'b1;
						end
					else
						begin
							coded <= out_code;
						end
				end
				
				else
				begin
					valid <= 1'b1;
					counter_main <= 20'h0000;
					cnt   <= 16'h0000;
					main_reg <= main;
					address <= 10'b0000000000;
					small_counter <= 12'b000000000000;
					coded <= 8'h00;
				end

			end
		end
		
	 Inputs inputs (
    .clk(CLK_20MHz), 
    .reset(reset), 
    .valid(valid), 
	 .flag(flag),
    .main(main)
    );
	 
	 always @ (posedge Clock_100MHz) begin
		if(reset)// || flag)
			s_Extention_Header[0] <= 1'b0;
		else
			s_Extention_Header[0] <= ~s_Extention_Header[0];
			LED[1] <= 1'b0;
			LED[2] <= 1'b0;
			LED[3] <= 1'b0;
	end
	
	always @ (posedge Clock_50MHz) begin
		if(reset)
			s_Extention_Header[8:1] <= 8'b0; //00011000100100110111
		else begin
			s_Extention_Header[1] <= to_DAC[6];
			s_Extention_Header[2] <= ~to_DAC[7];
			s_Extention_Header[3] <= to_DAC[4];
			s_Extention_Header[4] <= to_DAC[5];
			s_Extention_Header[5] <= to_DAC[2];
			s_Extention_Header[6] <= to_DAC[3];
			s_Extention_Header[7] <= to_DAC[0];
			s_Extention_Header[8] <= to_DAC[1];
		end
	end
	
	assign Extention_Header  = s_Extention_Header;
	 
	 Code_RAM RAM (
    .clk(CLK_20MHz),
    .rst(reset),  
    .in_counter(address), 
    .out_code(out_code)
    );
	 
	 DDS DDS (
  .aclk(CLK_20MHz), // input aclk
  .m_axis_data_tvalid(m_axis_data_tvalid), // output m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata) // output [7 : 0] m_axis_data_tdata
);

Mult mult (
  .clk(CLK_20MHz), // input clk
  .a(coded), // input [7 : 0] a
  .b(m_axis_data_tdata), // input [7 : 0] b
  .p(to_DAC) // output [7 : 0] p
);

ICON icon0 (
    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
);

Chip_Scope chipscope (
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .CLK(Clock_50MHz), // IN
    .TRIG0(to_DAC), // IN BUS [7:0]
    .TRIG1(flag), // IN BUS [0:0]
    .TRIG2(reset) // IN BUS [0:0]
);                
	 
  clock_wizard clocks
   (// Clock in ports
    .clk(clk),      // IN
    // Clock out ports
    .CLK_50MHz(CLK_50MHz),     // OUT
    .CLK_20MHz(CLK_20MHz),
	 .CLK_100MHz(CLK_100MHz));    // OUT

endmodule
