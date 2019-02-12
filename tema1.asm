%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .bss
	expr: resb MAX_INPUT_SIZE
        negative: resb 1

section .text
global CMAIN
CMAIN:
        mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp

	GET_STRING expr, MAX_INPUT_SIZE
      
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

read:
	cmp byte[expr + ecx], 0        ; checks if the string terminator is reached
	jz stop

	cmp byte[expr + ecx], '+'      ; checks if an addition must be performed
	jz addition

	cmp byte[expr + ecx], '-'      ; checks if a subtraction must be performed
	jz subtraction

	cmp byte[expr + ecx], '*'      ; checks if a multiplication must be performed
	jz multiplication

	cmp byte[expr + ecx], '/'      ; checks if a division must be performed
	jz division

	cmp byte[expr + ecx], ' '      ; if no operation should be performed
	jnz get_number                 ; and if the current character is not
                                   ; a space, a number is read

resume:
	inc ecx
	jmp read                      ; continues the loop

check_number:
	cmp byte [negative], 1         ; checks if a number is negative
	jz compute_negative_number

push_number:
	push eax                       ; pushes the number into the stack
	xor edx, edx
	xor eax, eax
	jmp resume                     ; resumes reading the expression

compute_negative_number:
	mov byte[negative], 0
	not eax                        ; computes the two's complement
	inc eax                        ; of the negative number
	jmp push_number
                
get_number:
	mov ebx, 10                    ; multiplies the current number
	mul ebx                        ; by 10
	mov bl, byte[expr + ecx]       ; converts the string character
	sub bl, '0'                    ; to a digit
	add eax, ebx                   ; adds the current digit to the number
        
	inc ecx
        
	cmp byte[expr + ecx], ' '      ; checks if the number has been read
	jz check_number
        
	jmp get_number                 ; keeps reading the number

get_negative_number:
	mov byte [negative], 1         ; remembers if the number is negative
	inc ecx
	jmp get_number                 ; reads the number from the MSD to the LSD
                
addition:
	pop ebx                        ; pops the operands from the stack
	pop eax
	add eax, ebx                   ; does the addition
	push eax                       ; pushes the sum into the stack
	xor eax, eax
	jmp resume                     ; resumes reading the expression

subtraction:
	cmp byte[expr + ecx + 1], ' '  ; checks if it is an operand or the sign
	jg get_negative_number         ; of a number

	pop ebx                        ; pops the operands from the stack
	pop eax
	sub eax, ebx                   ; does the subtraction
	push eax                       ; pushes the result into the stack
	xor eax, eax
	jmp resume                     ; resumes reading the expression

multiplication:
	pop ebx                        ; pops the operands from the stack
	pop eax
	imul ebx                       ; does the multiplication
	push eax                       ; pushes the product into the stack
	xor eax, eax
	jmp resume                     ; resumes reading the expression

division:
	pop ebx                        ; pops the operands from the stack
	pop eax
	cdq
	idiv ebx                       ; does the division
	push eax                       ; pushes the quotient into the stack
	xor eax, eax
	jmp resume                     ; resumes reading the expression

stop:
	pop eax                        ; pops the result from the stack
	PRINT_DEC 4, eax               ; prints the result
	xor eax, eax
	pop ebp
	ret
