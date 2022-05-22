/* Displays an 8-bit number (instruction pointer) in hexadecimal 
   on two 7-segment displays */

module disp_hex
(
	input [7:0] data_in,
	input turbo_mode,
	output [6:0] disp0,
	output [6:0] disp1
);
	wire [3:0] first_dig = data_in[7:4];
	wire [3:0] second_dig = data_in[3:0];
	
	SSeg first
	(
		.bin(first_dig), 
		.neg(1'b0), 
		.enable(1'b1),
		.turbo_mode(turbo_mode),
		.segs(disp1)
	);
	
	SSeg second
	(
		.bin(second_dig), 
		.neg(1'b0), 
		.enable(1'b1),
		.turbo_mode(turbo_mode),
		.segs(disp0)
	);
	
	
	
endmodule
