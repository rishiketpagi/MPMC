section .data
    msg1 db "Enter first number:", 0
    msg2 db "Enter second number:", 0
    greater db "First number is greater", 0xa
    lesser db "Second number is greater", 0xa
    equal db "Both numbers are equal", 0xa
    nl db 10
%macro print 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro input 2
    mov eax, 3
    mov ebx, 2
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro exit 0
    mov eax, 1
    mov ebx, 0
    int 0x80
%endmacro

section .bss
    num1 resb 2
    num2 resb 2

section .text
    global _start

_start:
    print msg1, 19
    input num1, 2
    
    print msg2, 20
    input num2, 2
    
    mov al, [num1]
    mov bl, [num2]
    sub al, '0'    
    sub bl, '0'
    
    cmp al, bl
    je equal_nums
    jg greater_num
    jl lesser_num

equal_nums:
    print equal, 25
    jmp exit_prog

greater_num:
    print greater, 24
    jmp exit_prog

lesser_num:
    print lesser, 25
    
 mov eax,4
 mov ebx,1
 mov ecx,nl
 mov edx,1
int 0x80

exit_prog:
    exit

