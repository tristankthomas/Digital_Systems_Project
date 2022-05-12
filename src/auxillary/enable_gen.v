module enable_gen
#(
	parameter ENABLE_CNT = 20_000_000
)
(
	input clk, resetn, mode,
	output enable_out
);
	parameter size = $clog2(ENABLE_CNT);
	
	reg [size:0] count = ENABLE_CNT;
	
	// next_state logic
	
	always @(posedge clk or negedge resetn) begin
		if (!resetn)
			count <= ENABLE_CNT;
		else begin
			if (count == 0) 
				count <= ENABLE_CNT;
			else
				count <= count - 1;
		end
		
	end
	
	// output logic
	
	assign enable_out = mode ? 1'b1 : count == 0;
	
endmodule
			