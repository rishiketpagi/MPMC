section .data
    menu db 10,"1. Push",10,"2. Pop",10,"3. Display",10,"4. Exit",10,"Choice: ",0
    prompt db "Enter value (0-9): ",0
    msg_push db "Value pushed.",10,0
    msg_pop db "Popped value: ",0
    msg_empty db "Stack is empty.",10,0
    msg_full db "Stack is full.",10,0
    newline db 10,0

section .bss
    stack resb 10
    top resb 1
    input resb 2
    temp resb 1

section .text
    global _start

_start:
main_menu:
    ; Show menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, menu_len
    int 0x80

    ; Read user choice
    call read_char
    cmp al, '1'
    je push_value
    cmp al, '2'
    je pop_value
    cmp al, '3'
    je display_stack
    cmp al, '4'
    je exit
    jmp main_menu

; -------------------------------------
push_value:
    ; Check if full
    movzx ecx, byte [top]
    cmp ecx, 10
    jae .full

    ; Prompt for input
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    call read_char
    sub al, '0'
    movzx ecx, byte [top]
    mov [stack + ecx], al
    inc byte [top]

    ; Print success
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_push
    mov edx, msg_push_len
    int 0x80
    jmp main_menu

.full:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_full
    mov edx, msg_full_len
    int 0x80
    jmp main_menu

; -------------------------------------
pop_value:
    movzx ecx, byte [top]
    cmp ecx, 0
    je .empty
    dec byte [top]
    movzx ecx, byte [top]
    mov al, [stack + ecx]
    add al, '0'
    mov [temp], al

    ; Show message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_pop
    mov edx, msg_pop_len
    int 0x80

    ; Print value
    mov eax, 4
    mov ebx, 1
    mov ecx, temp
    mov edx, 1
    int 0x80

    ; Newline
    call newline
    jmp main_menu

.empty:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_empty
    mov edx, msg_empty_len
    int 0x80
    jmp main_menu

; -------------------------------------
display_stack:
    movzx ecx, byte [top]
    cmp ecx, 0
    je .empty

.display_loop:
    dec ecx
    mov al, [stack + ecx]
    add al, '0'
    mov [temp], al
    mov eax, 4
    mov ebx, 1
    mov ecx, temp
    mov edx, 1
    int 0x80
    call newline
    cmp ecx, 0
    jne .display_loop

    jmp main_menu

; -------------------------------------
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; -------------------------------------
read_char:
    ; Reads 1 character into AL
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 1
    int 0x80
    mov al, [input]
    ret

newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

; -------------------------------------
; Lengths of messages
menu_len       equ $ - menu
prompt_len     equ $ - prompt
msg_push_len   equ $ - msg_push
msg_pop_len    equ $ - msg_pop
msg_empty_len  equ $ - msg_empty
msg_full_len   equ $ - msg_full
