// Signed num to sseg

module snum_to_sseg
(
	input [7:0] x,
	input neg, enable,
	output reg [7:0] xo,
	output reg eno,
	output [6:0] segs
);

	// modulo 10 always results in least significant decimal number
	wire [3:0] digit = x % 10; 
	
	// current negative flag logic
	wire n = (!x && neg);
	
	SSeg converter
	(
		.bin(digit), 
		.neg(n), 
		.enable(enable),
		.turbo_mode(0),
		.segs(segs)
	);
	
	
	// next enable logic 
	always @(*) begin
		// floor division by 10 removed least significant decimal
		xo = x / 10;
		
		if (!enable || n || !xo && !neg)
			eno = 0;
		else
			eno = 1;
	end
	
endmodule
	
	