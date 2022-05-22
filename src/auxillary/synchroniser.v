/* Synchronises an n bit input to avoid metastability, using 
   two flip flops */

module synchroniser
#( 
	// define number of bits (1 default)
	parameter n = 1 	
)	
(
	input clk,
	input [n-1:0] in,
	output reg [n-1:0] in_sync
);
	// buffer used as wire between two flip flops
	reg [n-1:0] buff;
	
	always @(posedge clk) begin
		buff <= in;
		in_sync <= buff;
	end
	
endmodule
	
	