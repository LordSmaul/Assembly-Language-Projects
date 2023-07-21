BITS 32

;Global and external values
EXTERN atoi, factNum, fact, palindrome
GLOBAL addstr, is_palindrome, factstr, palindrome_check

;Data section for user prompts/strings
SECTION .data
msg4 DB "Please enter a string:", 0xA
msg4len EQU $- msg4
isp DB "The string is a palindrome", 0xA
islen EQU $- isp
notp DB "The string is not a palindrome", 0xA
notlen EQU $- notp

SECTION .bss    ;Uninitialized data
palindromeS RESB 1024

SECTION .text
;This function adds two numbers together and returns the result in eax
;The program takes the input from C, then converts that input to an integer
;It then adds the two numbers together and passes it back to C
addstr:
push ebp
mov ebp, esp

push ebx
push edx

mov ebx, [ebp+8] ;Gets first number
push ebx         
call atoi        ;Converts ebx to an integer - value is stored in eax
pop ebx

mov ebx, eax ;Saves value to ebx

mov edx, [ebp+12] ;Gets second number
push edx
call atoi         ;Converts ebx to an integer - value is stored in eax
pop edx

add ebx, eax ;Adds "second number" to first number
mov eax, ebx ;Moves result of addition into eax

;Pop all used registers
pop edx
pop ebx
pop ebp
ret

;Determines if a string is a palindrome
;Sets indexes at the front and back of the string (accounting for newline)
;and iterates through both until a solution is reached
is_palindrome:
push ebp
mov ebp, esp

push ebx
push ecx
push edx

;Moves into ebx the pointer to the starting address of the user input
mov ebx, [ebp+8]

;Clears both registers so they can be used for indexing
xor edx, edx
xor ecx, ecx

;Iterates to the end of the string and sets ecx register
stringstep:
cmp BYTE [ebx+ecx], 0
je stringstepdone

inc ecx
jmp stringstep


stringstepdone:
dec ecx ;Decrements ecx by one to account for newline character

;Loops through the string to check if it's a palindrome
loop:
;Compares register contents
;If ecx is less than or equal to edx, the string is a palindrome
cmp ecx, edx
jle is2

;Moves each string character into 8-bit registers for comparison
mov al, BYTE [ebx+edx]
mov ah, BYTE [ebx+ecx]
cmp al, ah
jne not2

inc edx
dec ecx
jmp loop

;Moves 1 into eax if string is not a plaindrome - used in C
not2:
mov eax, 1
jmp return2

;Moves 0 into eax if string is a palindrome - used in C
is2:
mov eax, 0

;Pop all used registers
return2:
pop edx
pop ecx
pop ebx
mov esp, ebp
pop ebp
ret

;This function determines the factorial of a number
;It takes user input from C, converts it into an integer,
;and then calls the C function fact()
;It then stores the value in a global variable factNum
factstr:
push ebp
mov ebp, esp

push ebx

;Moves user input from C into ebx register
mov ebx, [ebp+8]

push ebx
call atoi ;Converts ebx into an interger and stores it in eax
pop ebx

;Mov result of atoi() call into ebx
mov ebx, eax

push ebx
call fact ;Calls C fact() function
pop ebx

;Moves result fo fact() function into eax register
mov [factNum], eax

;Pop all used registers
pop ebx
pop ebp
ret

;This function determines if a string is a palindrome
;All user input/ string printing is done in Assembly
;This function calls the C function palindrome(), 
;which actually determines if the string is a palindrome
palindrome_check:
;Prompt printing
mov eax, 4
mov ebx, 1
mov ecx, msg4
mov edx, msg4len
int 0x80

;User input prompt
mov eax, 3
mov ebx, 0
mov ecx, palindromeS
mov edx, 1024
int 0x80

push ecx        ;Pointer to address of first character in string is stored in ecx
call palindrome ;Calls C function
pop ecx

;1 = palindrome, 0 = not a palindrome
cmp eax, 1
je is4

;Not a palindrome print
not4:
mov eax, 4
mov ebx, 1
mov ecx, notp
mov edx, notlen
int 0x80
jmp return4

;Palindrome print
is4:
mov eax, 4
mov ebx, 1
mov ecx, isp
mov edx, islen
int 0x80

;Pop all used registers
return4:
mov esp, ebp
pop ebp
ret