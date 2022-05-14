`default_nettype none
`include "cpu_definitions.vh"
	// Control unit
module controller
(
	input wire [2:0] command_group,
	input wire [2:0] command,
	output reg write_enable,
	output reg [3:0] alu_op,		// only useful once the specific command is added in particular for conditional jumps
	output reg branch_select,		// doesnt mean jump will occur only signifies that jump will occur if condition is true (from alu) (branch refers to instruction pointer (three branches))
	output reg is_atc
);
	always @(*)
		case (command_group)
		
			`NOP : begin		// No Operation
				write_enable = 1'b0;
				branch_select = 1'b0;
				is_atc = 1'b0;
				alu_op = `ALU_PUR;
			end
			
			`MOV : begin		// Move
				write_enable = 1'b1; // Needs to be able to write the number in the first argument into the second arguments (register)
				branch_select = 1'b0;
				is_atc = 1'b0;
				case (command)
					`PUR : alu_op = `ALU_PUR;		// Constant for the alu to return operand a
					`SHL : alu_op = `ALU_SHL;		// Constant for the alu to return operand a shifted left
					`SHR : alu_op = `ALU_SHR;		// Constant for the alu to return operand a shifted right
					default : alu_op = `ALU_PUR;	// Constant for the alu to return operand a
				endcase
			end
			
			`JMP : begin		// Jump
				write_enable = 1'b0;
				branch_select = 1'b1;
				is_atc = 1'b0;
				case (command)
					`UNC : alu_op = `ALU_UNC;
					`EQ  : alu_op = `ALU_EQ;
					`ULT : alu_op = `ALU_ULT;
					`SLT : alu_op = `ALU_SLT;
					`ULE : alu_op = `ALU_ULE;
					`SLE : alu_op = `ALU_SLE;
				endcase
			end
			
			`ACC : begin		// Accumulate
				write_enable = 1'b1; // needs to be able to write the result from the ALU into the second argument (register)
				branch_select = 1'b0;
				is_atc = 1'b0;
				case (command)
					`UAD : alu_op = `ALU_UAD;
					`SAD : alu_op = `ALU_SAD;
					`UMT : alu_op = `ALU_UMT;
					`SMT : alu_op = `ALU_SMT;
					`AND : alu_op = `ALU_AND;
					`OR  : alu_op = `ALU_OR;
					`XOR : alu_op = `ALU_XOR;
					default : alu_op = `ALU_PUR;
				endcase
			end
			
			`ATC : begin	// Atomic Test and Clear
				write_enable = 1'b0;
				branch_select = 1'b1;
				is_atc = 1'b1;
			end
					
			default: begin		// Default
				write_enable = 1'b0;
				branch_select = 1'b0;
				is_atc = 1'b0;
				alu_op = `ALU_PUR;
			end
		endcase
		
endmodule
