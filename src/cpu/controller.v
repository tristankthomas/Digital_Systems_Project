`default_nettype none
`include "cpu_definitions.vh"
	// Control unit
module controller
(
	input wire [2:0] command_group,
	output reg write_enable,
	output reg [3:0] alu_op,		// only useful once the specific command is added in particular for conditional jumps
	output reg branch_select		// doesnt mean jump will occur only signifies that jump will occur if condition is true (from alu)
);
	always @(*)
		case (command_group)
			`NOP : begin
				write_enable = 1'b0;
				alu_op = `NOOP;
			end
			`MOV : begin
				write_enable = 1'b1;
				alu_op = `NOOP;
				branch_select = 1'b0;
			end
			`JMP : begin
				write_enable = 1'b0;
				branch_select = 1'b1;
				alu_op = `UNCOP;
			end
			default: begin
				write_enable = 1'b0;
				branch_select = 1'b0;
				alu_op = `NOOP;
			end
		endcase
		
endmodule
