
module falling_edge_detector
(
	input clk, in,
	output out
	
);

	reg prev; // state
	
	
	always @(posedge clk)
		prev <= in;		// flip-flop and next-state logic
		
	assign out = (prev && !in);	// output logic
	
	
endmodule
