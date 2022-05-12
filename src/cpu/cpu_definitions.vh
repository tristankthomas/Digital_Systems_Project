// Command Groups
`define NOP 3'b000 // No Operation
`define MOV 3'b011 // Move
`define JMP 3'b001 // Jump

// Move Commands
`define PUR 3'b000 // Pure Move

// Jump Commands
`define UNC 3'b000 // Unconditional Jump

// ALU Op Code Constants
`define NOOP 4'b0000 // No Logic or Arithmetic Operation
`define UNCOP 4'b0001 // Always True

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
`define N8 8'd0 // 8 Zeros
`define N9 9'd0 // 9 Zeros
`define TRUE 8'd1 // 8 Bit True
