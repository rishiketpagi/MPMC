;ALP to reverse a string 
section .data
    prompt      db  "Enter a string: ", 0
    prompt_len  equ $ - prompt
    result_msg  db  "Reversed string: ", 0
    result_len  equ $ - result_msg
    newline     db  10

section .bss
    buffer      resb    1024
    buflen      equ     1024
    str_len     resd    1

section .text
    global _start

_start:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, prompt
    mov     edx, prompt_len
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, buffer
    mov     edx, buflen
    int     0x80

    dec     eax
    mov     [str_len], eax

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, result_msg
    mov     edx, result_len
    int     0x80

    mov     ecx, [str_len]
    dec     ecx

reverse_loop:
    cmp     ecx, 0
    jl      end_reverse

    mov     eax, 4
    mov     ebx, 1
    lea     edx, [buffer+ecx]
    push    ecx
    mov     ecx, edx
    mov     edx, 1
    int     0x80
    pop     ecx

    dec     ecx
    jmp     reverse_loop

end_reverse:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80

    mov     eax, 1
    xor     ebx, ebx
    int     0x80
