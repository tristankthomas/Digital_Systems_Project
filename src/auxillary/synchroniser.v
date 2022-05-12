// Synchronises an n bit input to avoid metastability, using 
// two flip flops

module synchroniser
	#( 
	parameter n = 1 	// define number of bits (1 default)
	)	
	(
		input clk,
		input [n-1:0] in,
		output reg [n-1:0] in_sync
	);
	
	reg [n-1:0] buff;
	
	always @(posedge clk) begin
		buff <= in;
		in_sync <= buff;
	end
	
endmodule
	
	