/* Falling edge detector used to detect when a push button is released */

module falling_edge_detector
(
	input wire clk, in,
	output wire out
	
);

	wire in_sync;
	
	synchroniser sync
	(
		.clk(clk),
		.in(in),
		.in_sync(in_sync)
	);
	
	// state
	reg prev; 
	
	// flip-flop and next-state logic
	always @(posedge clk)
		prev <= in_sync;		
	
	// output logic
	assign out = (prev && !in_sync);	
	
	
endmodule
