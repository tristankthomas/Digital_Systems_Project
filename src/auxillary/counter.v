/* Counter used to count the long press duration */

module counter
#(
	parameter TIMER_PERIOD_ns = 100,
	parameter CLK_PERIOD_ns = 20
)
(
	input clk,
	input reset_sync,
	input resetn,
	input enable,
	output done
);

	localparam MAX_COUNT = TIMER_PERIOD_ns/CLK_PERIOD_ns;
	localparam COUNTER_BITS = $clog2(MAX_COUNT);
	
	reg [COUNTER_BITS:0] count = MAX_COUNT - 1;

	
	// flip flop
	always @(posedge clk) begin
		if (!resetn) begin
			count <= MAX_COUNT - 1;
		else 
			if (reset_sync)
				count <= MAX_COUNT - 1;
			else
				if (enable)
					count <= (count == 0) ? 0 : count - 1;
				else
					count <= MAX_COUNT - 1;
		end
	end
			
	// done remains at 1 when count is 0 until counter reset
	assign done = (count == 0) ? 1 : 0;
	
endmodule