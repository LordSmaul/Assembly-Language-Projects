BITS 32

GLOBAL _start

SECTION .data
prompt DB "Enter a string less than 1023 characters: "
len EQU $- prompt

SECTION .bss
string RESB 1024
reverse RESB 1024

SECTION .text
_start:

   mov eax, 4
   mov ebx, 1
   mov ecx, prompt
   mov edx, len
   int 0x80

   mov eax, 3
   mov ebx, 0
   mov ecx, string
   mov edx, 1024
   int 0x80

   mov esi, string
   xor ecx, ecx

string_step:
   cmp BYTE [esi], 0
   jz reverse
   inc ecx
   inc esi
   jmp string_step

reverse:
   dec ecx
   mov edx, ecx
   jecxz print

   mov edi, reverse
   dec esi
   dec esi

copy_loop:
   mov al, [esi]
   mov [edi], al
   dec esi
   inc edi
   loop copy_loop

print:
   mov BYTE [edi], 10
   inc edx
   mov BYTE [edi+1], 0

   mov eax, 4
   mov ebx, 1
   mov ecx, reverse
   int 0x80

   mov eax, 1
   int 0x80

