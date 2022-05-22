/* Displays an 8-bit 2's complent number (DOUT) on four 7-segment displays 
  in either binary or decimal (depending on mode) */

module disp_dout
(
	input signed [7:0] x,
	input mode,
	input enable,
	output [6:0] disp0, disp1, disp2, disp3
); 

	// binary display outputs
	wire [7:0] bin_disp0, bin_disp1, bin_disp2, bin_disp3;
	// decimal display outputs
	wire [7:0] dec_disp0, dec_disp1, dec_disp2, dec_disp3;
	
	assign disp0 = mode ? bin_disp0 : dec_disp0;
	assign disp1 = mode ? bin_disp1 : dec_disp1;
	assign disp2 = mode ? bin_disp2 : dec_disp2;
	assign disp3 = mode ? bin_disp3 : dec_disp3;
	
	// if mode is 1 (binary displaying)
	binary_to_sseg bit_1_2
	(
		.x(x[1:0]),
		.enable(enable),
		.segs(bin_disp0)
	);
	
	binary_to_sseg bit_3_4
	(
		.x(x[3:2]),
		.enable(enable),
		.segs(bin_disp1)
	);
	
	binary_to_sseg bit_5_6
	(
		.x(x[5:4]),
		.enable(enable),
		.segs(bin_disp2)
	);
	
	binary_to_sseg bit_7_8
	(
		.x(x[7:6]),
		.enable(enable),
		.segs(bin_disp3)
	);
	
	// if mode is 0 (decimal displaying)
	wire neg = (x < 0);
	wire [7:0] ux = neg ? -x : x;
	
	wire [7:0] xo0, xo1, xo2, xo3;
	wire eno0, eno1, eno2, eno3;
	
	snum_to_sseg digit1
	(
		.x(ux), 
		.neg(neg), 
		.enable(enable),
		.xo(xo0), 
		.eno(eno0), 
		.segs(dec_disp0)
	);
	
	snum_to_sseg digit2
	(
		.x(xo0), 
		.neg(neg), 
		.enable(eno0),
		.xo(xo1), 
		.eno(eno1), 
		.segs(dec_disp1)
	);
	snum_to_sseg digit3
	(
		.x(xo1), 
		.neg(neg), 
		.enable(eno1),
		.xo(xo2), 
		.eno(eno2), 
		.segs(dec_disp2)
	);
	snum_to_sseg digit4
	(
		.x(xo2), 
		.neg(neg), 
		.enable(eno2),
		.xo(xo3), 
		.eno(eno3), 
		.segs(dec_disp3)
	);
	
	
endmodule
	