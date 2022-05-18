// Signed num to sseg

module snum_to_sseg(
	input [7:0] x,
	input neg, enable,
	output reg [7:0] xo,
	output reg eno,
	output [6:0] segs);

	
	wire [3:0] digit = x % 10; // between 0 and 9 (need 4 bits)
	
	wire n = (!x && neg);
	
	SSeg converter
	(
		.bin(digit), 
		.neg(n), 
		.enable(enable), 
		.segs(segs)
	); // displays the last digit of num (only if enable is 1)
	
	
	
	always @(*) begin
		xo = x / 10;
		if (!enable || n || !xo && !neg)
			eno = 0;
		else
			eno = 1;
	end
	
endmodule
	
	