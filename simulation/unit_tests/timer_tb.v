`timescale 1ns/1ns
`define HALF_PERIOD 10
`define PERIOD 20
`define NUM_CLKS_TIMEOUT 1_000_000
`define TIMER_PERIOD 100

module timer_tb;
	
	reg clk = 1'b0;
	reg enable = 1'b0;
	reg resetn = 1'b0;
	reg sync_resetn = 1'b0;
	reg start = 1'b0;
	wire done;
	
	integer tests_passed = 0;
	integer test_num = 0;
	
	// Produce a clock
	initial begin
		forever begin
			#`HALF_PERIOD
			clk = !clk;
		end
	end
	
	// Stop testbench if it gets stuck
	initial begin
		#(`NUM_CLKS_TIMEOUT*`PERIOD)
		$display("Timeout Occured.\n");
		$stop;
	end
	
	// Initialise device under test
	
	timer 
	#(	
		.CLK_PERIOD_ns(`PERIOD),
		.TIMER_PERIOD_ns(`TIMER_PERIOD)
		//.TIMER_PERIOD_TYPE("ns")
	)
	dut( 
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.sync_resetn(sync_resetn),
		.start(start),
		.done(done) );
		
	initial begin
		
		test_num = test_num + 1;
		test_oneshot;
		
		test_num = test_num + 1;
		test_free_run;
		
		$display("Passed %1d/%1d tests", tests_passed, test_num);
		$stop;
	end
	
		
	task reset_module;
		begin
			// Reset the design under test
			
			#1
			resetn <= 1'b1;
			#1
			resetn <= 1'b0;
			#1
			resetn <= 1'b1;
		end
	endtask

	task test_oneshot;
		time start_time, done_time;
		begin
			
			// Reset the design under test
			reset_module;
			
			// Enable the timer
			@(posedge clk)
			enable <= 1'b1;
			sync_resetn <= 1'b1;
			
			// Start the timer
			@(posedge clk)
			start <= 1'b1;
			
			// Timer has started, begin timing
			@(posedge clk)
			start_time = $time;
			
			// Turn off the start signal
			@(posedge clk)
			start <= 1'b0;
			
			// Wait for the timer to finish
			@(posedge clk)
			done_time = $time;
			
			// Disable the time
			enable <= 0'b0;
			
			// Report results
			if (done_time - start_time !== `TIMER_PERIOD) begin
				$display("FAIL: Test %1d. Timer took %6tns to finish, expected %6tns.\n",
					test_num, done_time - start_time, `TIMER_PERIOD);
			end else begin
				$display("PASS: Test %1d. Timer took %6tns to finish.\n", test_num,
					done_time - start_time);
				tests_passed = tests_passed + 1;
			end
		end
	endtask
	
	task test_free_run;
		time start_time, tick1, tick2;
		time time_diff1, time_diff2;
		begin
			// Reset the design under test
			reset_module;
			
			// Enable the timer
			@(posedge clk)
			enable <= 1'b1;
			sync_resetn <= 1'b1;
			
			// Start the timer
			@(posedge clk)
			start <= 1'b1;
			
			// Timer has started, begin timing
			@(posedge clk)
			start_time = $time;
			
			// Record time of first tick
			@(posedge done)
			tick1 = $time;
			
			// Record time of second tick
			@(posedge done)
			tick2 = $time;
			
			// Disable the timer
			start <= 1'b0;
			enable <= 1'b0;
			
			// Report Results
			time_diff1 = tick1 - start_time;
			
			time_diff2 = tick2 - tick1;
			
			if (time_diff1 !== `TIMER_PERIOD || time_diff2 !== `TIMER_PERIOD) begin
				$dipslay("FAIL: Test %1d.", test_num);
				$display("tick1 - start = %t, expected %t", time_diff1,
					`TIMER_PERIOD);
				$display("tick2 - tick1 = %t, expected %t", time_diff2,
					`TIMER_PERIOD);
			end else begin
				$display("PASS: Test %1d. Timer took %6tns to finish in both runs.\n",
					test_num, `TIMER_PERIOD);
				tests_passed = tests_passed + 1;
			end
		end
	endtask

	
					
			
endmodule

		
	