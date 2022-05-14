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
			4:  instruction = {`ACC, `UAD, `NUM, 8'd40, `REG, `DOUT, `N8};
			8: instruction = {`JMP, `UNC, `N9, `N9, 8'd4};
			default: instruction = 32'd0; // Default instruction is NOP
		endcase
		
endmodule
