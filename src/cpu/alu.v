`include "cpu_definitions.vh"
`default_nettype none

module alu
(
	input wire [7:0] operand_a,
	input wire [7:0] operand_b,
	input wire [4:0] alu_op,
	output reg [7:0] result,
	
	output reg shift_overflow,
	output reg arithmetic_overflow
);
	wire 			[8:0] shift_left = {operand_a, 1'b0};
	wire 			[8:0] shift_right = {1'b0, operand_a};
	wire 			[8:0] unsigned_add = operand_a + operand_b;
	wire signed [8:0] signed_add = $signed(operand_a) + $signed(operand_b);
	wire 			[15:0] unsigned_mul = operand_a * operand_b;
	wire signed [15:0] signed_mul = $signed(operand_a) * $signed(operand_b);
	wire			[8:0] unsigned_sub = operand_a - operand_b;
	wire signed [8:0] signed_sub = $signed(operand_a) - $signed(operand_b);
	
	always @(*)
		case (alu_op)
			`ALU_PUR : result = operand_a;			// Pure move
			`ALU_SHL : result = shift_left[7:0];	// Move and shift left
			`ALU_SHR : result = shift_right[8:1];	// Move and shift right
			
			`ALU_UAD : result = unsigned_add[7:0];
			`ALU_SAD : result = signed_add[7:0];
			`ALU_UMT : result = unsigned_mul[7:0];
			`ALU_SMT : result = signed_mul[7:0];
			`ALU_USB : result = signed_sub[7:0];
			`ALU_SSB : result = signed_sub[7:0];
			`ALU_UDV : result = operand_a / operand_b;
			`ALU_SDV : result = $signed(operand_a) / $signed(operand_b);
			
			`ALU_AND : result = operand_a & operand_b;
			`ALU_OR  : result = operand_a | operand_b;
			`ALU_XOR : result = operand_a ^ operand_b;
			
			`ALU_UNC : result = `TRUE;				// Unconditional true
			`ALU_EQ  : result = operand_a == operand_b;
			`ALU_ULT : result = operand_a < operand_b;
			`ALU_SLT : result = $signed(operand_a) < $signed(operand_b);
			`ALU_ULE : result = operand_a <= operand_b;
			`ALU_SLE : result = $signed(operand_a) <= $signed(operand_b);
			

			
			default : result = 8'd0;			// NOP operation (could return 0 instead)
		endcase
		
	always @(*) begin
		case (alu_op)
			`ALU_SHL : shift_overflow = shift_left[8];
			`ALU_SHR : shift_overflow = shift_right[0];
			default  : shift_overflow = 1'b0;
		endcase
	end
		
	always @(*) begin
		case (alu_op)
			`ALU_UAD : arithmetic_overflow = unsigned_add > 255;
			`ALU_SAD : arithmetic_overflow = signed_add > 127 || signed_add < -128;
			`ALU_USB : arithmetic_overflow = unsigned_sub > 255;
			`ALU_SSB : arithmetic_overflow = signed_sub > 127 || signed_sub < -128;
			`ALU_UMT : arithmetic_overflow = unsigned_mul > 255;
			`ALU_SMT : arithmetic_overflow = signed_mul > 127 || signed_mul < -128;
			`ALU_UDV : arithmetic_overflow = operand_b == 0;
			`ALU_SDV : arithmetic_overflow = operand_b == 0;
			default  : arithmetic_overflow = 1'b0;
		endcase
	end

	
		
endmodule
