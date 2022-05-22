
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
	
	synchroniser sync
	(
		.clk(clk),
		.in(in),
		.in_sync(in_sync)
	);
	
	count_up
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
		
	
	reg prev; // state
	
	
	always @(posedge clk)
		prev <= in_sync;		// flip-flop and next-state logic
		
		
	assign out = done;	// output logic
	assign reset = !in_sync;
	
endmodule

module count_up
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
	reg [COUNTER_BITS:0] count = MAX_COUNT;

	
	// flip flop
	always @(posedge clk) begin
		if (!resetn)
			count <= MAX_COUNT;
		else begin
			if (reset_sync)
				count <= MAX_COUNT;
			else begin
				if (enable)
					count <= (count == 0) ? 0 : count - 1;
				else
					count <= MAX_COUNT;
			end
		end
	end

	assign done = (count == 0) ? 1 : 0;
	
endmodule
		

