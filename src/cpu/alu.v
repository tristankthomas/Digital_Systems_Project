`include "cpu_definitions.vh"
`default_nettype none

module alu
(
	input wire [7:0] operand_a,
	input wire [3:0] alu_op,
	output reg [7:0] result,
	output reg shift_overflow
);
	wire [8:0] shift_left = {operand_a, 1'b0};
	wire [8:0] shift_right = {1'b0, operand_a};
	
	always @(*)
		case (alu_op)
			`PUROP : result = operand_a;			// Pure move
			`SHLOP : result = shift_left[7:0];	// Move and shift left
			`SHROP : result = shift_right[8:1];	// Move and shift right
			`UNCOP : result = `TRUE;				// Unconditional true
			default: result = operand_a;			// NOP operation (could return 0 instead)
		endcase
		
	always @(*) begin
		case (alu_op)
			`SHLOP : shift_overflow = shift_left[8];
			`SHROP : shift_overflow = shift_right[0];
			default : shift_overflow = 1'b0;
		endcase
	end
	
		
endmodule
