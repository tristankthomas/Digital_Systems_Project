`default_nettype none
`include "cpu_definitions.vh"
	// Control unit
module controller
(
	input wire [2:0] command_group,
	input wire [2:0] command,
	output reg write_enable,
	output reg [3:0] alu_op,		// only useful once the specific command is added in particular for conditional jumps
	output reg branch_select		// doesnt mean jump will occur only signifies that jump will occur if condition is true (from alu)
);
	always @(*)
		case (command_group)
			`NOP : begin		// No Operation
				write_enable = 1'b0;
				alu_op = `PUROP;
				branch_select = 1'b0;
			end
			`MOV : begin		// Move
				write_enable = 1'b1;
				branch_select = 1'b0;
				case (command)
					`PUR : alu_op = `PUROP;		// Constant for the alu to return operand a
					`SHL : alu_op = `SHLOP;		// Constant for the alu to return operand a shifted left
					`SHR : alu_op = `SHROP;		// Constant for the alu to return operand a shifted right
					default : alu_op = `PUROP;	// Constant for the alu to return operand a
				endcase
			end
			`JMP : begin		// Jump
				write_enable = 1'b0;
				branch_select = 1'b1;
				alu_op = `UNCOP;
			end
			default: begin		// Default
				write_enable = 1'b0;
				branch_select = 1'b0;
				alu_op = `PUROP;
			end
		endcase
		
endmodule
