// Command Groups
`define NOP 3'b000 // No Operation
`define JMP 3'b001 // Jump
`define ATC 3'b010 // Atomic Test and Clear
`define MOV 3'b011 // Move
`define ACC 3'b100 // Accumulate

// Move Commands
`define PUR 3'b000 // Pure Move
`define SHL 3'b001 // Move and Shift Left
`define SHR 3'b010 // Move and Shift Right

// Jump Commands
`define UNC 3'b000 // Unconditional Jump
`define EQ  3'b010 // Jump on Equality
`define ULT 3'b100 // Jump on Unsigned Less Than
`define SLT 3'b101 // Jump on Signed Less Than
`define ULE 3'b110 // Jump on Unsigned Less Than or Equal To
`define SLE 3'b111 // Jump on Signed Less Than or Equal To

// Accumulate Commands
`define UAD 3'b000 // Unsigned Addition
`define SAD 3'b001 // Signed Addition
`define UMT 3'b010 // Unsiged Multiplication
`define SMT 3'b011 // Signed Multiplication
`define AND 3'b100 // Bitwise AND
`define OR  3'b101 // Bitwise OR
`define XOR 3'b110 // Bitwise XOR

// ALU Op Code Constants
`define ALU_PUR 4'd0 // No Logic or Arithmetic Operation
`define ALU_SHL 4'd1 // Left Shift
`define ALU_SHR 4'd2 // Right Shift

`define ALU_UAD 4'd3 // Unsigned Addition
`define ALU_SAD 4'd4 // Signed Addition
`define ALU_UMT 4'd5 // Unsigned Multiplication
`define ALU_SMT 4'd6 // Signed Multiplication
`define ALU_AND 4'd7 // Bitwise AND
`define ALU_OR  4'd8 // Bitwise OR
`define ALU_XOR 4'd9 // Bitwise XOR

`define ALU_UNC 4'd10 // Always True
`define ALU_EQ  4'd11 // Equality
`define ALU_ULT 4'd12 // Unsigned Less Than
`define ALU_SLT 4'd13 // Signed Less Than
`define ALU_ULE 4'd14 // Unsigned Less Than or Equal To
`define ALU_SLE 4'd15 // Signed Less Than or Equal To

// Argument Types
`define NUM 1'b0 // Number Type
`define REG 1'b1 // Register Type

// Special Registers
`define DINP 8'd28 // Data Input Register Address
`define GOUT 8'd29 // General Purpose Register Address
`define DOUT 8'd30 // Data Output Register Address
`define FLAG 8'd31 // Flag Register Address

// Calculator Registers
`define STACK0 8'd0 // First Stack
`define STACK1 8'd1 // Second Stack
`define STACK2 8'd2 // Third Stack
`define STACK3 8'd3 // Forth Stack
`define STACK_SIZE 8'd4 // Stack Size

// Flag Register Bits
`define MULT 3'd0
`define ADD  3'd1
`define POP  3'd2
`define PUSH 3'd3

`define OFLW 3'd4
`define SHFT 3'd5


// Other Useful Definitions
// Zeros

`define N8 8'd0 // 8 Zeros
`define N9 9'd0 // 9 Zeros
`define TRUE 8'd1 // 8 Bit True


