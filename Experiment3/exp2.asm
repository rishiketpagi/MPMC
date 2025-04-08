section .data 
prompt1 db "Enter first number: ", 0 
prompt2 db "Enter second number: ", 0 
add_msg db "Addition result: ", 0 
sub_msg db "Subtraction result: ", 0 
div_msg db "Division result: ", 0 
rem_msg db "Remainder: ", 0 
newline db 0xA, 0 

section .bss 
num1 resb 10 
num2 resb 10 
result resb 4 
remainder resb 4 

section .text 
global _start 

_start: 
mov eax, 4 
mov ebx, 1 
lea ecx, [prompt1] 
mov edx, 20 
int 0x80 

mov eax, 3 
mov ebx, 0 
lea ecx, [num1] 
mov edx, 10 
int 0x80 

mov eax, [num1] 
sub eax, '0' 
mov [result], eax 
mov eax, 4 
mov ebx, 1 
lea ecx, [prompt2] 
mov edx, 21 
int 0x80 

mov eax, 3 
mov ebx, 0 
lea ecx, [num2] 
mov edx, 10 
int 0x80 

; Perform addition 
mov eax, [num2] 
sub eax, '0' 
add [result], eax 
mov al, [result] 
add al, '0' 
mov [result], al 
mov eax, 4 
mov ebx, 1 
lea ecx, [add_msg] 
mov edx, 17 
int 0x80 

mov eax, 4 
mov ebx, 1 
lea ecx, [result] 
mov edx, 1 
int 0x80 

mov eax, 4 
mov ebx, 1 
lea ecx, [newline] 
mov edx, 1 
int 0x80 

mov al, [result] 
sub al, '0' 
mov [result], al 
mov eax, [num2] 
sub eax, '0' 
sub [result], eax 
sub [result], eax 
mov al, [result] 
add al, '0' 
mov [result], al 
mov eax, 4 
mov ebx, 1 
lea ecx, [sub_msg] 
mov edx, 21 
int 0x80 

mov eax, 4 
mov ebx, 1 
lea ecx, [result] 
mov edx, 1 
int 0x80 

mov eax, 4 
mov ebx, 1 
lea ecx, [newline] 
mov edx, 1 
int 0x80 

mov al, [num1] 
sub al, '0' 
mov ah, 0 
mov bl, [num2] 
sub bl, '0' 
div bl 
add al, '0' 
mov [result], al 
mov eax, 4 
mov ebx, 1 
lea ecx, [div_msg] 
mov edx, 17 
int 0x80
 
mov eax, 4 
mov ebx, 1 
lea ecx, [result] 
mov edx, 1 
int 0x80 

mov eax, 4 
mov ebx, 1 
lea ecx, [newline] 
mov edx, 1 
int 0x80 

mov al, ah 
add al, '0' 
mov [remainder], al 
mov eax, 4 
mov ebx, 1 
lea ecx, [rem_msg] 
mov edx, 10 
int 0x80 

mov eax, 4 
mov ebx, 1 
lea ecx, [remainder] 
mov edx, 1 
int 0x80 

mov eax, 4 
mov ebx, 1 
lea ecx, [newline] 
mov edx, 1 
int 0x80 

mov eax, 1 
xor ebx, ebx 
int 0x80
