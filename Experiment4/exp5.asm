section .data
    msg1 db "Enter first string: ", 0
    msg2 db "Enter second string: ", 0
    equal_msg db "Strings are equal", 0xa
    not_equal_msg db "Strings are not equal", 0xa
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
    str1 resb 50
    str2 resb 50

section .text
    global _start

_start:
    print msg1, 21
    input str1, 50
    
    print msg2, 21
    input str2, 50

compare_strings:
    mov esi, str1
    mov edi, str2
    mov ecx, 50

compare_loop:
    mov al, [esi]
    mov bl, [edi]
    
    cmp al, bl
    jne not_equal
    
    cmp al, 0
    je equal
    
    inc esi
    inc edi
    loop compare_loop

equal:
    print equal_msg, 17
    jmp exit_prog

not_equal:
    print not_equal_msg, 21
    jmp exit_prog

exit_prog:
    exit
