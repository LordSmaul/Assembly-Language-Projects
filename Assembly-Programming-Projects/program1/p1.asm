BITS 32

;System macros
sys_write EQU 4
sys_read EQU 3
sys_exit EQU 1
stdin EQU 0
stdout EQU 1

SECTION .text
   GLOBAL _start

_start:
   ;Prints introduction
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, intro
   mov edx, introlen
   int 0x80

   ;Print first message for user input
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, msg1
   mov edx, msg1len
   int 0x80

   ;Read and store user input for num1
   mov eax, sys_read
   mov ebx, stdin
   mov ecx, num1
   mov edx, 2
   int 0x80

   ;Print second message for user input
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, msg1
   mov edx, msg1len
   int 0x80

   ;Read and store user input for num2
   mov eax, sys_read
   mov ebx, stdin
   mov ecx, num2
   mov edx, 2
   int 0x80

   mov AL, [num1] ;move num1 into AL registery
   sub AL, '0' ;converts num1 to an integer
   mov AH, [num2] ;moves num2 into AH registery
   sub AH, '0' ;converts num2 to an integer
   add AL, AH ;adds AL and AH registers
   add AL, '0' ;converts AL register back to a string for printing
   mov [result], AL ;moves AL register into result variable

   ;Print answer message
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, answermsg
   mov edx, anslen
   int 0x80

   ;Print answer
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, result
   mov edx, 1
   int 0x80

   ;newline
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, newline
   mov edx, newlen
   int 0x80

   ;Exit system
   mov eax, sys_exit
   mov ebx, 0
   int 0x80

SECTION .data  ;Initialized data
   intro DB 'The Adding Program', 0xA
   introlen EQU $- intro
   msg1 DB 'Please enter a single digit number: '
   msg1len EQU $- msg1
   answermsg DB 'The answer is: '
   anslen EQU $- answermsg
   newline DB 0xA
   newlen EQU $- newline
SECTION .bss   ;Uninitialized data
   num1 RESB 2
   num2 RESB 2
   result RESB 2
