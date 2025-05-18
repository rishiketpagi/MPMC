; ALP: Write an Assembly Language Program to read/input a string
; and display the input using function or subroutine.

section .data
    prompt_msg db "Enter a string: ", 0
    prompt_len equ $ - prompt_msg

    output_msg db "Entered string is : ", 0
    output_len equ $ - output_msg

    newline db 10, 0

section .bss
    input_buffer resb 256
    input_len resd 1

section .text
    global _start

_start:
    call read_string
    call display_string

    mov eax, 1
    xor ebx, ebx
    int 80h

read_string:
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 255
    int 80h

    mov [input_len], eax

    pop edx
    pop ecx
    pop ebx
    ret

display_string:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, output_msg
    mov edx, output_len
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, input_buffer
    mov edx, [input_len]
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
