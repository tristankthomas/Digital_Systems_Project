/* Used to return certain parameters based on the current instruction command */
`default_nettype none
`include "cpu_definitions.vh"

module controller
(
	input wire [2:0] command_group,
	input wire [2:0] command,
	output reg 		  write_enable,
	output reg [4:0] alu_op,
	output reg 		  branch_select,
	output reg 		  is_atc
);
	always @(*)
		case (command_group)
		
			`NOP : begin			// No Operation
				write_enable = 1'b0;
				branch_select = 1'b0;
				is_atc = 1'b0;
				alu_op = `ALU_PUR;
			end
			
			`MOV : begin			// Move
				write_enable = 1'b1;
				branch_select = 1'b0;
				is_atc = 1'b0;
				case (command)
					`PUR : alu_op = `ALU_PUR;		// Pure move
					`SHL : alu_op = `ALU_SHL;		// Left bit shift
					`SHR : alu_op = `ALU_SHR;		// Right bit shift
					default : alu_op = `ALU_PUR;	
				endcase
			end
			
			`JMP : begin			// Jump
				write_enable = 1'b0;
				branch_select = 1'b1;
				is_atc = 1'b0;
				case (command)
					`UNC : alu_op = `ALU_UNC;		// Unconditional
					`EQ  : alu_op = `ALU_EQ;		// Equality
					`ULT : alu_op = `ALU_ULT;		// Unsigned less than
					`SLT : alu_op = `ALU_SLT;		// Signed less than
					`ULE : alu_op = `ALU_ULE;		// Unsigned less than or equal to
					`SLE : alu_op = `ALU_SLE;		// Signed less than or equal to
					default : alu_op = `ALU_PUR;
				endcase
			end
			
			`ACC_ART : begin		// Arithmetic Accumulate
				write_enable = 1'b1; 
				branch_select = 1'b0;
				is_atc = 1'b0;
				case (command)
					`UAD : alu_op = `ALU_UAD;		// Unsigned addition
					`SAD : alu_op = `ALU_SAD;		// Signed addition
					`UMT : alu_op = `ALU_UMT;		// Unsigned multiplication
					`SMT : alu_op = `ALU_SMT;		// Signed multiplication	
					`USB : alu_op = `ALU_USB;		// Unsigned subtraction
					`SSB : alu_op = `ALU_SSB;		// Signed subtraction
					`UDV : alu_op = `ALU_UDV;		// Unsigned floor division
					`SDV : alu_op = `ALU_SDV;		// Signed floor division
					default : alu_op = `ALU_PUR;
				endcase
			end
			
			`ACC_LOG : begin		// Logical Accumulate
				write_enable = 1'b1;
				branch_select = 1'b0;
				is_atc = 1'b0;
				case (command)
					`AND : alu_op = `ALU_AND;		// Bitwise AND
					`OR  : alu_op = `ALU_OR;		// Bitwise OR
					`XOR : alu_op = `ALU_XOR;		// Bitwise XOR
					default : alu_op = `ALU_PUR;
				endcase
			end
			
			`ATC : begin			// Atomic Test and Clear
				write_enable = 1'b0;
				is_atc = 1'b1;
				branch_select = 1'b1;
				alu_op = 1'b0;
			end
					
			default: begin			// Default
				write_enable = 1'b0;
				branch_select = 1'b0;
				is_atc = 1'b0;
				alu_op = 1'b0;
			end
		endcase
		
endmodule
