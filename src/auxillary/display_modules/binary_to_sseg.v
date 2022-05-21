
module binary_to_sseg
(
	input [1:0] x,
	input mode,
	input enable,
	output reg [6:0] segs
);
	always @(*)
		if (enable && mode) begin
			case(x)
				2'b00 : segs = 7'b111_1111;
				2'b01 : segs = 7'b100_1111;
				2'b10 : segs = 7'b111_1001;
				2'b11 : segs = 7'b100_1001;
			endcase
		end
		else segs = 7'b111_1111;
		
endmodule 