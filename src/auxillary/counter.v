module counter
(
	input clk,
	input enable,
	input resetn,
	output done
);
	reg [22:0] count = 0;
	
	// states

	
	// flip flop
	always @(posedge clk or negedge resetn) begin
		if (!resetn)
			count <= 0;
		else begin
			if (enable)
				count <= count + 1;
			else
				count <= 0;
		end
	end
	
	
	assign done = (count == 0) ? 1 : 0;
	
endmodule
		