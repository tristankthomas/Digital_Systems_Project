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
			// wait  // the first 4 bits of flag register are triggered by pbs so atc will move to address then clear the flag bit
			//0: instruction = setg(`DVALB); 
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
			9: instruction = mov(`PUR, `REG, `STACK0, `DOUT); // display new stack0
			10: instruction = setg(`NUM, 8'b10000000); // turn on dval and leave other bits
			11: instruction = jmp_if_size(8, 17);  // jump to overflow code if stack if full
			12: instruction = resetg(`NUM, 8'b11000000); // reset all bits of gout except dval
			13: instruction = jmp_if_size(0, 20); // jump to initialise code is stack is empty
			14: instruction = mov(`SHL, `REG, `STACK_SIZE, `STACK_SIZE); // shift stack size to the left
			15: instruction = acc(`OR, `GOUT, `REG, `STACK_SIZE);  // Setting the stack size bits in gout whilst leaving the other bits
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


