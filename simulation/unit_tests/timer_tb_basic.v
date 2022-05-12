`timescale 1ns/1ns
`define HALF_PERIOD 10
`define PERIOD 20
`define NUM_CLKS_TIMEOUT 40_000_000
module timer_tb_basic;

	reg clk = 1'b0;
	reg enable = 1'b0;
	reg resetn = 1'b0;
	reg sync_resetn = 1'b0;
	reg start = 1'b0;
	wire done;
	
	time start_time;
	time done_time;
	
	initial begin
		forever begin
			#`HALF_PERIOD
			clk = !clk;
			
		end
	end
	
	
	initial begin
		#(`NUM_CLKS_TIMEOUT*`PERIOD)
		$display("Timeout Occured.\n");
		$stop;
	end
	
	timer 
	#(
		.CLK_PERIOD_ns(`PERIOD),
		.TIMER_PERIOD_ms(30),
		.TIMER_PERIOD_TYPE("ms")
	)
	dut
	(
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.start(start),
		.done(done)
	);
	
	initial begin
		#1
		resetn = 1'b1;
		#1
		resetn = 1'b0;
		#1
		resetn = 1'b1;
		
		@(posedge clk)
		sync_resetn <= 1'b1;
		enable <= 1'b1;
		
		@(posedge clk)
		
		start <= 1'b1;
		
		start_time = $time;
		$display("Timer started at: %t\n", start_time);
		@(posedge clk)
		start <= 1'b0;
		
		
		@(posedge done)
		done_time = $time;
		$display("Timer finished at: %t\n", done_time);
		
		$display("Timer took %tps to finish. \n", (done_time - start_time));
		$stop;
	end
endmodule
