`include "./cpu/cpu_definitions.vh"
`default_nettype none

module instruction_memory
(
	input wire [7:0] address,		// maximum of 256 different addresses
	output reg [31:0] instruction
);

	always @(*)
		case(address)
//			0:  instruction = {`MOV, `PUR, `NUM, 8'd1, `REG, `DOUT, `N8};
//			//2:  instruction = {`ACC, `SAD, `NUM, 8'd127, `REG, `DOUT, `N8}; there to test the flag register
//			4:  instruction = {`ACC, `SMT, `NUM, -8'd2, `REG, `DOUT, `N8};
//			7:  instruction = {`JMP, `SLT, `REG, `DOUT, `NUM, 8'd64, 8'd4};
//			10: instruction = {`MOV, `PUR, `NUM, 8'd100, `REG, `DOUT, `N8};
//			13: instruction = {`ACC, `SAD, `NUM, -8'd7, `REG, `DOUT, 8'd13};
//			16: instruction = {`JMP, `SLE, `NUM, 8'd0, `REG, `DOUT, 8'd13};
//			20: instruction = {`JMP, `UNC, `N9, `N9, 8'd0};

//			0: instruction = set(`DOUT, 1);
//			4: instruction = acc(`SMT, `DOUT, `NUM, -2);
//			8: instruction = atc(`OFLW, 16);
//			12: instruction = jmp(4);
//			
//			16: instruction = set(`DOUT, 250);
//			20: instruction = acc(`UAD, `DOUT, `NUM, 1);
//			24: instruction = atc(`OFLW, 8);
//			28: instruction = jmp(20);
			0 : instruction = set(`FLAG, 128); // sets the last bit of the flag register to 1??
			1 : instruction = mov(`PUR, `REG, `FLAG, `GOUT); // flag register bits (from push button) stored output on leds
			2 : instruction = mov(`PUR, `REG, `DINP, `DOUT);  // switch values output on display
			3 : instruction = jmp(1);
			
			default: instruction = 32'd0; // NOP
			
			//1, 5, 9, 13, 17, 21, 25: instruction = mov(`PUR, `REG, `FLAG, `GOUT);
		endcase
		
	function [31:0] mov;
		input [2:0] op;
		input arg1_type;
		input [7:0] arg1;
		input [7:0] reg_num;
		mov = {`MOV, op, arg1_type, arg1, `REG, reg_num, `N8};
	endfunction
	
	// Set a register to a value
	function [31:0] set;
		input [7:0] reg_num;
		input [7:0] value;
		set = {`MOV, `PUR, `NUM, value, `REG, reg_num, `N8};
	endfunction
	
	function [31:0] jmp;
		input [7:0] addr;
		jmp = {`JMP, `UNC, `N9, `N9, addr};
	endfunction
	
	function [31:0] atc;
		input [2:0] atc_bit;
		input [7:0] addr;
		atc = {`ATC, atc_bit, `N9, `N9, addr};
	endfunction
	
	function [31:0] acc;
		input [2:0] op;
		input [7:0] reg_num;
		input num_type;
		input [7:0] num;
		acc = {`ACC, op, num_type, num, `REG, reg_num, `N8};
	endfunction
	
	
	
		
endmodule


