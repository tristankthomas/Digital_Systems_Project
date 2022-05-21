`timescale 1ns/1ns
`define NEG         7'b011_1111
`define ZERO        7'b100_0000
`define ONE         7'b111_1001
`define TWO         7'b010_0100
`define THREE       7'b011_0000
`define FOUR        7'b001_1001
`define FIVE        7'b001_0010
`define SIX         7'b000_0010
`define SEVEN       7'b111_1000
`define EIGHT       7'b000_0000
`define NINE        7'b001_1000
`define TEN         7'b000_1000
`define ELEVEN      7'b000_0011
`define TWELVE      7'b100_0110
`define THIRTEEN    7'b010_0001
`define FOURTEEN    7'b000_0110
`define FIFTEEN     7'b000_1110

module dec_tb;
	
	reg signed [7:0] in = 8'd0;
	wire [6:0] disp0;
	wire [6:0] disp1;
	wire [6:0] disp2;
	wire [6:0] disp3;
	wire [3:0] first_dig;
	wire [3:0] second_dig;
	wire [3:0] third_dig;
	wire [3:0] fourth_dig;

	wire [3:0] neg;
	wire enable = 1;
	wire [3:0] valid;
	integer i;
	disp_decimal inp
	(
		.x(in),
		.enable(enable),
		.disp0(disp0),
		.disp1(disp1),
		.disp2(disp2),
		.disp3(disp3)
	);
	
	sseg_decoder test1
	(
		.segs(disp0),
		.bin(first_dig),
		.neg(neg[0]),
		.valid(valid[0])
	);
	
	sseg_decoder test2
	(
		.segs(disp1),
		.bin(second_dig),
		.neg(neg[1]),
		.valid(valid[1])
	);
	sseg_decoder test3
	(
		.segs(disp2),
		.bin(third_dig),
		.neg(neg[2]),
		.valid(valid[2])
	);
	sseg_decoder test4
	(
		.segs(disp3),
		.bin(fourth_dig),
		.neg(neg[3]),
		.valid(valid[3])
	);

	
	initial begin
		
		for (i = -128; i < 127; i = i + 1) begin
			if (i % 13 == 0) begin
				#5 in = i;
				#1
				$display("%-4d is decoded to [%d : %d : %d : %d], neg = %b, valid = %b", i, fourth_dig, third_dig, second_dig, first_dig, neg, valid);
			end
		end
	
		$stop;
	end
endmodule


module sseg_decoder
(
    input   wire [6:0] 	segs,
	output  reg	 [3:0] 	bin, 
	output  reg			neg, 
    output  reg         valid
	
);
	always @(*) begin
        
        bin = 4'd0;
        neg = 1'b0;
        valid = 1'b1;

        case (segs)
            `NEG        : neg = 1'b1;
            `ZERO       : bin = 4'd0;
            `ONE        : bin = 4'd1;
            `TWO        : bin = 4'd2;
            `THREE      : bin = 4'd3;
            `FOUR       : bin = 4'd4;
            `FIVE       : bin = 4'd5;
            `SIX        : bin = 4'd6;
            `SEVEN      : bin = 4'd7;
            `EIGHT      : bin = 4'd8;
            `NINE       : bin = 4'd9;
            `TEN        : bin = 4'd10;
            `ELEVEN     : bin = 4'd11;
            `TWELVE     : bin = 4'd12;
            `THIRTEEN   : bin = 4'd13;
            `FOURTEEN   : bin = 4'd14;
            `FIFTEEN    : bin = 4'd15;
            default     : valid = 1'b0;
        endcase
    end

endmodule