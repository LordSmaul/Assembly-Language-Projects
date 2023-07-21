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
   ;Print introduction
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, intro
   mov edx, introlen
   int 0x80

   ;Print message for user input
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, msg1
   mov edx, msg1len
   int 0x80

   ;Read and store input for string
   mov eax, sys_read
   mov ebx, stdin
   mov ecx, string
   mov edx, 2
   int 0x80

   ;Swap character values in memory
   mov AL, [string]
   mov BL, [string + 1]
   mov [string + 1], AL
   mov [string], BL

   ;Print answer message
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, answer
   mov edx, anslen
   int 0x80

   ;Print answer
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, string
   mov edx, 2
   int 0x80

   ;newline
   mov eax, sys_write
   mov ebx, stdout
   mov ecx, newline
   mov edx, newlen
   int 0x80

   ;Exit system
   mov eax, sys_exit
   int 0x80

SECTION .data  ;Initialized data
   intro DB 'The Swapping Program', 0xA
   introlen EQU $- intro
   msg1 DB 'Please enter a two character string: '
   msg1len EQU $- msg1
   answer DB 'The answer is: '
   anslen EQU $- answer
   newline DB 0xA
   newlen EQU $- newline
SECTION .bss   ;Uninitialized data
   string RESB 3
