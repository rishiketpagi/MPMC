section .data
    msg1 db "Enter first number: ", 0
    msg2 db "Enter second number: ", 0
    msg3 db "Enter third number: ", 0
    msg_greatest db "First number is greatest ", 0xa
    msg_second db "Second number is greatest ", 0xa
    msg_third db "Third number is greatest ", 0xa
    msg_equal db "All numbers are equal ", 0xa
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
    num1 resb 2
    num2 resb 2
    num3 resb 2

section .text
    global _start

_start:
    print msg1, 19
    input num1, 2
    
    print msg2, 20
    input num2, 2
    
    print msg3, 19
    input num3, 2
    
    mov al, [num1]
    sub al, '0'    
    mov bl, [num2]
    sub bl, '0'
    mov cl, [num3]
    sub cl, '0'

    cmp al, bl
    jne check_greatest
    cmp al, cl
    jne check_greatest
    cmp bl, cl
    jne check_greatest
    print msg_equal, 25
    jmp exit_prog

check_greatest:
    cmp al, bl
    jg check_al_cl
    jl check_bl_cl
    cmp al, cl
    jg print_greatest
    jl print_third

check_al_cl:
    cmp al, cl
    jg print_greatest
    jl print_third

check_bl_cl:
    cmp bl, cl
    jg print_second
    jl print_third

print_greatest:
    print msg_greatest, 24
    jmp exit_prog

print_second:
    print msg_second, 25
    jmp exit_prog

print_third:
    print msg_third, 24
    jmp exit_prog

exit_prog:
    exit
