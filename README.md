# Floating point ALU
## 1. Introduction:
The Floating Point Arithmetic Logic Unit (FPU) stands as a cornerstone of modern computing, enabling precise calculations with real numbers in digital systems. Operating under the IEEE 754 standard, the FPU performs complex arithmetic operations like addition, subtraction, and multiplication while managing rounding, exceptional cases, and numerical accuracy. Its role in diverse fields, from scientific simulations to financial analysis, underscores its significance in ensuring accurate and efficient real-world computations.
## 2. Features: 
- Supports single-precision (32-bit) floating-point formats.
- Implements essential arithmetic operations:
  * Addition
  * Subtraction
  * Multiplication
- Modular architecture for easy integration into larger systems.
- Testbench for functional verification with a golden model written with Python code.
- Synthesis-ready design for FPGA deployment.
## 3. Architecture:

![FPU architecture](https://github.com/petergad14/Floating_point_ALU/assets/139645814/d594eaae-4883-4644-baeb-ba84aa586036)


As shown in the architecture, the design mainly consists of 5 blocks:

a. `Exponent comparator`: which takes the exponents of both numbers and the opcode and outputs the shift amount and the exponent if the operation is addition or outputs the sum of the exponents if the operation is multiplication.

b. `Shifter`: It takes the mantissa of both inputs and shifts them by the value needed if the operation is addition.

c. `Add/Sub & normalize`: This is an FSM to add the Mantissa and then normalize to get the final value of addition and then raise a flag that the operation is done.

d. `Mantissa multiplication`: If the operation of the ALU is multiplication, this block takes the mantissas as input and multiplies them together.

e. `Multiplication FSM`: This block is used when the operation performed by the ALU is multiplication and it takes as input both numbers, exponent, and the output of the previous block, performs the final operation, and then raises a flag when the operation is done.

## 4. Verification:
A Python code was written as a golden model and a test was made for 1000 inputs for addition, subtraction, and multiplication. We took the test results in a txt file and imported it in our testbench and all the results were correct.

## 5. Synthesis: 
  Synthesis was done using ISE on Xillinix 3e FPGA and the summary is shown in the figure below
  
![Synthesis Summar](https://github.com/petergad14/Floating_point_ALU/assets/139645814/3514b98f-6d3f-4556-ba58-7c89b05d6db5)


<br /> 
<br />
<br />

> <h3 align="center">
  > Thank you for reading and if you have any questions regarding the architecture or the codes, please feel free to reach me.
</h3>


  
