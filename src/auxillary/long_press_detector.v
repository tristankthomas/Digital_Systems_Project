/* Detects when a push button is held in for a certain amount of time */

module long_press_detect
#(
	parameter CLK_PERIOD_ns = 20,
	parameter PRESS_TIMER_ns = 500
	
)
(
	input wire clk, in, resetn,
	output wire out
	
);

	wire in_sync;
	wire done;
	wire reset;
	
	// synchroniser instantiation
	synchroniser sync
	(
		.clk(clk),
		.in(in),
		.in_sync(in_sync)
	);
	
	// counter instantiation
	counter
	#(
		.TIMER_PERIOD_ns(PRESS_TIMER_ns),
		.CLK_PERIOD_ns(CLK_PERIOD_ns)
	)
	count_insta
	(
		.clk(clk),
		.reset_sync(reset),
		.resetn(resetn),
		.enable(1),
		.done(done)
	);
		
	// state
	reg prev; 
	
	// flip-flop and next-state logic
	always @(posedge clk)
		prev <= in_sync;		
		
	// output logic
	assign out = done;	
	assign reset = !in_sync;
	
endmodule


		

