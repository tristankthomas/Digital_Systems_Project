`default_nettype none


module soc 
(
	input wire clk,					// 50MHz clock
	input wire resetn,  				// connected to left most switch
	input wire turbo_mode,			// connected to second left most switch

	// GPIO
	input wire [3:0] gpi,			// connected to right 4 push buttons
	output wire [5:0] gpo,			// connected to right 6 leds

	// Data Bus
	input wire [7:0] din,			// connected to right 8 switches
	output wire [7:0] dout,			// output from soc (displayed on right 4 displays)
	output wire dval,					// used as enable for dout (not displayed)

	output wire [3:0] debug,		// connected to left 4 leds
	output wire [7:0] ip			// output from soc (displayed on left 2 displays in hex)
);


	// synchronising all push buttons
	genvar i;
	wire [3:0] gpi_sync;
	
	generate
		for (i = 0; i < 4; i = i + 1)
			begin :pbs
				synchroniser 
				#(
					.n(1)
				)
				s0
				(
					.clk(clk),
					.in(gpi[i]),
					.in_sync(gpi_sync[i])
				);
			end
	endgenerate
	
	// debounding and synchronising din switches
	genvar j;
	wire [7:0] din_sync;
	
	generate
		for (j = 0; j < 8; j = j + 1)
			begin :sw
			debounce
			#(

				.CLK_PERIOD_ns(20),
				.DEBOUNCE_TIMER_ns(30_000_000)
			)
			deb_sw
			(
				.clk(clk),
				.enable(1'd1),
				.resetn(resetn_deb),
				.sig_i(din[i]),
				.sig_o(din_sync[i])
			);
			end
	endgenerate
	
	// debouncing and synchronising resetn switch
	wire resetn_deb;
	
	debounce
	#(

		.CLK_PERIOD_ns(20),
		.DEBOUNCE_TIMER_ns(30_000_000)
	)
	deb_res
	(
		.clk(clk),
		.enable(1'd1),
		.resetn(1'd1),
		.sig_i(resetn),
		.sig_o(resetn_deb)
	);
	
	// debouncing and synchronising turbo switch
	wire turbo_mode_deb;
	
	debounce
	#(

		.CLK_PERIOD_ns(20),
		.DEBOUNCE_TIMER_ns(30_000_000)
	)
	deb_tur 
	(
		.clk(clk),
		.enable(1'd1),
		.resetn(1'b1),
		.sig_i(turbo_mode),
		.sig_o(turbo_mode_deb)
	);
	
	// instansiating enable_gen
	wire enable_out;
	
	enable_gen		// converts the turbo switch to enable
	#(
		.ENABLE_CNT(20_000_000)
	)
	enb
	(
		.clk(clk),
		.resetn(resetn_deb),
		.mode(turbo_mode_deb),
		.enable_out(enable_out)
	);
	
	
	// read only memory instantiation
	wire [31:0] instruction;
	
	instruction_memory rom		// grabs instruction specified by ip from cpu
		(
			.address(ip),
			.instruction(instruction)
		);
		
		
		
	// cpu instantiation
	wire [8:0] gout;
	
	cpu cpu_insta
		(
		// System
		.clk(clk),
		.enable(enable_out),
		.resetn(resetn_deb),
		// Instructions
		.instruction(instruction),
		.instruction_pointer(ip),
		// Inputs
		.din(),
		.gpi(),
		// Outputs
		.reg_dout(dout),
		.reg_gout(gout),
		.reg_flag()
		);
		
		assign dval = (!resetn_deb) ? 1'b0 : gout[7];
		

endmodule



	
	
	
	