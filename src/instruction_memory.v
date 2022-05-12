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
			1:  instruction = {`MOV, `PUR, `NUM, 8'd3, `REG, `DOUT, `N8};
			2:  instruction = {`MOV, `PUR, `NUM, 8'd5, `REG, `DOUT, `N8};
			3:  instruction = {`MOV, `PUR, `NUM, 8'd7, `REG, `DOUT, `N8};
			4:  instruction = {`MOV, `PUR, `NUM, 8'd9, `REG, `DOUT, `N8};
			5:  instruction = {`MOV, `PUR, `NUM, 8'd11, `REG, `DOUT, `N8};
			6:  instruction = {`MOV, `PUR, `NUM, 8'd13, `REG, `DOUT, `N8};
			7:  instruction = {`MOV, `PUR, `NUM, 8'd15, `REG, `DOUT, `N8};
			8:  instruction = {`MOV, `PUR, `NUM, 8'd17, `REG, `DOUT, `N8};
			9:  instruction = {`MOV, `PUR, `NUM, 8'd19, `REG, `DOUT, `N8};
			10: instruction = {`JMP, `UNC, `N9, `N9, 8'd0};
			default: instruction = 32'd0; // Default instruction is NOP
		endcase
		
endmodule
