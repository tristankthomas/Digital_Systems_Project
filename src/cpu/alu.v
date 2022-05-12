`include "cpu_definitions.vh"
`default_nettype none

module alu
(
	input wire [7:0] operand_a,
	output reg [7:0] result
	
);

	always @(*)
		result = operand_a;
		
endmodule
