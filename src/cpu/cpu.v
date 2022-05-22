/* Controls and undertakes the computer processing 
  DECODE PHASE */
  
`default_nettype none
`include "cpu_definitions.vh"

module cpu
(
	// System
	input wire 			clk,
	input wire 			enable,
	input wire 			resetn,
	input wire [3:0]	long_press,
	input wire [3:0]	long_edge,
	// Instructions
	input wire [31:0] instruction,
	output reg [7:0] 	instruction_pointer,
	// Inputs
	input wire [7:0]	din,
	input wire [3:0] 	gpi,
	// Outputs
	output wire [7:0] reg_dout,
	output wire [7:0] reg_gout,
	output wire [7:0] reg_flag
);


	wire [2:0] command_group;
	wire [2:0] command;
	wire [7:0] arg1;
	wire  	  arg1_type;
	wire [7:0] arg2;
	wire 		  arg2_type;
	wire [7:0] address;
	
	wire [7:0] result;
	wire 		  branch_select;
	wire [4:0] alu_op;
	wire 		  is_atc;
	wire 		  write_enable;
	wire [7:0] flag_inputs;
	wire [7:0] a_data_out;
	wire [7:0] b_data_out;
	wire 		  atc_out;
	
	
	always @(posedge clk or negedge resetn)
		if (!resetn)
			instruction_pointer <= 8'd0;
		else if (enable)		// rate of pointer movement based on enable
			
			// pointer moves to specific address
			if ((branch_select && atc_out && !result) || (branch_select && result && !atc_out))
				instruction_pointer <= address;
			// pointer incremented if certain conditions not met
			else
				instruction_pointer <= instruction_pointer + 1;
			 

	// flag register composition
	assign flag_inputs = {long_edge[1:0], shift_overflow, arithmetic_overflow, gpi};
	
	// register file
	register_file
	reg_ista
	(
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.long_press(long_press),
		
		.a_addr(arg1),
		// only used in ALU if arg1 is a register address (operand_a)
		.a_data_out(a_data_out), 
		
		.b_addr(arg2),
		// Writes this value into the register specifed by argument 2
		.b_data_in(result),  
		.b_wr_enable(write_enable),
		// Takes the value at b_addr and stores it in b_data_out (operand_b if used)
		.b_data_out(b_data_out),  
		
		.flag_inputs(flag_inputs),
		
		.reg_din(din),
		.reg_gout(reg_gout),
		.reg_dout(reg_dout),
		.reg_flag(reg_flag),
		
		.is_atc(is_atc),
		.atc_bit(command),
		.atc_out(atc_out)
	);
	
	
			
	// instruction splitter
	instruction_splitter
	is
	(
		.instruction(instruction),
		.command_group(command_group),
		.command(command),
		.arg1_type(arg1_type),
		.arg1(arg1),
		.arg2_type(arg2_type),
		.arg2(arg2),
		.address(address)
	);

	// controller
	controller
	cont_insta
	(
		.command_group(command_group),
		.command(command),
		.write_enable(write_enable),
		.branch_select(branch_select),
		.alu_op(alu_op),
		.is_atc(is_atc)
	);
	
	
	// ALU
	// operand a is a number if the type is 0 or whatever is stored in the register at a_addr if 1
	wire [7:0] operand_a = arg1_type ? a_data_out : arg1;
	// operand b is a number if the type is 0 or whatever is stored in the register at b_addr if 1
	wire [7:0] operand_b = arg2_type ? b_data_out : arg2;
	
	wire shift_overflow;
	wire arithmetic_overflow;
	alu
	alu_insta
	(
		.operand_a(operand_a),
		.operand_b(operand_b),
		.alu_op(alu_op),
		.result(result),
		.shift_overflow(shift_overflow),
		.arithmetic_overflow(arithmetic_overflow)
		
	);
	
	
			
endmodule
