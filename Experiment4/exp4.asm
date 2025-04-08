section .data
    msg db " Enter the number :", 0
    mlen equ ($ - msg)
    greater db "Number is greater than 5 ", 0xa
    glen equ ($ - greater)
    lesser db "Number is lesser than 5 ", 0xa
    llen equ ($ - lesser)
    equal db "Number is equal to 5 ", 0xa
    elen equ ($ - equal)
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
    print msg, mlen
    input num1, 2
   
    mov al, [num1]
    sub al, '0'    

    
    cmp al, 5
    je equal_nums
    jg greater_num
    jl lesser_num

equal_nums:
    print equal, elen
    jmp exit_prog

greater_num:
    print greater, glen
    jmp exit_prog

lesser_num:
    print lesser, llen

 mov eax,4
 mov ebx,1
 mov ecx,nl
 mov edx,1
int 0x80
    
exit_prog:
    exit
