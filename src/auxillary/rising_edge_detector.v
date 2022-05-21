
module rising_edge_detector
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
	
	reg prev; // state
	
	
	always @(posedge clk)
		prev <= in_sync;		// flip-flop and next-state logic
		
	assign out = (!prev && in_sync);	// output logic
	
	
endmodule
