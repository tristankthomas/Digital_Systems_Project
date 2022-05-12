`default_nettype none
`include "cpu_definitions.vh"

module cpu
(
	// System
	input wire clk,
	input wire enable,
	input wire resetn,
	// Instructions
	input wire [31:0] instruction,
	output reg [7:0] instruction_pointer,
	// Inputs
	input wire [7:0] din,
	input wire[3:0] gpi,
	// Outputs
	output wire [7:0] reg_dout,
	output wire [7:0] reg_gout,
	output wire [7:0] reg_flag
);


	wire [2:0] command_group;
	wire [2:0] command;
	wire [7:0] arg1;
	wire [7:0] arg2;
	wire [7:0] result;
	wire [7:0] address;
	wire branch_select;
	wire [3:0] alu_op;
	wire write_enable;
	
	
	assign reg_gout = 8'b1000_0000; // Turn on dval (reg_gout[7])
	
	always @(posedge clk or negedge resetn)
		if (!resetn)
			instruction_pointer <= 8'd0;
		else if (enable)		// pointer incremented when enable out is 1 (controlled by turbo)
			instruction_pointer <= (branch_select && result) ? address : instruction_pointer + 1;		// instruction pointer incremented and then next arg1 (from ROM) stored in reg_dout
			
			
	// register file
	register_file
	reg_ista
	(
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		
		.a_addr(arg1), // the argument is a number in this case (8 bits)
		.a_data_out(),
		
		.b_addr(arg2),
		.b_data_in(result),
		.b_wr_enable(write_enable),
		.b_data_out(),
		
		.reg_gout(),
		.reg_dout(reg_dout),
		.reg_flag(reg_flag)
	);
	
	
			
	// instruction splitter
	instruction_splitter
	is
	(
		.instruction(instruction),
		.command_group(command_group),
		.command(command),
		.arg1(arg1),
		.arg2(arg2),
		.address(address)
	);
	

	// controller
	controller
	cont_insta
	(
		.command_group(command_group),
		.write_enable(write_enable),
		.branch_select(branch_select),
		.alu_op(alu_op)
	);
	
	
	// ALU 
	alu
	alu_insta
	(
		.operand_a(arg1),
		.alu_op(alu_op),
		.result(result)
	);
	
	

	
			
endmodule
