`timescale 1ns / 1ps


module Overall_Top(
		input CLK_50MHz,
		input CLK_250MHz,
		input CLK_125MHz,
		input CLK_208MHz,
		input Reset,
		input signed [7:0] Decoder_in0,
		output wire first_seqe,
		output wire [1:0] spike
    );
	 
	 //wire signed [9:0] Decoder_in = 10'b0000000000;
	 
	 reg	first_seq = 0;
	 reg 	start = 0;
	 reg 	[4 : 0] nfft = 5'b00111;
	 reg	nfft_we = 0;
	 reg 	fwd_inv0 = 0;
	 reg 	fwd_inv0_we = 0; 
	 reg 	fwd_inv1 = 0;
	 reg 	fwd_inv1_we = 0; 
	 wire  [17:0] FFT_out_real_I;
	 wire  [17:0] FFT_out_real_Q;
	 reg  FFT_Start_Trigger = 0;
	 
	 ///////
	 reg unload;
	 ///////
	 
	 // Counters:
	 reg	[4:0] Counter_start  = 5'b00000;
	 reg	[7:0] Counter_main_loop = 8'h00;
	 
	 //Flags
	 reg flag_Reset				= 1'b0; // Be sure to instantiate the flags
	 reg flag_start_1				= 1'b0;
	 reg flag_start_2				= 1'b0;
	 reg flag_start_3				= 1'b0;
	 reg flag_load					= 1'b0;
	 
	 wire DDS_valid;
	 wire rst_out;
	 wire [9:0] xn_im_I;
	 wire  [9:0] xn_re_I;
	 wire [9:0] xn_im_Q;
	 wire  [9:0] xn_re_Q;
	 wire [6:0] xn_index;
	 wire busy;
	 wire edone;
	 wire done;
	 wire dv;
	 wire rfd;
	 wire Valid;
	 wire load_out;
	 wire [6:0]  xk_index;
	 wire [6:0]  N_Mult;
	 wire [17:0] xk_re_I;
	 wire [17:0] xk_im_I;
	 wire [17:0] xk_re_Q;
	 wire [17:0] xk_im_Q;
	 wire signed [17:0] Each_Dot_Value_I;
	 wire signed [17:0] Each_Dot_Value_Q;
	 wire [25:0] final_sum_I;
	 wire [25:0] final_sum_Q;
	 wire [9:0] PISO_I;
	 wire [9:0] PISO_Q;
	 wire s_axis_data_tvalid_16_I;
	 wire s_axis_data_tvalid_16_Q;
	 wire s_axis_data_tvalid_8_I;
	 wire s_axis_data_tvalid_8_Q;
	 wire m_axis_data_tvalid_16_I;
	 wire m_axis_data_tvalid_16_Q;
	 wire m_axis_data_tvalid_8_I;
	 wire m_axis_data_tvalid_8_Q;
	 wire signed [9:0] I;
	 wire signed [9:0] Q;
	 wire s_axis_data_tready_16_I;
	 wire s_axis_data_tready_16_Q;
	 wire s_axis_data_tready_8_I;
	 wire s_axis_data_tready_8_Q;
	 wire [15:0] m_axis_data_tdata_16_I;
	 wire [15:0] m_axis_data_tdata_16_Q;
	 wire [15:0] m_axis_data_tdata_8_I;
	 wire [15:0] m_axis_data_tdata_8_Q;
	 wire [15:0] s_axis_data_tdata_16_I;
	 wire [15:0] s_axis_data_tdata_16_Q;
	 wire [15:0] s_axis_data_tdata_8_I;
	 wire [15:0] s_axis_data_tdata_8_Q;
	 wire [7:0] PISO_counter;
	 wire [7:0] current_state;
	 wire [7:0] output_gain;
	 wire [19:0] integrator_out;
	 wire out_v;
	 wire [23:0] input_DDS_final;
	 wire [15:0] m_axis_data_tdata_sine;
	 wire [15:0] m_axis_data_tdata_cosine;
	 wire m_axis_data_tvalid_sine;
	 wire m_axis_data_tvalid_cosine;
	 wire [9:0] bI;
	 wire [9:0] bQ;
	 wire signed [19:0] Mult_out_I1;
	 wire signed [19:0] Mult_out_Q1;
	 wire signed [9:0] Mult_out_I2;
	 wire signed [9:0] Mult_out_Q2;
	 wire signed [1:0] spike_I;
	 wire signed [1:0] spike_Q;
	 wire signed [9:0] Decoder_in;
	 
	 assign Decoder_in = {Decoder_in0[7:0] , 2'b00};
	 assign first_seqe = first_seq;
	 
	 assign spike_I = (final_sum_I > 26'b00000000001000011011000100) ? 2'b01 : ((~final_sum_I + 1'b1) > 26'b00000000001000011011000100) ? 2'b11 : 2'b00;
	 assign spike_Q = (final_sum_Q > 26'b00000000001000011011000100) ? 2'b01 : ((~final_sum_Q + 1'b1) > 26'b00000000001000011011000100) ? 2'b11 : 2'b00;
	 assign spike   = spike_I + spike_Q;
	 
	 assign Mult_out_I2 = Mult_out_I1[19:10];
	 assign Mult_out_Q2 = Mult_out_Q1[19:10];
	 
	 assign bI = m_axis_data_tdata_sine[9:0];
	 assign bQ = m_axis_data_tdata_cosine[9:0];
	 
	 assign xn_im_I = 10'b0000000000;
	 assign xn_im_Q = 10'b0000000000;
	 
	 assign FFT_out_real_I = ((dv) && (unload)) ? xk_re_I : {18{1'b0}};
	 assign FFT_out_real_Q = ((dv) && (unload)) ? xk_re_Q : {18{1'b0}};
	 
	 assign Decoder_output_I = Each_Dot_Value_I;
	 assign Decoder_output_Q = Each_Dot_Value_Q;
	 
	 assign xn_re_I = PISO_I;
	 assign xn_re_Q = PISO_Q;
	 
	 assign input_DDS_final = {{4{integrator_out[19]}},{integrator_out[19:0]}};
	 
	 assign s_axis_data_tvalid_8_I = m_axis_data_tvalid_16_I;
	 assign s_axis_data_tvalid_8_Q = m_axis_data_tvalid_16_Q;
	 
	 
	 assign s_axis_data_tvalid_16_I = 1'b1;
	 assign s_axis_data_tvalid_16_Q = 1'b1;
	 
	 assign s_axis_data_tdata_16_I = (!Reset) ? { {6{Mult_out_I2[9]}}, {Mult_out_I2[9:0]}} : 16'h0000;
	 assign s_axis_data_tdata_16_Q = (!Reset) ? { {6{Mult_out_Q2[9]}}, {Mult_out_Q2[9:0]}} : 16'h0000;
	 
	 assign s_axis_data_tdata_8_I  = m_axis_data_tdata_16_I;
	 assign s_axis_data_tdata_8_Q  = m_axis_data_tdata_16_Q;
	 
	 //assign I = ~m_axis_data_tdata_8_I + 1'b1;
	 //assign Q = ~m_axis_data_tdata_8_Q + 1'b1;
	 assign I = m_axis_data_tdata_8_I;
	 assign Q = m_axis_data_tdata_8_Q;
	 
	 assign DDS_valid = (!rst_out) ? 1 : 0;
	 
always@(posedge CLK_250MHz)
	begin
		if(rst_out)
			begin
				// Reset the variables here:
				flag_Reset <= 1'b1;
				start	<= 1'b0;
				// Reset nfft
				fwd_inv0 <= 1'b0;
				fwd_inv0_we <= 1'b0;
				fwd_inv1 <= 1'b0;
				fwd_inv1_we <= 1'b0;
				nfft <= 5'b00111;  
				nfft_we <= 1'b1;
				FFT_Start_Trigger <= 0;
				Counter_start <= 1'b0;
				unload <= 1'b0;
			end
		else if((!rst_out) && (Counter_start < 5'b10000))
			begin
				start	<= 1'b0;
				flag_start_1 <= 1'b1;
				flag_Reset <= 1'b0;
				fwd_inv0 <= 1'b0;
				fwd_inv0_we <= 1'b1;
				fwd_inv1 <= 1'b0;
				fwd_inv1_we <= 1'b1;
				nfft <= 5'b00111;  
				nfft_we <= 1'b1;
				Counter_start <= Counter_start + 1'b1;
				if(PISO_counter > 8'b01111110)
					begin
						first_seq <= 1;
					end
			end
		else if((!rst_out) && (Counter_start > 5'b01111) && (Counter_start < 5'b11111))
			begin
				start	<= 1'b0;
				flag_start_2 <= 1'b1;
				fwd_inv0 <= 1'b0;
				fwd_inv0_we <= 1'b0;
				fwd_inv1 <= 1'b0;
				fwd_inv1_we <= 1'b0;
				nfft <= 5'b00111;  
				nfft_we <= 1'b0;
				Counter_start <= Counter_start + 1'b1;
				unload <= 1'b1;
				if(PISO_counter > 8'b01111110)
					begin
						first_seq <= 1;
					end
			end
		else if((!rst_out) && (Counter_start == 5'b11111))
			begin
				if(PISO_counter > 8'b01111111)
					begin
						first_seq <= 1;
					end 
				
				if(m_axis_data_tvalid_8_I)
					begin
						flag_load <= 1'b1;
					end
					
					
				if(flag_load)
					begin
						flag_load <= 1'b0;
					end
					
					
				if(first_seq && load_out)
					begin
						FFT_Start_Trigger <= 1;
					end
				start	<= first_seq && load_out && FFT_Start_Trigger;
				flag_start_3 <= 1'b1;
				unload <= 1'b1;
				Counter_main_loop <= Counter_main_loop + 1'b1;
				if(Counter_main_loop < 8'b10000000 ) 
					begin
						//xn_re_I <= PISO_I;
						//xn_re_Q <= PISO_Q;
						Counter_main_loop <= Counter_main_loop + 1'b1;
					end
				else
					begin
						//xn_re_I <= PISO_I;
						//xn_re_Q <= PISO_Q;
						Counter_main_loop <= 8'h01;
					end
			end
				
	end

Super_FFT FFT (
  .clk(CLK_250MHz), // input clk
  .nfft(nfft), // input [4 : 0] nfft
  .nfft_we(nfft_we), // input nfft_we
  .start(start), // input start
  .unload(unload), // input unload
  .xn0_re(xn_re_I), // input [9 : 0] xn0_re
  .xn0_im(xn_im_I), // input [9 : 0] xn0_im
  .xn1_re(xn_re_Q), // input [9 : 0] xn1_re
  .xn1_im(xn_im_Q), // input [9 : 0] xn1_im
  .fwd_inv0(fwd_inv0), // input fwd_inv0
  .fwd_inv0_we(fwd_inv0_we), // input fwd_inv0_we
  .fwd_inv1(fwd_inv1), // input fwd_inv1
  .fwd_inv1_we(fwd_inv1_we), // input fwd_inv1_we
  .rfd(rfd), // output rfd
  .xn_index(xn_index), // output [6 : 0] xn_index
  .busy(busy), // output busy
  .edone(edone), // output edone
  .done(done), // output done
  .dv(dv), // output dv
  .xk_index(xk_index), // output [6 : 0] xk_index
  .xk0_re(xk_re_I), // output [17 : 0] xk0_re
  .xk0_im(xk_im_I), // output [17 : 0] xk0_im
  .xk1_re(xk_re_Q), // output [17 : 0] xk1_re
  .xk1_im(xk_im_Q) // output [17 : 0] xk1_im
);
	 
	 Dot_Product_Multiplier Dot_Mult (
    .clk(CLK_250MHz), 
    .rst(rst_out), 
    .FFT_out_I(FFT_out_real_I), 
    .FFT_out_Q(FFT_out_real_Q), 
    .Sequential_Dot_Variable(Sequential_Dot_Variable), 
    .Sequential_Dot_Sign(Sequential_Dot_Sign), 
    .N_cnt(xk_index), 
    .Each_Dot_Value_I(Each_Dot_Value_I), 
    .Each_Dot_Value_Q(Each_Dot_Value_Q), 
    .Valid(Valid), 
    .Packet_Done(Packet_Done), 
    .N_Mult(N_Mult)
    );	 
	 
	 
Adder adder (
    .clk(CLK_250MHz), 
    .reset(rst_out), 
	 .Valid(dv),
    .Mult_out_I(Each_Dot_Value_I), 
    .Mult_out_Q(Each_Dot_Value_Q), 
    .Mult_N(N_Mult), 
    .final_sum_I(final_sum_I), 
    .final_sum_Q(final_sum_Q), 
    .final_sum_ready(final_sum_ready), 
    .current_state(current_state)
    );	 
	 
RAM_Decoding RAM (
    .clk(CLK_250MHz), 
    .reset(rst_out), 
    .N(xk_index), 
    .Sequential_Dot_Variable(Sequential_Dot_Variable), 
    .Sequential_Dot_Sign(Sequential_Dot_Sign), 
    .Sequence_Done(Sequence_Done)
    );
	 
PISO piso_input (
    .clk(CLK_250MHz), 
    .Reset(rst_out), 
    .load(flag_load),
	 .first_sequence(first_seq),
    .data_valid_FFT(rfd), 
    .DC_in_I(I), 
    .DC_in_Q(Q), 
    .PISO_I(PISO_I), 
    .PISO_Q(PISO_Q),
	 .load_out(load_out),
	 .PISO_counter(PISO_counter)
    );
	 
FIR1 FIR_16_I (
  .aclk(CLK_125MHz), // input aclk
  .s_axis_data_tvalid(s_axis_data_tvalid_16_I), // input s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready_16_I), // output s_axis_data_tready
  .s_axis_data_tdata(s_axis_data_tdata_16_I), // input [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_16_I), // output m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata_16_I) // output [15 : 0] m_axis_data_tdata
);

FIR1 FIR_16_Q (
  .aclk(CLK_125MHz), // input aclk
  .s_axis_data_tvalid(s_axis_data_tvalid_16_Q), // input s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready_16_Q), // output s_axis_data_tready
  .s_axis_data_tdata(s_axis_data_tdata_16_Q), // input [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_16_Q), // output m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata_16_Q) // output [15 : 0] m_axis_data_tdata
);

FIR2 FIR_8_I (
  .aclk(CLK_125MHz), // input aclk
  .s_axis_data_tvalid(s_axis_data_tvalid_8_I), // input s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready_8_I), // output s_axis_data_tready
  .s_axis_data_tdata(s_axis_data_tdata_8_I), // input [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_8_I), // output m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata_8_I) // output [15 : 0] m_axis_data_tdata
);


FIR2 FIR_8_Q (
  .aclk(CLK_125MHz), // input aclk
  .s_axis_data_tvalid(s_axis_data_tvalid_8_Q), // input s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready_8_Q), // output s_axis_data_tready
  .s_axis_data_tdata(s_axis_data_tdata_8_Q), // input [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_8_Q), // output m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata_8_Q) // output [15 : 0] m_axis_data_tdata
);

Main_VCO PLL (
    .clk(CLK_50MHz), 
    .start(start), 
    .input_I(final_sum_I), 
    .input_Q(final_sum_Q), 
    .abs_I(abs_I), 
    .abs_Q(abs_Q), 
    .input_mult(input_mult), 
    .output_mult(output_mult), 
	 .output_gain(output_gain),
    .abs_comparator(abs_comparator),
	 .out_v(out_v)
    );
	 
Integrator_DDS Int_DDS (
    .clk(CLK_50MHz), 
    .reset(rst_out),
	 .in_valid(out_v),
    .integrator_in(output_gain), 
    .integrator_out(integrator_out)
    );
	 
	 DDS DDS1 (
  .aclk(CLK_208MHz), // input aclk
  .s_axis_phase_tvalid(DDS_valid), // input s_axis_phase_tvalid
  .s_axis_phase_tdata(input_DDS_final), // input [23 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_sine), // output m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata_sine) // output [15 : 0] m_axis_data_tdata
);

DDS_2 DDS2_cosine (
  .aclk(CLK_208MHz), // input aclk
  .s_axis_phase_tvalid(DDS_valid), // input s_axis_phase_tvalid
  .s_axis_phase_tdata(input_DDS_final), // input [23 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_cosine), // output m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata_cosine) // output [15 : 0] m_axis_data_tdata
);

multiplier_DDS Mult_I1 (
  .clk(CLK_208MHz), // input clk
  .a(Decoder_in), // input [9 : 0] a
  .b(bI), // input [9 : 0] b
  .p(Mult_out_I1) // output [19 : 0] p
);

multiplier_DDS Mult_Q1 (
  .clk(CLK_208MHz), // input clk
  .a(Decoder_in), // input [9 : 0] a
  .b(bQ), // input [9 : 0] b
  .p(Mult_out_Q1) // output [19 : 0] p
);

Reset_module rst (
    .clk(CLK_125MHz), 
    .rst_in(Reset), 
    .rst_out(rst_out)
    );

	 
//Clock_Wizard CW
//   (// Clock in ports
//    .CLK_IN1(clk),      // IN
//    // Clock out ports
//    .CLK_OUT1(CLK_50MHz),     // OUT
//    .CLK_OUT2(CLK_100MHz),     // OUT
//    .CLK_OUT3(CLK_250MHz),     // OUT
//    .CLK_OUT4(CLK_125MHz),
//	 .CLK_OUT5(CLK_208MHz));    // OUT
	 	 

endmodule

