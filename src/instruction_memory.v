`include "./cpu/cpu_definitions.vh"
`default_nettype none

module instruction_memory
(
	input wire [7:0] address,		// maximum of 256 different addresses
	output reg [31:0] instruction
);

	always @(*)
		case(address)
			0:  instruction = {`MOV, `PUR, `NUM, 8'd1, `REG, `DOUT, `N8};
			2:  instruction = {`ACC, `SAD, `NUM, 8'd127, `REG, `DOUT, `N8};
			4:  instruction = {`ACC, `SMT, `NUM, -8'd2, `REG, `DOUT, `N8};
			7:  instruction = {`JMP, `SLT, `REG, `DOUT, `NUM, 8'd64, 8'd4};
			10: instruction = {`MOV, `PUR, `NUM, 8'd100, `REG, `DOUT, `N8};
			13: instruction = {`ACC, `SAD, `NUM, -8'd7, `REG, `DOUT, 8'd13};
			16: instruction = {`JMP, `SLE, `NUM, 8'd0, `REG, `DOUT, 8'd13};
			20: instruction = {`JMP, `UNC, `N9, `N9, 8'd0};
			default: instruction = 32'd0; // Default instruction is NOP
		endcase
		
endmodule
