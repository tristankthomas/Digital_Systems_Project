`timescale 1ns/1ns
`define PERIOD 20
`define HALF_PERIOD 10
`define TIMER_PERIOD 200
`define NUM_CLKS_TIMEOUT 2000


module debounce_tb;

    reg clk = 1'b0;
    reg enable = 1'b1;
    reg resetn = 1'b0;
    reg in = 1'b0;
    wire out;
	 
	 time time_1, time_2, time_3, time_4, time_5;

    initial begin
		forever begin
			#`HALF_PERIOD
			clk = !clk;
		end
	end

    debounce 
	 
    #(
        .CLK_PERIOD_ns(`PERIOD),
        .DEBOUNCE_TIMER_ns(`TIMER_PERIOD)
    )
	 deb_insta
    (
	 
        .clk(clk),
        .enable(enable),
        .resetn(resetn),
        .sig_i(in),
        .sig_o(out)

    );

	initial begin
		
		#1
		resetn <= 1'b1;
		#1
		resetn <= 1'b0;
		#1
		resetn <= 1'b1;

		#40 // 43 ns
		time_1 = $time;
		in = !in;

		$display("at time %tns, the output is %d", $time/1000.0, out);
		@(posedge out)
		time_2 = $time;
		$display("after %tns, the output is %d", (time_2 - time_1)/1000.0, out);
		
		#1 in = !in;
		#10 in = !in;
		#(`TIMER_PERIOD + 200) in = !in;
		time_3 = $time;
		@(negedge out);
		time_4 = $time;
		$display("after %tns, the output is %d", (time_4 - time_3)/1000.0, out);
		in = !in;
		@(posedge out);
		time_5 = $time;
		$display("after %tns, the output is %d", (time_5 - time_4)/1000.0, out);
		$stop;
		
		
		
			
	end

 endmodule
