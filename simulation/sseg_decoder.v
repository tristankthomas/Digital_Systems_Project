// Display a Hexadecimal Digit, a Negative Sign, or a Blank, on a 7-segment Display
`default_nettype none

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