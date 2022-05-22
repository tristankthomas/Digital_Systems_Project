// Command Groups
`define NOP 	 3'b000 // No Operation
`define JMP 	 3'b001 // Jump
`define ATC 	 3'b010 // Atomic Test and Clear
`define MOV	 	 3'b011 // Move
`define ACC_ART 3'b100 // Arithmetic Accumulate
`define ACC_LOG 3'b101 // Logical Accumulate

// Move Commands
`define PUR 3'b000 // Pure Move
`define SHL 3'b001 // Move and Shift Left
`define SHR 3'b010 // Move and Shift Right

// Jump Commands
`define UNC 3'b000 // Unconditional Jump
`define EQ  3'b001 // Jump on Equality
`define ULT 3'b010 // Jump on Unsigned Less Than
`define SLT 3'b011 // Jump on Signed Less Than
`define ULE 3'b100 // Jump on Unsigned Less Than or Equal To
`define SLE 3'b101 // Jump on Signed Less Than or Equal To

// Arithmetic Accumulate Commands
`define UAD 3'b000 // Unsigned Addition
`define SAD 3'b001 // Signed Addition
`define UMT 3'b010 // Unsiged Multiplication
`define SMT 3'b011 // Signed Multiplication
`define USB 3'b100 // Unsigned Subtraction
`define SSB 3'b101 // Signed Subtraction
`define UDV 3'b110 // Unsigned Floor Division
`define SDV 3'b111 // Signed Floor Division

// Logical Accumulate Commands
`define AND 3'b000 // Bitwise AND
`define OR  3'b001 // Bitwise OR
`define XOR 3'b011 // Bitwise XOR

// ALU Op Code Constants
`define ALU_PUR 5'd0 // No Logic or Arithmetic Operation
`define ALU_SHL 5'd1 // Left Shift
`define ALU_SHR 5'd2 // Right Shift

`define ALU_UAD 5'd3 // Unsigned Addition
`define ALU_SAD 5'd4 // Signed Addition
`define ALU_UMT 5'd5 // Unsigned Multiplication
`define ALU_SMT 5'd6 // Signed Multiplication
`define ALU_USB 5'd7 // Unsigned Subtraction
`define ALU_SSB 5'd8 // Signed Subtraction
`define ALU_UDV 5'd9 // Unsigned Floor Division
`define ALU_SDV 5'd10 // Signed Floor Division

`define ALU_AND 5'd11 // Bitwise AND
`define ALU_OR  5'd12 // Bitwise OR
`define ALU_XOR 5'd13 // Bitwise XOR

`define ALU_UNC 5'd14 // Always True
`define ALU_EQ  5'd15 // Equality
`define ALU_ULT 5'd16 // Unsigned Less Than
`define ALU_SLT 5'd17 // Signed Less Than
`define ALU_ULE 5'd18 // Unsigned Less Than or Equal To
`define ALU_SLE 5'd19 // Signed Less Than or Equal To


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
`define STACK3 8'd3 // Fourth Stack
`define STACK_SIZE 8'd4 // Stack Size

// Flag Register Bits
`define MULT 3'd0
`define ADD  3'd1
`define POP  3'd2
`define PUSH 3'd3
`define OFLW 3'd4
`define SHFT 3'd5
`define DIV  3'd6
`define SUB  3'd7

// Other Useful Definitions
// Zeros

`define N8 8'd0 // 8 Zeros
`define N9 9'd0 // 9 Zeros
`define TRUE 8'd1 // 8 Bit True


