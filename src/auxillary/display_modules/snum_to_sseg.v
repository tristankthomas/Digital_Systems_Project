// Signed num to sseg

module snum_to_sseg(
	input [7:0] x,
	input neg, enable,
	output reg [7:0] xo,
	output reg eno,
	output [6:0] segs);

	
	wire [3:0] digit = x % 10; // between 0 and 9 (need 4 bits)
	
	wire n = (x == 0) ? (enable ? neg : 1'b0) : 1'b0;
	
	SSeg converter
	(
		.bin(digit), 
		.neg(n), 
		.enable(enable), 
		.segs(segs)
	); // displays the last digit of num (only if enable is 1)
	
	
	
	always @(*) begin
		xo = x / 10;
		if (!enable)
			eno = 0;
		else if (!xo && !neg)	// if the number is 0 and not negative the remaining displays should be empty
			eno = 0;
		else if (!xo && neg && !enable)	// if the number is zero and negative and prev enable is 1, then display '-' next iteration
			eno = 0;
		else if (n)		// if the negative sign is displayed then rest of displays should be empty
			eno = 0;
		else
			eno = 1;
	end
	
endmodule
	
	