// Command Groups
`define NOP 3'b000 // No Operation
`define MOV 3'b011 // Move

// Move Commands
`define PUR 3'b000 // Pure Move

// Argument Types
`define NUM 1'b0 // Number Type
`define REG 1'b1 // Register Type

// Special Registers
`define DINP 8'd28 // Data Input Register Address
`define GOUT 8'd29 // General Purpose Register Address
`define DOUT 8'd30 // Data Output Register Address
`define FLAG 8'd31 // Flag Register Address

// Other Useful Definitions
// Zeros
`define N8 8'd0
`define N9 9'd0
