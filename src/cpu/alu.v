`include "cpu_definitions.vh"
`default_nettype none

module alu
(
	input wire [7:0] operand_a,
	input wire [3:0] alu_op,
	output reg [7:0] result	
);

	always @(*)
		case (alu_op)
			`NOOP : begin
				result = operand_a;
			end
			`UNCOP : begin
				result = `TRUE;
			end
			default: begin
				result = 8'd0;
			end
		endcase
		
endmodule
