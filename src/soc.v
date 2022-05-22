/* Aids the communication between the inputs/outputs, CPU and instruction memory */

`default_nettype none
`define LONG_PRESS_TIMER 600_000_000 //ns
`define DEBOUND_TIMER 	 30_000_000	 //ns
`define CLK_PERIOD 		 20			 //ns
`define ENABLE_CNT		 20_000_000  //ns

module soc 
(
	input wire  clk,					// 50MHz clock
	input wire  resetn,  				// connected to left most switch
	input wire  turbo_mode,			// connected to second left most switch
	output wire mode,

	// GPIO
	input wire  [3:0] gpi,			// connected to right 4 push buttons
	output wire [5:0] gpo,			// connected to right 6 leds

	// Data Bus
	input wire  [7:0] din,			// connected to right 8 switches
	output wire [7:0] dout,			// output from soc (displayed on right 4 displays)
	output wire dval,					// used as enable for dout (not displayed)

	output wire [3:0] debug,		// connected to left 4 leds
	output wire [7:0] ip				// output from soc (displayed on left 2 displays in hex)
);

	// used to signify when a long press is triggered 
	assign debug = gpi_long;
	
	
	wire [3:0]gpi_long;
	wire [3:0]gpi_long_edge;

	// detecting long press of pbs
		generate
		genvar i;
		for (i = 0; i < 4; i = i + 1)
			begin :pb_long
				long_press_detect
				#(
					.CLK_PERIOD_ns(20),
					.PRESS_TIMER_ns(`LONG_PRESS_TIMER)
				)
				pbl0
				(
					.clk(clk),
					.in(gpi[i]),
					.resetn(resetn_deb),
					.out(gpi_long[i])
				);
				
				rising_edge_detector pble0
				(
					.clk(clk),
					.in(gpi_long[i]),
					.out(gpi_long_edge[i])
				);
			end
	endgenerate
	
	assign mode = disp_mode;
	
	wire disp_mode;
	
	// toggles between display modes based on rising edge of gpi_long_edge
	mode_toggler mode_insta
	(
		.trigger(gpi_long_edge[3]),
		.mode_num(disp_mode)
	);
	
	
	// synchronising and falling edge detection for all push buttons
	wire [3:0] gpi_edge;
	
	generate
		genvar j;
		for (j = 0; j < 4; j = j + 1)
			begin :pb_edge
				falling_edge_detector pb0
				(
					.clk(clk),
					.in(gpi[j]),
					.out(gpi_edge[j])
				);
			end
	endgenerate
	
	
	// debouncing and synchronising din switches
	wire [7:0] din_sync;
	
	generate
		genvar k;
		for (k = 0; k < 8; k = k + 1)
			begin :sw
			debounce
			#(
				.CLK_PERIOD_ns(`CLK_PERIOD),
				.DEBOUNCE_TIMER_ns(`DEBOUNCE_TIMER)
			)
			sw0
			(
				.clk(clk),
				.enable(1'd1),
				.resetn(resetn_deb),
				.sig_i(din[k]),
				.sig_o(din_sync[k])
			);
			end
	endgenerate
	
	
	// debouncing and synchronising resetn switch
	wire resetn_deb;
	
	debounce
	#(

		.CLK_PERIOD_ns(`CLK_PERIOD),
		.DEBOUNCE_TIMER_ns(`DEBOUNCE_TIMER)
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

		.CLK_PERIOD_ns(`CLK_PERIOD),
		.DEBOUNCE_TIMER_ns(`DEBOUNCE_TIMER)
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
	
	enable_gen
	#(
		.ENABLE_CNT(`ENABLE_CNT)	// higher means slower displaying speed
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
	// grabs instruction specified by ip from cpu
	instruction_memory rom		
		(
			.address(ip),
			.instruction(instruction)
		);
		
		
		
	// cpu instantiation
	wire [8:0] gout;
	wire [7:0] flag;
	
	cpu cpu_insta
		(
		// System
		.clk(clk),
		.enable(enable_out),
		.resetn(resetn_deb),
		.long_press(gpi_long),
		.long_edge(gpi_long_edge),
		// Instructions
		.instruction(instruction),
		.instruction_pointer(ip),
		// Inputs
		.din(din_reg),
		.gpi(gpi_edge),
		// Outputs
		.reg_dout(dout),
		.reg_gout(gout),
		.reg_flag(flag)
		);
	
	// GOUT register connections
	assign dval = gout[7];
	assign gpo = gout[5:0];
	
	// storing the contents of DIN when pb3 is pressed into the register
	reg [7:0] din_reg;
	
	always @(posedge clk or negedge resetn_deb)
		if (!resetn_deb)
			din_reg <= 8'd0;
		else if (gpi_edge[3])
			din_reg <= din_sync;
			
	

endmodule



	
	
	
	