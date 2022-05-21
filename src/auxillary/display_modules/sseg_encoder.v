// Display a Hexadecimal Digit, a Negative Sign, or a Blank, on a 7-segment Display
`default_nettype none
module SSeg(
	input wire [3:0] bin, 
	input wire neg, 
	input wire enable,
	input wire turbo_mode,
	output reg [6:0] segs );
	
	always @(*)
		if (enable) begin
			if (neg) segs = 7'b011_1111;
			else if (turbo_mode) segs = 7'b100_0000;
			else begin
				case (bin)
					4'd0	: segs = 7'b100_0000;
					4'd1	: segs = 7'b111_1001;
					4'd2	: segs = 7'b010_0100;
					4'd3	: segs = 7'b011_0000;
					4'd4	: segs = 7'b001_1001;
					4'd5	: segs = 7'b001_0010;
					4'd6	: segs = 7'b000_0010;
					4'd7	: segs = 7'b111_1000;
					4'd8	: segs = 7'b000_0000;
					4'd9	: segs = 7'b001_1000;
					4'd10	: segs = 7'b000_1000;
					4'd11	: segs = 7'b000_0011;
					4'd12	: segs = 7'b100_0110;
					4'd13	: segs = 7'b010_0001;
					4'd14	: segs = 7'b000_0110;
					4'd15	: segs = 7'b000_1110;
				endcase
			end
		end
		else segs = 7'b111_1111;
		
endmodule