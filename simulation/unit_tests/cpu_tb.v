`timescale 1ns/1ns
`define HALF_PERIOD 10
`include "cpu_definitions.vh"

module cpu_tb;
	reg clk = 0;
	reg enable = 1;
	reg resetn = 1;
	reg [31:0] instruction;
	wire [7:0] ip;
	wire [7:0] reg_dout;
	
	
	initial begin
		forever #`HALF_PERIOD clk = !clk;
		
	end
	
	cpu cpu_inst
	(
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.instruction(instruction),
		.instruction_pointer(ip),
		.din(),
		.gpi(),
		.reg_gout(),
		.reg_dout(reg_dout),
		.reg_flag()
	);
	
	initial begin
		instruction = {`MOV, `PUR, `NUM, 8'd1, `REG, `DOUT, `N8};
		$display(reg_dout);
		
		
		
		
	end
	
endmodule
		

