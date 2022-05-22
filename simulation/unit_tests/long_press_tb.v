`timescale 1ns/1ns
`define PERIOD 20
`define HALF_PERIOD 10
`define PRESS_PERIOD 500

module long_press_tb;
	reg clk = 0;
	reg in = 0;
	reg resetn;
	wire out;
	
	time time_1, time_2;
	
	initial begin
		repeat(2000) begin
			#`HALF_PERIOD
			clk = !clk;
		end
	end
	
	long_press_detect
	#(
		.CLK_PERIOD_ns(`PERIOD),
		.PRESS_TIMER_ns(`PRESS_PERIOD)
	)
	long_insta
	(
		.clk(clk),
		.in(in),
		.resetn(resetn),
		.out(out)
	);
	
	initial begin
		#1
		resetn = 0;
		#1
		resetn = 1;
		
		#10 in = !in;
		time_1 = $time;
		@(posedge out)
		$display("out switched to %d after %tns", out, ($time - time_1)/1000.0);
		#5 in = !in;
		#30 in = !in;
		time_2 = $time;
		@(posedge out)
		$display("out switched to %d after %tns", out, ($time - time_2)/1000.0);
		#50
		$stop;
	end
	
	
endmodule

		