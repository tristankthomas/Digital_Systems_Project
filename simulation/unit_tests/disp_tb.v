`timescale 1ns/1ns
`define PERIOD 20
`define HALF_PERIOD 10

module disp_tb;
	reg clk = 0;
	wire enable = 1;
	wire resetn = 1;
	
	
	// clock
	initial begin
		forever
			#`HALF_PERIOD clk = !clk;
	end
	
	counter inst
	(
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.done(done)
	);
	
	initial 
		$monitor("done changed to %b and occured at time %t\n", done, $time);
	
endmodule
	