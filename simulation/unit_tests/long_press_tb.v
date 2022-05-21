`timescale 1ns/1ns
`define PERIOD 20
`define HALF_PERIOD 10
`define PRESS_PERIOD 500

module long_press_tb;
	reg clk = 0;
	reg in = 0;
	wire out;
	
	time time_1, time_2;
	
	initial begin
		repeat(20000) begin
			#`HALF_PERIOD
			clk = !clk;
		end
	end
	
	long_press
	#(
		.CLK_PERIOD_ns(`PERIOD),
		.PRESS_TIMER_ns(`PRESS_PERIOD)
	)
	long_insta
	(
		.clk(clk),
		.in(in),
		.out(out)
	);
	
	initial begin
	
		
		#10 in = !in;
		time_1 = $time;
		$monitor("out switched to %d after %tns", out, ($time - time_1)/1000.0);
		#1000
		$stop;
	end
	
	
endmodule

		