;Implementation of Queue
section .data
    menu_msg db "Menu:", 10
            db "1. Enqueue", 10
            db "2. Dequeue", 10
            db "3. Display Queue", 10
            db "4. Exit", 10
            db "Enter your choice: ", 0
    menu_len equ $ - menu_msg

    enqueue_prompt db "Enter value to enqueue: ", 0
    enqueue_prompt_len equ $ - enqueue_prompt

    enqueue_success db "Value enqueued successfully.", 10, 0
    enqueue_success_len equ $ - enqueue_success

    queue_full db "Queue is full! Cannot enqueue.", 10, 0
    queue_full_len equ $ - queue_full

    dequeue_success db "Dequeued value: ", 0
    dequeue_success_len equ $ - dequeue_success

    queue_empty db "Queue is empty! Cannot dequeue.", 10, 0
    queue_empty_len equ $ - queue_empty

    display_empty db "Queue is empty! Nothing to display.", 10, 0
    display_empty_len equ $ - display_empty

    display_header db "Queue elements: ", 0
    display_header_len equ $ - display_header

    newline db 10, 0
    space db " ", 0

    invalid_choice db "Invalid choice! Please try again.", 10, 0
    invalid_choice_len equ $ - invalid_choice

    exit_msg db "Exiting program...", 10, 0
    exit_msg_len equ $ - exit_msg

    QUEUE_SIZE equ 9
    queue times QUEUE_SIZE dd 0
    front dd 0
    rear dd -1
    count dd 0

section .bss
    choice resb 4
    input_buffer resb 16
    output_buffer resb 16

section .text
    global _start

_start:
menu_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, menu_msg
    mov edx, menu_len
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 4
    int 80h

    mov al, [choice]
    sub al, '0'

    cmp al, 1
    je enqueue_operation

    cmp al, 2
    je dequeue_operation

    cmp al, 3
    je display_operation

    cmp al, 4
    je exit_program

    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_choice
    mov edx, invalid_choice_len
    int 80h
    jmp menu_loop

enqueue_operation:
    mov eax, [count]
    cmp eax, QUEUE_SIZE
    jl enqueue_space_available

    mov eax, 4
    mov ebx, 1
    mov ecx, queue_full
    mov edx, queue_full_len
    int 80h
    jmp menu_loop

enqueue_space_available:
    mov eax, 4
    mov ebx, 1
    mov ecx, enqueue_prompt
    mov edx, enqueue_prompt_len
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 16
    int 80h

    call atoi

    mov ebx, [rear]
    inc ebx
    cmp ebx, QUEUE_SIZE
    jl rear_in_bounds
    xor ebx, ebx

rear_in_bounds:
    mov [rear], ebx
    mov ebx, [rear]
    mov [queue + ebx*4], eax

    mov eax, [count]
    inc eax
    mov [count], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, enqueue_success
    mov edx, enqueue_success_len
    int 80h
    jmp menu_loop

dequeue_operation:
    mov eax, [count]
    cmp eax, 0
    jg dequeue_value_available

    mov eax, 4
    mov ebx, 1
    mov ecx, queue_empty
    mov edx, queue_empty_len
    int 80h
    jmp menu_loop

dequeue_value_available:
    mov ebx, [front]
    mov eax, [queue + ebx*4]

    push eax

    mov eax, 4
    mov ebx, 1
    mov ecx, dequeue_success
    mov edx, dequeue_success_len
    int 80h

    pop eax
    call itoa
    mov eax, 4
    mov ebx, 1
    mov ecx, output_buffer
    mov edx, eax
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    mov ebx, [front]
    inc ebx
    cmp ebx, QUEUE_SIZE
    jl front_in_bounds
    xor ebx, ebx

front_in_bounds:
    mov [front], ebx

    mov eax, [count]
    dec eax
    mov [count], eax
    jmp menu_loop

display_operation:
    mov eax, [count]
    cmp eax, 0
    jg display_values

    mov eax, 4
    mov ebx, 1
    mov ecx, display_empty
    mov edx, display_empty_len
    int 80h
    jmp menu_loop

display_values:
    mov eax, 4
    mov ebx, 1
    mov ecx, display_header
    mov edx, display_header_len
    int 80h

    mov ecx, 0
    mov edx, [front]

display_loop:
    cmp ecx, [count]
    jge display_done

    mov eax, [queue + edx*4]

    push ecx
    push edx

    call itoa
    push eax

    mov eax, 4
    mov ebx, 1
    mov ecx, output_buffer
    pop edx
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h

    pop edx
    pop ecx

    inc edx
    cmp edx, QUEUE_SIZE
    jl display_index_in_bounds
    xor edx, edx

display_index_in_bounds:
    inc ecx
    jmp display_loop

display_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    jmp menu_loop

exit_program:
    mov eax, 4
    mov ebx, 1
    mov ecx, exit_msg
    mov edx, exit_msg_len
    int 80h

    mov eax, 1
    xor ebx, ebx
    int 80h

atoi:
    xor eax, eax
    xor ecx, ecx

atoi_loop:
    movzx ebx, byte [input_buffer + ecx]
    cmp bl, 0
    je atoi_done
    cmp bl, 10
    je atoi_done
    cmp bl, 13
    je atoi_done
    cmp bl, '0'
    jl atoi_done
    cmp bl, '9'
    jg atoi_done
    imul eax, 10
    sub bl, '0'
    add eax, ebx
    inc ecx
    jmp atoi_loop

atoi_done:
    ret

itoa:
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ecx, 10
    mov edi, output_buffer
    add edi, 15
    mov byte [edi], 0
    dec edi

    test eax, eax
    jnz itoa_loop
    mov byte [edi], '0'
    dec edi
    jmp itoa_done

itoa_loop:
    test eax, eax
    jz itoa_done

    xor edx, edx
    div ecx

    add dl, '0'
    mov [edi], dl
    dec edi

    jmp itoa_loop

itoa_done:
    inc edi
    mov eax, output_buffer
    add eax, 15
    sub eax, edi

    mov esi, edi
    mov edi, output_buffer
    mov ecx, eax
    rep movsb

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
