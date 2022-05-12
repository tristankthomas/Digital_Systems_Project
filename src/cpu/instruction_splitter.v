`include "cpu_definitions.vh"

module instruction_splitter
(
	input wire [31:0] instruction,
	output wire [2:0] command_group,
	output wire [2:0] command,
	output wire [7:0] arg1,
	output wire [7:0] arg2,
	output wire [7:0] address
);

	assign command_group = instruction[31 -: 3];
	assign command = instruction[28 -: 3];
	assign arg1 = instruction[24 -: 8];
	assign arg2 = instruction[15 -: 8];
	assign address = instruction[7 -: 8];
	
endmodule

	