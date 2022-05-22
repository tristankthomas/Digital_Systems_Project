`default_nettype none
`include "top_level_definitions.vh"
module top 
(
	
	// Clock 50MHz
	input	wire CLOCK_50,         // DE-series 50 MHz clock signal
	
	// Inputs
    input wire [9:0] SW,        // DE-series switches
	
    input wire [3:0] KEY,       // DE-series pushbuttons
	
	// Outputs
    output wire [9:0] LEDR,     // DE-series LEDs   
	
    output wire [6:0] HEX0,     // DE-series HEX displays
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5 
 );
	 // outputs from soc that are displayed on HEX
	 wire [7:0] dout;
	 wire dval;
	 wire [7:0] ip;
	 wire disp_mode;
	 
	// Instantiate system on chip module
	soc soc_t
	(	
		.clk(CLOCK_50), 
		.resetn(~SW[9]), 
		.turbo_mode(SW[8]),
		.mode(disp_mode),
		.gpi(~KEY[3:0]), 
		.gpo(LEDR[5:0]), 
		.din(SW[7:0]), 
		.dout(dout),	// output
		.dval(dval),	// output
		.debug(LEDR[9:6]), 
		.ip(ip)	// output
	);
		
	// Instantiate display modules
	disp_dout snum_disp
	(
		.x(dout), 
		.enable(dval),
		.mode(disp_mode),
		.disp0(HEX0), 
		.disp1(HEX1),
		.disp2(HEX2), 
		.disp3(HEX3)
	);
	
	disp_hex ip_disp
	(
		.data_in(ip),
		.turbo_mode(SW[8]),
		.disp0(HEX4), 
		.disp1(HEX5)
	);
	
endmodule 
