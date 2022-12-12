# CPU and RPN Calculator for FPGA
This project was created for a digital systems subject and required creating a functional RPN calculator using a Cyclone V FPGA and a DE1 SoC Development board. This project was completed in two parts, creating the CPU and programming the CPU (in machine code) to run the RPN calculator. An example RPN calculator can be found [here](http://www.alcula.com/calculators/rpn/). The arithmetic operations that the ALU can perform can be found in the cpu_definitions.vh file. The calculator can perform addition, subtraction, multiplication and floor division on signed 8-bit integers (-127 to 128).
## Operation
The CPU module and calculator program can be implemented onto the development board by loading the rpn_calculator.qws file (specific to the DE1 SoC board) into the FPGA synthesis program, Quartus Prime. The pin file is also provided for the DE1 SoC board. The interface is shown below:
<img width="948" alt="Screenshot 2022-12-09 at 1 44 27 pm" src="https://user-images.githubusercontent.com/87408805/206970008-ab64bceb-c6c1-47d8-bc7a-bf3a56dc7121.png">

- The 8 right most switches are used to input (in binary) the 8-bit integers which is displayed on the 4 rightmost 7-segment displays in decimal. 
- The 2 leftmost push buttons are used to push and pop onto the stack and by holding down leftmost button, the display can change from binary to decimal and vice versa. 
- The 2 rightmost push buttons are used for additon and multiplication, and holding them down will allow subtraction and division.
- The four rightmost LEDs are used to indicate how many numbers are on the stack and the next two are used as arithmetic overflow and stack overflow indicators.
