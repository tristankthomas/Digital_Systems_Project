`include "cpu_definitions.vh"
`default_nettype none

module register_file
(
	input wire clk,
	input wire enable,
	input wire resetn,
	input wire long_press,
	
	// Port a (read only)
	input wire [4:0] a_addr,
	output wire [7:0] a_data_out,
	
	// Port b (read / write)
	input wire [4:0] b_addr,
	input wire [7:0] b_data_in,
	input wire b_wr_enable,
	output wire [7:0] b_data_out,
	
	// Flag Register Input Signals
	input wire [7:0] flag_inputs,
	
	// Special Registers
	input wire [7:0] reg_din,
	output wire [7:0] reg_gout,
	output wire [7:0] reg_dout,
	output wire [7:0] reg_flag,
	
	// ATC
	input wire is_atc,
	input wire [2:0] atc_bit,
	output wire atc_out
);
	
	reg [7:0] reg_arr [0:31]; // 32 8 bit registers not 32 bits 
	
	// Reads
	assign a_data_out = reg_arr[a_addr]; // if the argument 1 type is a 1 ( 5 bit register address) then operand of alu is the contents of a_addr (or arg1) (NOTE: a_data_out corresponds to the first argument (will never write anything)
	assign b_data_out = reg_arr[b_addr];
	
	assign atc_out = is_atc ? reg_arr[`FLAG][atc_bit] : 1'b0;
	
	// Write Functionality
	always @(posedge clk or negedge resetn) begin : write_block
		integer i;
		if (!resetn)
			for (i = 0; i < 32; i = i + 1)
				reg_arr[i] <= 8'd0; // clears all the registers to 0
		else if (enable) begin		// note the controlled enable is temperarily always 1 (will be fixed later)
		
			if (b_wr_enable && b_addr != `FLAG)
				reg_arr[b_addr] <= b_data_in; // since the register is able to write it writes d_data_in into the register at address b (could be special reg's)
			
			// If ATC command, clear the atc bit
			if (is_atc)
				reg_arr[`FLAG][atc_bit] <= 1'b0;
			
			// Set FLAG bits. This must be after any register write to not miss a flag
			for (i = 0; i < 7; i = i + 1)
				if (flag_inputs[i] && !long_press)
					reg_arr[`FLAG][i] <= 1'b1;
			// Always want the dinput register to be written by dinput
			reg_arr[`DINP] <= reg_din;
					
		end else begin
			for (i = 0; i < 7; i = i + 1)
				if (flag_inputs[i] && !long_press)
					reg_arr[`FLAG][i] <= 1'b1;
			// Always want the dinput register to be written by dinput
			reg_arr[`DINP] <= reg_din;
					
		end
	end
	
	assign reg_gout = reg_arr[`GOUT]; 	// stores the contents of register num 29 into reg_gout
	assign reg_dout = reg_arr[`DOUT];	// stores the contents of register num 30 into reg_dout
	assign reg_flag = reg_arr[`FLAG];	// stores the contents of register num 31 into reg_flag
	
	//assign reg_gout[7] = resetn; // Temporary solution to dval
	
endmodule

				