section .data 
    prompt db "Enter a number: ", 0 
    result_msg db "The sum is: ", 0 
    newline db 0xA, 0 
 
section .bss 
    num1 resb 4 
    num2 resb 4 
    sum resb 4 
 
section .text 
    global _start 
 
_start: 
    mov eax, 4 
    mov ebx, 1 
    lea ecx, [prompt] 
    mov edx, 17 
    int 0x80 
 
    mov eax, 3 
    mov ebx, 0 
    lea ecx, [num1] 
    mov edx, 4 
    int 0x80 
 
    mov eax, [num1] 
    sub eax, '0' 
    mov [sum], eax 
 
    mov eax, 4 
    mov ebx, 1 
    lea ecx, [prompt] 
    mov edx, 17 
    int 0x80 
 
    mov eax, 3 
    mov ebx, 0 
    lea ecx, [num2] 
    mov edx, 4 
    int 0x80 
 
    mov eax, [num2] 
    sub eax, '0' 
    add [sum], eax 
 
    mov eax, 4 
    mov ebx, 1 
    lea ecx, [result_msg] 
    mov edx, 12 
    int 0x80 
 
    mov al, [sum] 
    add al, '0' 
    mov [sum], al 
 
    mov eax, 4 
    mov ebx, 1 
    lea ecx, [sum] 
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