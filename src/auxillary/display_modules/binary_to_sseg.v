
module binary_to_sseg
(
	input [1:0] x,
	input enable,
	output reg [6:0] segs
);
	always @(*)
		if (enable) begin
			case(x)
				2'b00 : segs = 7'b110_1011;
				2'b01 : segs = 7'b110_1001;
				2'b10 : segs = 7'b100_1011;
				2'b11 : segs = 7'b100_1001;
			endcase
		end
		else segs = 7'b111_1111;
		
endmodule 