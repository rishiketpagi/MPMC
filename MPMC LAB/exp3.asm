;Implementation of stack
section .data
    menu_msg db 10, "Menu:", 10
            db "1. Push element", 10
            db "2. Pop element", 10
            db "3. peek", 10
            db "4. display stack", 10
            db "5. exit", 10
            db "Enter your choice: ", 0
    menu_len equ $ - menu_msg

    push_msg db 10, "Enter element to push: ", 0
    push_len equ $ - push_msg

    pop_msg db 10, "Popped element: ", 0
    pop_len equ $ - pop_msg

    top_msg db 10, "Stack top element: ", 0
    top_len equ $ - top_msg

    stack_empty_msg db 10, "Stack is empty!", 10, 0
    empty_len equ $ - stack_empty_msg

    stack_full_msg db 10, "Stack overflow!", 10, 0
    full_len equ $ - stack_full_msg

    display_msg db 10, "Stack contents (top to bottom): ", 0
    display_len equ $ - display_msg

    newline db 10
    space db " "

section .bss
    stack_array resw 9
    stack_top resw 1
    choice resb 2
    input_buffer resb 20
    output_buffer resb 20

section .text
    global _start

_start:
    mov word [stack_top], -1

menu_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, menu_msg
    mov edx, menu_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 2
    int 0x80

    mov al, [choice]
    sub al, '0'

    cmp al, 1
    je push_element

    cmp al, 2
    je pop_element

    cmp al, 3
    je display_top

    cmp al, 4
    je display_stack

    cmp al, 5
    je exit_program

    jmp menu_loop

push_element:
    mov ax, [stack_top]
    cmp ax, 8
    jl push_ok

    mov eax, 4
    mov ebx, 1
    mov ecx, stack_full_msg
    mov edx, full_len
    int 0x80
    jmp menu_loop

push_ok:
    mov eax, 4
    mov ebx, 1
    mov ecx, push_msg
    mov edx, push_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 10
    int 0x80

    mov eax, 0
    mov ecx, 0

convert_loop:
    mov bl, byte [input_buffer + ecx]
    cmp bl, 10
    je convert_done
    cmp bl, 0
    je convert_done

    sub bl, '0'
    imul eax, 10
    add eax, ebx

    inc ecx
    jmp convert_loop

convert_done:
    inc word [stack_top]
    movzx ebx, word [stack_top]
    mov [stack_array + ebx*2], ax
    jmp display_stack

pop_element:
    mov ax, [stack_top]
    cmp ax, -1
    jg pop_ok

    mov eax, 4
    mov ebx, 1
    mov ecx, stack_empty_msg
    mov edx, empty_len
    int 0x80
    jmp menu_loop

pop_ok:
    mov eax, 4
    mov ebx, 1
    mov ecx, pop_msg
    mov edx, pop_len
    int 0x80

    movzx ebx, word [stack_top]
    movzx eax, word [stack_array + ebx*2]

    mov ecx, output_buffer
    add ecx, 19
    mov byte [ecx], 0

    mov ebx, 10

convert_to_string:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz convert_to_string

    mov eax, 4
    mov ebx, 1
    mov edx, output_buffer
    add edx, 19
    sub edx, ecx
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    dec word [stack_top]
    jmp display_stack

display_top:
    mov ax, [stack_top]
    cmp ax, -1
    jg display_top_ok

    mov eax, 4
    mov ebx, 1
    mov ecx, stack_empty_msg
    mov edx, empty_len
    int 0x80
    jmp menu_loop

display_top_ok:
    mov eax, 4
    mov ebx, 1
    mov ecx, top_msg
    mov edx, top_len
    int 0x80

    movzx ebx, word [stack_top]
    movzx eax, word [stack_array + ebx*2]

    mov ecx, output_buffer
    add ecx, 19
    mov byte [ecx], 0

    mov ebx, 10

convert_top_to_string:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz convert_top_to_string

    mov eax, 4
    mov ebx, 1
    mov edx, output_buffer
    add edx, 19
    sub edx, ecx
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp menu_loop

display_stack:
    mov eax, 4
    mov ebx, 1
    mov ecx, display_msg
    mov edx, display_len
    int 0x80

    movsx eax, word [stack_top]
    cmp eax, -1
    jle stack_display_empty

    mov edi, eax

display_loop:
    cmp edi, -1
    jle display_done

    movzx eax, word [stack_array + edi*2]
    push edi

    mov ecx, output_buffer
    add ecx, 19
    mov byte [ecx], 0

    mov ebx, 10

convert_element_to_string:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz convert_element_to_string

    mov eax, 4
    mov ebx, 1
    mov edx, output_buffer
    add edx, 19
    sub edx, ecx
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    pop edi
    dec edi
    jmp display_loop

display_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp menu_loop

stack_display_empty:
    mov eax, 4
    mov ebx, 1
    mov ecx, stack_empty_msg
    mov edx, empty_len
    int 0x80
    jmp menu_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
