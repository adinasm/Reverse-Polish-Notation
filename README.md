# Reverse Polish Notation

    The program evaluates an expression in the reverse Polish notation.

How it's done:
- if a number is read, then it's pushed into the stack;
- if an operator is read, the operands are popped from the stack, the operation
  is performed and the result is pushed back into the stack.

Most important labels:
- read:
  - a character from the string is evaluated;
  - depending on its value, it is either made a jump to the end of the program,
    a jump to a label where an operation is performed (addition, subtraction,
    multiplication, division) or a jump to a label where a number is read;

  - get_number:
    - a number is read from the most significant digit to its least significant
      one;
    - the previous value is multiplied by 10 and the current digit is then
      added;
    - if the number is negative, the two's complement is used.
