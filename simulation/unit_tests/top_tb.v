`timescale 1ns/1ns
`define HALF_PERIOD 20

module top_tb;
	reg clk = 0;
	reg [9:0] switches = 10'd0;
	reg [4:0] push_buttons = 5'd0;
	wire [10:0] leds;
	wire [6:0] disp0;
	wire [6:0] disp1;
	wire [6:0] disp2;
	wire [6:0] disp3;
	wire [6:0] disp4;
	wire [6:0] disp5;

	initial begin
		repeat(2000) begin
			#`HALF_PERIOD
			clk = !clk;
		end
	end
	
	top top_insta
(
	 .CLOCK_50(clk),   
    .SW(switches),       
    .KEY(push_buttons),
    .LEDR(leds),
    .HEX0(disp0),
    .HEX1(disp1),
    .HEX2(disp2),
    .HEX3(disp3),
    .HEX4(disp4),
    .HEX5(disp5)
 );
	
	
	initial begin
	
		$monitor(disp5);
	end
	
endmodule
		