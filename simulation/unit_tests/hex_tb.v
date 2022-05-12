`timescale 1ns/1ns

module hex_tb;
	
	reg [7:0] in = 8'b0;
	wire [6:0] disp0;
	wire [6:0] disp1;
	wire first_dig;
	wire second_dig;
	
	disp_hex inp
	(
		.data_in(in),
		.disp0(disp0),
		.disp1(disp1)
	);
	
	sseg_decoder test1
	(
		.segs(disp0),
		.bin(first_dig),
		.neg(),
		.valid()
	);
	
	sseg_decoder test2
	(
		.segs(disp1),
		.bin(second_dig),
		.neg(),
		.valid()
	);
	
	initial begin
		$display("the first digit is %h, and second is %h", first_dig, second_dig);
	end
endmodule
