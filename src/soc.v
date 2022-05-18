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
	output wire [7:0] ip				// output from soc (displayed on left 2 displays in hex)
);


	// synchronising and falling edge detection for all push buttons
	
	wire [3:0] gpi_edge;
	
	generate
		genvar i;
		for (i = 0; i < 4; i = i + 1)
			begin :pb_edge
				falling_edge_detector pb0
				(
					.clk(clk),
					.in(gpi[i]),
					.out(gpi_edge[i])
				);
			end
	endgenerate
	
	// debounding and synchronising din switches
	
	wire [7:0] din_sync;
	
	generate
		genvar j;
		for (j = 0; j < 8; j = j + 1)
			begin :sw
			debounce
			#(
				.CLK_PERIOD_ns(20),
				.DEBOUNCE_TIMER_ns(30_000_000)
			)
			sw0
			(
				.clk(clk),
				.enable(1'd1),
				.resetn(resetn_deb),
				.sig_i(din[j]),
				.sig_o(din_sync[j])
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
		.ENABLE_CNT(20_000_000)		// higher means slower displaying speed
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
	wire [7:0] flag;
	assign debug = {flag[3], flag[2], flag[1], flag[0]};
	
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
		.din(din_reg),
		.gpi(gpi_edge),
		// Outputs
		.reg_dout(dout),
		.reg_gout(gout),
		.reg_flag(flag),
		);
		
	assign dval = gout[7];
	assign gpo = gout[5:0];
	
	reg [7:0] din_reg;
	
	always @(posedge clk or negedge resetn_deb)
		if (!resetn_deb)
			din_reg <= 8'd0;
		else if (gpi_edge[3])
			din_reg <= din_sync;
			
		

endmodule



	
	
	
	