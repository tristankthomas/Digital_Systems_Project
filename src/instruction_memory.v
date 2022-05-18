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


			
			
//			0: instruction = {`ACC, `OR, `NUM, 8'b10000000, `REG, `GOUT, `N8};
//			1: instruction = set(`DOUT, 20); 
//			2: instruction = acc(`SAD, `DOUT, `NUM, -7);
//			3: instruction = {`JMP, `SLT, `NUM, -8'd50, `REG, `DOUT, 8'd2};
//			4: instruction = set(`DOUT, 20);
//			5: instruction = acc(`UAD, `DOUT, `NUM, -7);
//			6: instruction = jmp(5);



//			0: instruction = set(`DOUT, 1);
//			4: instruction = acc(`SMT, `DOUT, `NUM, -2);
//			8: instruction = atc(`OFLW, 16);
//			12: instruction = jmp(4);
//			
//			16: instruction = set(`DOUT, 250);
//			20: instruction = acc(`UAD, `DOUT, `NUM, 1);
//			24: instruction = atc(`OFLW, 8);
//			28: instruction = jmp(20);
			
//			0 : instruction = set(`FLAG, 128); // sets the last bit of the flag register to 1??
//			1 : instruction = mov(`PUR, `REG, `FLAG, `GOUT); // flag register bits (from push button) stored output on leds
//			2 : instruction = mov(`PUR, `REG, `DINP, `DOUT);  // switch values output on display
//			3 : instruction = jmp(1);


			// Instructions for RPN calculator\
			// wait
			//0: instruction = setg(`DVALB);
			0: instruction = atc(`PUSH, 5);
			1: instruction = atc(`POP, 23);
			2: instruction = atc(`ADD, 9);
			3: instruction = atc(`MULT, 8);
			4: instruction = jmp(0);
			// push
			5: instruction = mov(`PUR, `REG, `STACK2, `STACK3);
			6: instruction = mov(`PUR, `REG, `STACK1, `STACK2);
			7: instruction = mov(`PUR, `REG, `STACK0, `STACK1);
			8: instruction = mov(`PUR, `REG, `DINP, `STACK0);
			9: instruction = mov(`PUR, `REG, `STACK0, `DOUT);
			10: instruction = setg(8'b10000000);
			11: instruction = {`JMP, `EQ, `REG, `STACK_SIZE, `NUM, 8'd8, 8'd17};
			12: instruction = resetg(8'b11000000);
			13: instruction = {`JMP, `EQ, `REG, `STACK_SIZE, `NUM, 8'd0, 8'd20};
			14: instruction = mov(`SHL, `REG, `STACK_SIZE, `STACK_SIZE); // turns off overflows and 
			15: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE);
			16: instruction = jmp(0);
			// stack overflow
			17: instruction = setg(8'b00100000);
			18: instruction = resetg(8'b11101111);
			19: instruction = jmp(0);
			// stack initialising
			20: instruction = set(`STACK_SIZE, 8'd1);
			21: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE);
			22: instruction = jmp(0);
			// pop
			23: instruction = {`JMP, `EQ, `REG, `STACK_SIZE, `NUM, 8'd0, 8'd0};
			24: instruction = resetg(8'b11000000);
			25: instruction = mov(`PUR, `REG, `STACK1, `STACK0);
			26: instruction = mov(`PUR, `REG, `STACK2, `STACK1);
			27: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			28: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			29: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE);
			30: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE);
			31: instruction = resetg(8'b01111111);
			32: instruction = {`JMP, `EQ, `REG, `STACK_SIZE, `NUM, 8'd0, 8'd0};
			33: instruction = setg(8'b10000000);
			34: instruction = mov(`PUR, `REG, `STACK0, `DOUT);
			35: instruction = jmp(0);
//			6: instruction = {`JMP, `EQ, `REG, `FLAG, `NUM, `PUSH, 8'd0};
//			7: instruction = jmp(0);
//			8: instruction = set(`DOUT, 30);
//			9: instruction = jmp(0);
//			10: instruction = set(`DOUT, 40);
//			11: instruction = jmp(0);
//			12: instruction = set(`DOUT, 50);
//			13: instruction = jmp(0);
			
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
	
	// Set bits of GOUT
	function [31:0] setg;
		input [7:0] bit_mask; // bits with 0 will be left the same and bits with 1 will be turned on
		setg = {`ACC, `OR, `NUM, bit_mask, `REG, `GOUT, `N8};
	endfunction
	// Reset bits of GOUT
	function [31:0] resetg;
		input [7:0] bit_mask; // bits with 1 will be left the same and bits with 0 will be turned off
		resetg = {`ACC, `AND, `NUM, bit_mask, `REG, `GOUT, `N8};
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


