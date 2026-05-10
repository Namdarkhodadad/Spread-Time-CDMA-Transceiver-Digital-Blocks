`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:33:51 01/07/2025
// Design Name:   Top
// Module Name:   C:/Users/nommy/Desktop/ISE/transmitter_2/Top_tb.v
// Project Name:  transmitter_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Top_tb;

	// Inputs
	reg clk;
	reg reset;
	reg clock2;

	// Outputs
	wire signed [7:0] to_DAC;
	wire signed [9:0] to_DAC2;
	
	assign to_DAC2 = {{to_DAC[7:0]} , 2'b00};

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.clk(clk), 
		.clock2(clock2),
		.reset(reset), 
		//.Clock_20MHz(clock2),
		.to_DAC(to_DAC)
	);
	
	//Clock gen 
	initial begin
		clk = 0; 
		forever #10 clk = ~clk ;
	end
	
	initial begin
		clock2 = 0;
		forever #24 clock2 = ~clock2;
	end
	
	integer outfile;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		
		outfile		   = $fopen("outfile.txt" , "w");
		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
        
		  
		  #70000000;
		// Add stimulus here
		 $fclose(outfile);

	end
			always@(posedge clock2) begin
					$fwrite(outfile   , "%b\n" ,to_DAC2);
	end
	  
endmodule

