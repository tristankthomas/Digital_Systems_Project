`default_nettype none
`include "cpu_definitions.vh"
	// Control unit
module controller
(
	input wire [2:0] command_group,
	output reg write_enable
);
	always @(*)
		case (command_group)
			`NOP : begin
				write_enable = 1'b0;
			end
			`MOV : begin
				write_enable = 1'b1;
			end
			default: begin
				write_enable = 1'b0;
			end
		endcase
		
endmodule
