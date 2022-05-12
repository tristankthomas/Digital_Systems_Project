
module timer
#(
	parameter CLK_PERIOD_ns = 20,
	parameter TIMER_PERIOD_ms = 25,
	parameter TIMER_PERIOD_us = 25_000,
	parameter TIMER_PERIOD_ns = 25_000_000,
	parameter TIMER_PERIOD_TYPE = "ms"
	
)
(
	input wire clk,
	input wire enable,
	input wire resetn,
	input wire sync_resetn,
	input wire start,
	output wire done
);
	localparam TIMER_PERIOD = get_timer_period(TIMER_PERIOD_TYPE);
	localparam MULTIPLIER = get_multiplier(TIMER_PERIOD_TYPE);
	localparam MAX_COUNT = (TIMER_PERIOD * MULTIPLIER)/CLK_PERIOD_ns;
	
	timer_base
	#(
		.MAX_COUNT(MAX_COUNT)
	)
	timer_inst
	(
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.sync_resetn(sync_resetn),
		.start(start),
		.done(done)
	);
	
	// Function that gets correct timer period
	
	function [31:0] get_timer_period(
		input [15:0] type_str
	);
		case (type_str)
			"ms"	: get_timer_period = TIMER_PERIOD_ms;
			"us"	: get_timer_period = TIMER_PERIOD_us;
			"ns"	: get_timer_period = TIMER_PERIOD_ns;
			default : get_timer_period = TIMER_PERIOD_ms;
		endcase
	endfunction
	
	// Function that gets correct conversion factor for given type
	
	function [31:0] get_multiplier(
		input [15:0] type_str
	);
		case (type_str)
			"ms"	: get_multiplier = 1_000_000;
			"us"	: get_multiplier = 1_000;
			"ns"	: get_multiplier = 1;
			default : get_multiplier = 1_000_000;
		endcase
	endfunction
	
endmodule
	

	
	
	
	// basic timer
	
	module timer_base
	#(
		parameter MAX_COUNT = 10
	)
	(
		input wire clk,
		input wire enable,
		input wire resetn,
		input wire sync_resetn,
		input wire start,
		output wire done
	);
	
	
	localparam COUNTER_BITS = $clog2(MAX_COUNT); // Calculate actual bit width
	
	localparam
		IDLE = 2'b00,
		COUNTING_DOWN = 2'b01,
		STOPPED = 2'b10;
		
	reg [COUNTER_BITS : 0] count = MAX_COUNT - 2;  // should be -1
	
	reg [1:0] state = IDLE;
	
	always @(posedge clk or negedge resetn) begin // 
	
		if (!resetn) begin	// resetn active low and can occur outside of rising edge
			count <= MAX_COUNT;
			state <= IDLE;
			
		end else if (enable) begin
		
			if (!sync_resetn) begin		// sync_resetn active low and occurs at rising edge
				count <= MAX_COUNT - 2; // should be -1
				state <= IDLE;
			end else begin 
				// FSM Logic
				case (state)
					IDLE:
						if (start)
							state <= COUNTING_DOWN;
						else 
							state <= IDLE;
					COUNTING_DOWN:
						if (count == 0)
							state <= STOPPED;
						else
							state <= COUNTING_DOWN;
					STOPPED:
						if (start)
							state <= COUNTING_DOWN;
						else
							state <= IDLE;
					default:
						state <= IDLE;
				endcase
				
				// Counter Logic
				if (state == COUNTING_DOWN)
					count <= count - 1;
				else if (state == STOPPED)
					count <= MAX_COUNT - 2;
				else 
					count <= MAX_COUNT - 2; // should be -1
			end
		end
	end
	
	assign done = (state == STOPPED);
	
endmodule
			
	
			
			