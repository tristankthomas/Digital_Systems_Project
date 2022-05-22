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
			0: instruction = atc(`PUSH, 7);
			1: instruction = atc(`POP, 25);
			2: instruction = atc(`ADD, 38);
			3: instruction = atc(`MULT, 54);
			4: instruction = atc(`SUB, 73);
			5: instruction = atc(`DIV, 89);
			6: instruction = jmp(0);
			// push
			7: instruction = mov(`PUR, `REG, `STACK2, `STACK3); // move stack up
			8: instruction = mov(`PUR, `REG, `STACK1, `STACK2);
			9: instruction = mov(`PUR, `REG, `STACK0, `STACK1);
			10: instruction = mov(`PUR, `REG, `DINP, `STACK0);
			11: instruction = mov(`PUR, `REG, `STACK0, `DOUT); 					// display new stack0
			12: instruction = setg(`NUM, 8'b10000000); 							// turn on dval and leave other bits
			13: instruction = jmp_if_size(8, 19);  								// jump to overflow code if stack if full
			14: instruction = resetg(`NUM, 8'b11000000); 						// reset all bits of gout except dval
			15: instruction = jmp_if_size(0, 22); 									// jump to initialise code is stack is empty
			16: instruction = mov(`SHL, `REG, `STACK_SIZE, `STACK_SIZE); 	// shift stack size to the left
			17: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE);  			// Setting the stack size bits in gout whilst leaving the other bits
			18: instruction = jmp(0);
			// stack overflow
			19: instruction = setg(`NUM, 8'b00100000); 							// set the overflow led to 1 whilst leaving all other bits
			20: instruction = resetg(`NUM, 8'b11101111); 						// set the arithmetic overflow led to 0 whilst leaving all other bits
			21: instruction = jmp(0);
			// stack initialising
			22: instruction = set(`STACK_SIZE, 8'd1); 							// initialise stack size to 1
			23: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE); 			// set the stack size bits in gout whilst leaving all other bits
			24: instruction = jmp(0);
			// pop
			25: instruction = jmp_if_size(0, 0); 									// jump to wait if stack is empty
			26: instruction = resetg(`NUM, 8'b11000000);  						// reset all bits of gout except dval
			27: instruction = mov(`PUR, `REG, `STACK1, `STACK0); 				// move stack down
			28: instruction = mov(`PUR, `REG, `STACK2, `STACK1);
			29: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			30: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			31: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE); 	// shift stack size to right
			32: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE); 			// set the stack size bits in gout whilst leaving the other bits
			33: instruction = resetg(`NUM, 8'b01111111); 						// set dval to off whilst leaving all other bits
			34: instruction = jmp_if_size(0, 0); 									// jump to wait if stack is empty (after shift)
			35: instruction = setg(`NUM, 8'b10000000); 							// turn dval on whilst leaving all other bits 
			36: instruction = mov(`PUR, `REG, `STACK0, `DOUT);  				// display the contents of stack0
			37: instruction = jmp(0);
			// addition
			38: instruction = resetg(`NUM, 8'b11101111); 						// set arithmetic overflow led to off
			39: instruction = jmp_if_size(0, 0); 									// go to wait if stack is empty or one element (cant add one element)
			40: instruction = jmp_if_size(1, 0);
			41: instruction = acc(`ACC_ART, `SAD, `STACK0, `REG, `STACK1); 				// add the contents of stack 1 to 0 and store in stack 0 
			42: instruction = mov(`PUR, `REG, `STACK0, `DOUT);  				// display stack0(dont need to worry about enabling display since it is only disabled if there is nothing on stack)
			43: instruction = atc(`OFLW, 52);			
			44: instruction = resetg(`NUM, 8'b11011111); 						// turns off the stack overflow led off
			45: instruction = mov(`PUR, `REG, `STACK2, `STACK1); 				// moves rest of stack down
			46: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			47: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			48: instruction = resetg(`NUM, 8'b11110000); 						// resets the current size of stack led to 0 whist leaving all others
			49: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE); 	// shifts stack size to the right
			50: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE); 			// displays the stack size on leds
			51: instruction = jmp(0);
			52: instruction = setg(`NUM, 8'b00010000);
			53: instruction = jmp(44);
			// multiplication
			54: instruction = jmp_if_size(0, 0);									// jump to wait if stack is empty
			55: instruction = resetg(`NUM, 8'b11101111); 						// set arithmetic overflow led to off
			56: instruction = {`JMP, `SLE, `NUM, 8'd2, `REG, `STACK_SIZE, 8'd60};
			57: instruction = mov(`PUR, `NUM, 8'd0, `STACK0);
			58: instruction = mov(`PUR, `REG, `STACK0, `DOUT);
			59: instruction = jmp(0);
			// normal mult
			60: instruction = acc(`ACC_ART, `SMT, `STACK0, `REG, `STACK1);
			61: instruction = atc(`OFLW, 71);
			62: instruction = resetg(`NUM, 8'b11011111); 
			63: instruction = mov(`PUR, `REG, `STACK0, `DOUT); 
			64: instruction = mov(`PUR, `REG, `STACK2, `STACK1); 				// moves rest of stack down
			65: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			66: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			67: instruction = resetg(`NUM, 8'b11110000); 
			68: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE);
			69: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE);
			70: instruction = jmp(0);
			71: instruction = setg(`NUM, 8'b00010000);
			72: instruction = jmp(62);
			// subtraction (higher stack - lower stack)
			73: instruction = resetg(`NUM, 8'b11101111); 						// set arithmetic overflow led to off
			74: instruction = jmp_if_size(0, 0); 									// go to wait if stack is empty or one element (cant add one element)
			75: instruction = jmp_if_size(1, 0);
			76: instruction = acc(`ACC_ART, `SSB, `STACK0, `REG, `STACK1); 				// add the contents of stack 1 to 0 and store in stack 0 
			77: instruction = mov(`PUR, `REG, `STACK0, `DOUT);  				// display stack0(dont need to worry about enabling display since it is only disabled if there is nothing on stack)
			78: instruction = atc(`OFLW, 87);			
			79: instruction = resetg(`NUM, 8'b11011111); 						// turns off the stack overflow led off
			80: instruction = mov(`PUR, `REG, `STACK2, `STACK1); 				// moves rest of stack down
			81: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			82: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			83: instruction = resetg(`NUM, 8'b11110000); 						// resets the current size of stack led to 0 whist leaving all others
			84: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE); 	// shifts stack size to the right
			85: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE); 			// displays the stack size on leds
			86: instruction = jmp(0);
			87: instruction = setg(`NUM, 8'b00010000);
			88: instruction = jmp(79);
			// division (higher stack / lower stack) (floor)
			89: instruction = jmp_if_size(0, 0);									// jump to wait if stack is empty
			90: instruction = resetg(`NUM, 8'b11101111); 						// set arithmetic overflow led to off
			91: instruction = {`JMP, `SLE, `NUM, 8'd2, `REG, `STACK_SIZE, 8'd95};
			92: instruction = mov(`PUR, `NUM, 8'd0, `STACK0);
			93: instruction = mov(`PUR, `REG, `STACK0, `DOUT);
			94: instruction = jmp(0);
			// normal division
			95: instruction = acc(`ACC_ART, `SDV, `STACK0, `REG, `STACK1);
			96: instruction = atc(`OFLW, 106); // Overflow for division is divide by 0
			97: instruction = resetg(`NUM, 8'b11011111); 
			98: instruction = mov(`PUR, `REG, `STACK0, `DOUT); 
			99: instruction = mov(`PUR, `REG, `STACK2, `STACK1); 				// moves rest of stack down
			100: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			101: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			102: instruction = resetg(`NUM, 8'b11110000); 
			103: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE);
			104: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE);
			105: instruction = jmp(0);
			
			106: instruction = setg(`NUM, 8'b00010000);
			107: instruction = resetg(`NUM, 8'b11011111);
			108: instruction = mov(`PUR, `REG, `STACK2, `STACK1); 				// moves rest of stack down
			109: instruction = mov(`PUR, `REG, `STACK3, `STACK2);
			110: instruction = mov(`PUR, `NUM, 8'd0, `STACK3);
			111: instruction = resetg(`NUM, 8'b11110000); 
			112: instruction = mov(`SHR, `REG, `STACK_SIZE, `STACK_SIZE);
			113: instruction = acc(`ACC_LOG, `OR, `GOUT, `REG, `STACK_SIZE);
			114: instruction = jmp(0);
			
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
		setg = {`ACC_LOG, `OR, mask_type, bit_mask, `REG, `GOUT, `N8};
	endfunction
	// Reset bits of GOUT
	function [31:0] resetg;
		input mask_type;
		input [7:0] bit_mask; // bits with 1 will be left the same and bits with 0 will be turned off
		resetg = {`ACC_LOG, `AND, mask_type, bit_mask, `REG, `GOUT, `N8};
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
		input [2:0] acc_type;
		input [2:0] op;
		input [7:0] reg_num;
		input num_type;
		input [7:0] num;
		acc = {acc_type, op, num_type, num, `REG, reg_num, `N8};
	endfunction
	
	
	
		
endmodule


