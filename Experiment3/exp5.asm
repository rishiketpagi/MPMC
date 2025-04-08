section .data
msg1 db 'Enter num: ' 
l1 equ $-msg1 
msg db 'numbers: ',0Ah 
len equ $-msg 
section .bss 
num RESB 5 
section .text 
global _start:
 
_start: 
mov eax, 4 
mov ebx, 1 
mov ecx, msg1 
mov edx, l1 
int 80h 

mov eax, 3 
mov ebx, 2 
mov ecx, num 
mov edx, 5 
int 80h 

mov eax, 4 
mov ebx, 1 
mov ecx, msg 
mov edx, len 
int 80h
 
mov eax, [num] 
sub eax, '0' 
INC eax 
add eax, '0' 
mov [num],eax 
int 80h 

mov eax, 4 
mov ebx, 1 
mov ecx, num 
mov edx, 2 
int 80h 

mov eax, [num] 
sub eax, '0' 
INC eax 
add eax, '0' 
mov [num],eax 
int 80h 

mov eax, 4 
mov ebx, 1 
mov ecx, num 
mov edx, 2 
int 80h 

mov eax, [num] 
sub eax, '0' 
INC eax 
add eax, '0' 
mov [num],eax 
int 80h 

mov eax, 4 
mov ebx, 1 
mov ecx, num 
mov edx, 2 
int 80h 

mov eax, [num] 
sub eax, '0' 
INC eax 
add eax, '0' 
mov [num],eax 
int 80h 

mov eax, 4 
mov ebx, 1 
mov ecx, num 
mov edx, 2 
int 80h 

mov eax, 1 
mov ebx, 0 
int 80h