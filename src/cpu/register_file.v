`include "cpu_definitions.vh"
`default_nettype none

module register_file
(
	input wire clk,
	input wire enable,
	input wire resetn,
	
	// Port a (read only)
	input wire [4:0] a_addr,
	output wire [7:0] a_data_out,
	
	// Port b (read / write)
	input wire [4:0] b_addr,
	input wire [7:0] b_data_in,
	input wire b_wr_enable,
	output wire [7:0] b_data_out,
	
	// Special Registers
	output wire [7:0] reg_gout,
	output wire [7:0] reg_dout,
	output wire [7:0] reg_flag
);
	
	reg [7:0] reg_arr [0:31]; // 32 8 bit registers not 32 bits 
	
	// Reads
	assign a_data_out = reg_arr[a_addr]; // takes the value of the address at a_addr (8 bit) (out of 32 regs)
	assign b_data_out = reg_arr[b_addr];
	
	// Write Functionality
	always @(posedge clk or negedge resetn) begin : write_block
		integer i;
		if (!resetn)
			for (i = 0; i < 32; i = i + 1)
				reg_arr[i] <= 8'd0; // clears the registers
		else if (enable) begin
			if (b_wr_enable)
				reg_arr[b_addr] <= b_data_in; // since the register is able to write it writes d_data_in into the register at address b
		end
	end
	
	assign reg_gout = reg_arr[`GOUT]; 	// stores the contents of register num 29 into reg_gout
	assign reg_dout = reg_arr[`DOUT];	// stores the contents of register num 30 into reg_dout
	assign reg_flag = reg_arr[`FLAG];	// stores the contents of register num 31 into reg_flag
	
endmodule

				