`timescale 1ns/1ps
`define PERIOD 2
`define HALF_PERIOD 1

module sync_tb;
	reg clk = 0;
	reg in = 0;
	wire out;
	
	initial begin
		repeat(50) begin
			#`HALF_PERIOD 
			clk = !clk;
		end	
		
	end
	
	synchroniser sync
	(
		.clk(clk),
		.in(in),
		.in_sync(out)
	);
	
	initial begin
		// make in change at rising edge and see if corrects
		#5 in = !in;
		$monitor("Out has changed value to %d at time = %tps", out, $time);
		// testing when in changes faster than clock
		#5 in = !in;
		if (out)
			$display("Out as expected at time = %tps", $time);
		else
			$display("Out has changed when it shouldnt have");
		#0.5 in = !in;
		#5 in = !in;
		#10
		$stop;
		
	end
	
	
endmodule
