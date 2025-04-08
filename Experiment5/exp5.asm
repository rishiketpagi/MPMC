section .data
    string1 db "Enter size of fibonacci series: ", 10
    string1len equ $-string1
    string2 db "The series is: ", 10
    string2len equ $-string2
    newline db 10
    nl equ $-newline

section .bss
    num resb 5
    a resb 5
    b resb 5
    c resb 5
    inter resb 5
    count resb 5

%macro write 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro read 1
    mov eax, 3
    mov ebx, 2
    mov ecx, %1
    mov edx, 5
    int 80h
%endmacro

%macro addition 3
    movzx eax, byte [%1]
    sub eax, '0'       ; Convert from ASCII to integer
    movzx ebx, byte [%2]
    sub ebx, '0'       ; Convert from ASCII to integer
    add eax, ebx
    add eax, '0'       ; Convert back to ASCII
    mov byte [%3], al  ; Store result in destination
%endmacro

section .text
    global _start
_start:
    ; Prompt user to enter the size of Fibonacci series
    write string1, string1len
    read num              ; Read the number from user input
    write string2, string2len

    ; Convert the input number from ASCII to integer
    movzx eax, byte [num]
    sub eax, '0'
    mov [num], al         ; Store the integer value of 'num'

    ; Check if n = 0, no output needed
    mov al, [num]
    cmp al, 0
    je exit

    ; Handle case when n = 1, output just the first number (0)
    mov al, [num]
    cmp al, 1
    je print_fib_0

    ; Initialize Fibonacci sequence
    mov byte [a], '0'     ; a = 0
    write a, 5             ; Output 0
    write newline, nl

    mov byte [b], '1'     ; b = 1
    write b, 5             ; Output 1
    write newline, nl

    ; If n > 2, continue Fibonacci sequence
    mov byte [count], 2    ; Start from the 3rd term
    mov al, [num]
    cmp al, 2
    je exit

L1:  ; Loop to compute next Fibonacci numbers
    addition a, b, c
    write c, 5             ; Output the result of addition
    write newline, nl

    mov al, [b]
    mov [a], al           ; Update a = b
    mov al, [c]
    mov [b], al           ; Update b = c

    inc byte [count]      ; Increment the count
    mov al, [count]
    mov bl, [num]
    cmp al, bl
    jl L1

exit:
    mov eax, 1            ; Exit the program
    mov ebx, 0
    int 80h

print_fib_0:
    mov byte [a], '0'     ; For n = 1, just print 0
    write a, 5
    write newline, nl
    mov eax, 1            ; Exit the program
    mov ebx, 0
    int 80h
