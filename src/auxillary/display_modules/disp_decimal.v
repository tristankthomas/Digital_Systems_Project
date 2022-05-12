// Displays an 8-bit 2's complent number of four 7-segment displays

module disp_decimal
(
	input signed [7:0] x,
	input enable,
	output [6:0] disp0, disp1, disp2, disp3
); 
	
	
	wire neg = (x < 0);
	wire [7:0] ux = neg ? -x : x;  // unsigned x
	
	wire [7:0] xo0, xo1, xo2, xo3;
	wire eno0, eno1, eno2, eno3;
	
	snum_to_sseg digit1
	(
		.x(ux), 
		.neg(neg), 
		.enable(enable), 
		.xo(xo0), 
		.eno(eno0), 
		.segs(disp0)
	);
	
	snum_to_sseg digit2
	(
		.x(xo0), 
		.neg(neg), 
		.enable(eno0), 
		.xo(xo1), 
		.eno(eno1), 
		.segs(disp1)
	);
	snum_to_sseg digit3
	(
		.x(xo1), 
		.neg(neg), 
		.enable(eno1), 
		.xo(xo2), 
		.eno(eno2), 
		.segs(disp2)
	);
	snum_to_sseg digit4
	(
		.x(xo2), 
		.neg(neg), 
		.enable(eno2), 
		.xo(xo3), 
		.eno(eno3), 
		.segs(disp3)
	);
	
	
endmodule
	