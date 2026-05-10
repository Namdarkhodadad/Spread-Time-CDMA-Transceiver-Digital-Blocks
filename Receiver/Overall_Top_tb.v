`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:	Nommy Khodadad
//
// Create Date:   13:37:36 12/28/2024
// Design Name:   Overall_Top
// Module Name:   C:/Users/nommy/Desktop/ISE/Digital_Blocks_with_PLL/Overall_Top_tb.v
// Project Name:  Digital_Blocks_with_PLL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Overall_Top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Overall_Top_tb;

	// Inputs
	reg clk;
	reg Reset;
	reg clk2;
	//reg signed [9:0] Decoder_input_I;
	//reg signed [9:0] Decoder_input_Q;
	reg signed [9:0] Decoder_in;
	
	// Outputs
	wire signed [9:0] Mult_out_I2;
	wire signed [9:0] Mult_out_Q2;
	wire signed [25:0] Accumulated_I;
	wire signed [25:0] Accumulated_Q;
	wire signed [51:0] h;
	wire signed [9:0] bI;
	wire signed [9:0] bQ;
	wire signed [9:0] firi;
	wire signed [9:0] firq;
	wire rfd;

	// Instantiate the Unit Under Test (UUT)
	Overall_Top uut (
		.clk(clk), 
		.Reset(Reset), 
		//.Decoder_input_I(Decoder_input_I), 
		//.Decoder_input_Q(Decoder_input_Q),
		.Decoder_in(Decoder_in),
		.main_I(bI),
		.main_Q(bQ),
		.Mult_out_I2(Mult_out_I2),
		.Mult_out_Q2(Mult_out_Q2),
		.Accumulated_I(Accumulated_I),
		.Accumulated_Q(Accumulated_Q),
		.I(firi),
		.Q(firq),
		.h(h),
		.rfd(rfd)
	);
//Clock gen 
	initial begin
		clk = 0;
		forever #10 clk = ~clk;
	end
	
	initial begin
		clk2 = 0;
		forever #24 clk2 = ~clk2;
	end
	//To create outputfile if needed
	integer outfile_I;
	integer outfile_Q;
	integer infile;
	integer infile_I;
	integer infile_Q;
	integer DDS_I;
	integer DDS_Q;
	integer FIR_I;
	integer FIR_Q;
	//Test inputs
		integer i;
		integer j;
		//reg signed [9:0] test_inputs_I [0:500000];
		//reg signed [9:0] test_inputs_Q [0:500000];
		reg signed [9:0] test_inputs [0:400000];
	initial begin
		// Initialize Inputs
		clk = 0;
		Reset = 1;
		
		//$readmemb("insI.bin" , test_inputs_I); //binary
		//$readmemb("insQ.bin" , test_inputs_Q); //binary
		$readmemb("intake11.bin" , test_inputs); //binary
		outfile_I		   = $fopen("outfile_I.txt" , "w");
		outfile_Q		   = $fopen("outfile_Q.txt" , "w");
		infile  				= $fopen("infile.txt" , "w");
		infile_I  			= $fopen("infile_I.txt" , "w");
		infile_Q  			= $fopen("infile_Q.txt" , "w");
		DDS_I					= $fopen("DDS_I.txt" , "w");
		DDS_Q					= $fopen("DDS_Q.txt" , "w");
		FIR_I					= $fopen("FIR_I.txt" , "w");
		FIR_Q					= $fopen("FIR_Q.txt" , "w");

		// Wait 100 ns for global reset to finish
		#100;
		Reset = 0;
		//Loading inputs
		for(i=0 ; i<400000 ; i = i+1) begin
					Decoder_in = test_inputs[i];
					//Decoder_input_I = test_inputs_I[i];
					//Decoder_input_Q = test_inputs_Q[i];
					//if(i>126)
					//	begin
					//		first_seq = 1'b1;
					//	end
					//#4;
					#48;
		end
        
		// Add stimulus here
		
		// Close files
		 $fclose(outfile_I);
		 $fclose(outfile_Q);
		 $fclose(infile);
		 $fclose(infile_I);
		 $fclose(infile_Q);
		 $fclose(DDS_I);
		 $fclose(DDS_Q);

	end
      
		//monitor outputs and write to file
	always@(posedge clk2) begin
					$fwrite(outfile_I   , "%d\n" ,Accumulated_I);
					$fwrite(outfile_Q   , "%d\n" ,Accumulated_Q);
					$fwrite(infile	  , "%d\n" , Decoder_in);
					$fwrite(infile_I	  , "%d\n" , Mult_out_I2);
					$fwrite(infile_Q	  , "%d\n" , Mult_out_Q2);
					$fwrite(DDS_I	  , "%b\n" , bI);
					$fwrite(DDS_Q	  , "%b\n" , bQ);
					$fwrite(FIR_I	  , "%d\n" , firi);
					$fwrite(FIR_Q	  , "%d\n" , firq);
	end
		
endmodule

