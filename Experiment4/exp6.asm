section .data
    msg1 db "Enter the number: ", 0
    odd db "Number is odd", 0xa
    even db "Number is even", 0xa
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
    mov ebx, 0
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
    num1 resb 4

section .text
    global _start

_start:
    print msg1, 19
    input num1, 4
   
    mov al, [num1]
    sub al, '0'
    mov bl, 2
    div bl

    cmp ah, 0
    je even_num
    jne odd_nums

even_num:
    print even, 17
    jmp exit_prog

odd_nums:
    print odd, 14

exit_prog:
    exit
