BITS 32

GLOBAL _start

SECTION .data   ;Initialized data
prompt DB "Please enter a string:", 0xA
promptlen EQU $- prompt
ispal DB "It is a palindrome", 0xA
islen EQU $- ispal
notpal DB "It is NOT a palindrome", 0xA
notlen EQU $- notpal

SECTION .bss    ;Uninitialized data
input RESB 1024

SECTION .text

_start:
;Prints introductory prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, promptlen
int 0x80

;Takes user input
mov eax, 3
mov ebx, 0
mov ecx, input
mov edx, 1024
int 0x80

;Main loop where user inputs strings until they enter nothing
_mainloop:
;Compares user input to the newline character
;Jumps to exit if they entered nothing 
;(i.e, they pressed "Enter" without entering anything)
cmp BYTE[ecx], 0xA
je _exit

sub eax, 2     ;Used to get end address of input string
mov esi, input ;Moves input into esi register 
mov edi, input ;Moves input into edi register - used to get end address
mov ecx, eax   ;Used to determine palindrome by character length
add edi, eax   ;Moves end address of user input into edi register

push esi        ;Pushes esi to program stack
push edi        ;Pushes esi to program stack
call palindrome ;Calls palindrome subroutine

;Compares eax register to 0; if they equal, the string was not a palindrome
cmp eax, 0
je _not

;Prints if string is a palindrome
_is:
mov eax, 4
mov ebx, 1
mov ecx, ispal
mov edx, islen
int 0x80
jmp _printprompt ;Jumps to prompt within the loop

;Prints if string is not a palindrome
_not:
mov eax, 4
mov ebx, 1
mov ecx, notpal
mov edx, notlen
int 0x80

; Prompt printing/getting user input within loop
_printprompt:
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, promptlen
int 0x80

mov eax, 3
mov ebx, 0
mov ecx, input
mov edx, 1024
int 0x80
jmp _mainloop

_exit:
mov eax, 1
int 0x80

;Palindrome subroutine
palindrome:
push ebp
mov ebp, esp

mov edx, [ebp+12]
mov ebx, [ebp+8]

_loop:
cmp ecx, 0
je _ispalindrome
mov BYTE al, [ebx]
mov BYTE ah, [edx]
cmp al, ah
jne _notpalindrome

inc edx
dec ebx
dec ecx
jmp _loop

_ispalindrome:
mov eax, 1
jmp _return

_notpalindrome:
mov eax, 0

_return:
leave
ret
