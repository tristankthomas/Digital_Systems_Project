`include "./cpu/cpu_definitions.vh"
`default_nettype none

module instruction_memory
(
	input wire [7:0] address,		// maximum of 256 different addresses
	output reg [31:0] instruction
);

	always @(*)
		case(address)

			// Instructions for RPN calculator
			// wait
			0: instruction = atc(`PUSH, 5);
			1: instruction = atc(`POP, 23);
			2: instruction = atc(`ADD, 36);
			3: instruction = atc(`MULT, 52);
			4: instruction = jmp(0);
			// push
			5: instruction = mov(`PUR, `REG, `STACK2, `STACK3); // move stack up
			6: instruction = mov(`PUR, `REG, `STACK1, `STACK2);
			7: instruction = mov(`PUR, `REG, `STACK0, `STACK1);
			8: instruction = mov(`PUR, `REG, `DINP, `STACK0);
			9: instruction = mov(`PUR, `REG, `STACK0, `DOUT); 					// display new stack0
			10: instruction = setg(`NUM, 8'b10000000); 							// turn on dval and leave other bits
			11: instruction = jmp_if_size(8, 17);  								// jump to overflow code if stack if full
			12: instruction = resetg(`NUM, 8'b11000000); 						// reset all bits of gout except dval
			13: instruction = jmp_if_size(0, 20); 									// jump to initialise code is stack is empty
			14: instruction = mov(`SHL, `REG, `STACK_SIZE, `STACK_SIZE); 	// shift stack size to the left
			15: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE);  			// Setting the stack size bits in gout whilst leaving the other bits
			16: instruction = jmp(0);
			// stack overflow
			17: instruction = setg(`NUM, 8'b00100000); 							// set the overflow led to 1 whilst leaving all other bits
			18: instruction = resetg(`NUM, 8'b11101111); 						// set the arithmetic overflow led to 0 whilst leaving all other bits
			19: instruction = jmp(0);
			// stack initialising
			20: instruction = set(`STACK_SIZE, 8'd1); 							// initialise stack size to 1
			21: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE); 			// set the stack size bits in gout whilst leaving all other bits
			22: instruction = jmp(0);
			// pop
			23: instruction = jmp_if_size(0, 0); 									// jump to wait if stack is empty
			24: instruction = resetg(`NUM, 8'b11000000);  						// reset all bits of gout except dval
			25: instruction = mov(`PUR, `REG, `STACK1, `STACK0); 				// move stack down
			26: instruction = mov(`PUR, `REG, `STACK2, `STACK1);
			27: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			28: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			29: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE); 	// shift stack size to right
			30: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE); 			// set the stack size bits in gout whilst leaving the other bits
			31: instruction = resetg(`NUM, 8'b01111111); 						// set dval to off whilst leaving all other bits
			32: instruction = jmp_if_size(0, 0); 									// jump to wait if stack is empty (after shift)
			33: instruction = setg(`NUM, 8'b10000000); 							// turn dval on whilst leaving all other bits 
			34: instruction = mov(`PUR, `REG, `STACK0, `DOUT);  				// display the contents of stack0
			35: instruction = jmp(0);
			// addition
			36: instruction = resetg(`NUM, 8'b11101111); 						// set arithmetic overflow led to off
			37: instruction = jmp_if_size(0, 0); 									// go to wait if stack is empty or one element (cant add one element)
			38: instruction = jmp_if_size(1, 0);
			39: instruction = acc(`SAD, `STACK0, `REG, `STACK1); 				// add the contents of stack 1 to 0 and store in stack 0 
			40: instruction = mov(`PUR, `REG, `STACK0, `DOUT);  				// display stack0(dont need to worry about enabling display since it is only disabled if there is nothing on stack)
			41: instruction = atc(`OFLW, 50);			
			42: instruction = resetg(`NUM, 8'b11011111); 						// turns off the stack overflow led off
			43: instruction = mov(`PUR, `REG, `STACK2, `STACK1); 				// moves rest of stack down
			44: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			45: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			46: instruction = resetg(`NUM, 8'b11110000); 						// resets the current size of stack led to 0 whist leaving all others
			47: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE); 	// shifts stack size to the right
			48: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE); 			// displays the stack size on leds
			49: instruction = jmp(0);
			50: instruction = setg(`NUM, 8'b00010000);
			51: instruction = jmp(42);
			// multiplication
			52: instruction = jmp_if_size(0, 0);									// jump to wait if stack is empty
			53: instruction = resetg(`NUM, 8'b11101111); 						// set arithmetic overflow led to off
			54: instruction = {`JMP, `SLE, `NUM, 8'd2, `REG, `STACK_SIZE, 8'd58};
			55: instruction = mov(`PUR, `NUM, 8'd0, `STACK0);
			56: instruction = mov(`PUR, `REG, `STACK0, `DOUT);
			57: instruction = jmp(0);
			// normal mult
			58: instruction = acc(`SMT, `STACK0, `REG, `STACK1);
			59: instruction = atc(`OFLW, 69);
			60: instruction = resetg(`NUM, 8'b11011111); 
			61: instruction = mov(`PUR, `REG, `STACK0, `DOUT); 
			62: instruction = mov(`PUR, `REG, `STACK2, `STACK1); 				// moves rest of stack down
			63: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			64: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			65: instruction = resetg(`NUM, 8'b11110000); 
			66: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE);
			67: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE);
			68: instruction = jmp(0);
			69: instruction = setg(`NUM, 8'b00010000);
			70: instruction = jmp(60);
			
			default: instruction = 32'd0; // NOP

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
		input mask_type;
		input [7:0] bit_mask; // bits with 0 will be left the same and bits with 1 will be turned on
		setg = {`ACC, `OR, mask_type, bit_mask, `REG, `GOUT, `N8};
	endfunction
	// Reset bits of GOUT
	function [31:0] resetg;
		input mask_type;
		input [7:0] bit_mask; // bits with 1 will be left the same and bits with 0 will be turned off
		resetg = {`ACC, `AND, mask_type, bit_mask, `REG, `GOUT, `N8};
	endfunction
	
	function [31:0] jmp_if_size;
		input [7:0] size;
		input [7:0] addr;
		jmp_if_size = {`JMP, `EQ, `REG, `STACK_SIZE, `NUM, size, addr};
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


