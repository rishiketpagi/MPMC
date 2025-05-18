section .data
    msg1        db "Enter the size of array : "
    msg1len     equ $ - msg1
    msg2        db "Enter the elements in the array: "
    msg2len     equ $ - msg2
    msg3        db "The sorted array is: "
    msg3len     equ $ - msg3
    menu_msg    db "Sorting order:", 10, "1. Ascending", 10, "2. Descending", 10, "Enter choice : "
    menu_len    equ $ - menu_msg
    msg4        db "Pass "
    msg4len     equ $ - msg4
    msg5        db ": "
    msg5len     equ $ - msg5
    asc_msg     db "Sorting in ascending order...", 10
    asc_len     equ $ - asc_msg
    desc_msg    db "Sorting in descending order...", 10
    desc_len    equ $ - desc_msg
    newline     db 10
    space       db ' '

section .bss
    arr         resb 50
    size        resb 1
    i           resb 1
    pass_num    resb 1
    temp        resb 1
    buffer      resb 2
    sort_order  resb 1

section .text
global _start

%macro write 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro readchar 1
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 2
    int 80h
    mov al, byte [buffer]
    mov [%1], al
%endmacro

_start:
    write msg1, msg1len
    readchar size
    sub byte [size], '0'

    write msg2, msg2len
    mov byte [i], 0

input_loop:
    mov al, [i]
    cmp al, [size]
    jge input_done
    movzx esi, byte [i]
    readchar arr+esi
    sub byte [arr+esi], '0'
    inc byte [i]
    jmp input_loop

input_done:
    write menu_msg, menu_len
    readchar sort_order
    sub byte [sort_order], '0'

    cmp byte [sort_order], 1
    jne check_descending
    write asc_msg, asc_len
    jmp continue_program

check_descending:
    cmp byte [sort_order], 2
    jne continue_program
    write desc_msg, desc_len

continue_program:
    call bubble_sort
    write newline, 1
    write msg3, msg3len
    call display

    mov eax, 1
    mov ebx, 0
    int 80h

display:
    mov byte [i], 0

display_loop:
    mov al, [i]
    cmp al, [size]
    jge display_done
    movzx esi, byte [i]
    add byte [arr+esi], '0'
    lea ecx, [arr+esi]
    write ecx, 1
    sub byte [arr+esi], '0'
    write space, 1
    inc byte [i]
    jmp display_loop

display_done:
    write newline, 1
    ret

bubble_sort:
    mov byte [pass_num], '1'
    mov al, 0

outer_loop:
    movzx ecx, byte [size]
    dec ecx
    cmp al, cl
    jge sort_end

    pushad
    write msg4, msg4len
    mov cl, [pass_num]
    mov [temp], cl
    write temp, 1
    write msg5, msg5len
    call display
    popad

    mov cl, 0

inner_loop:
    movzx edx, byte [size]
    dec edx
    sub dl, al
    cmp cl, dl
    jge inner_loop_end

    movzx esi, cl
    mov bl, [arr + esi]
    mov bh, [arr + esi + 1]

    cmp byte [sort_order], 2
    je descending_compare

    cmp bl, bh
    jle no_swap
    jmp do_swap

descending_compare:
    cmp bl, bh
    jge no_swap

do_swap:
    mov [arr + esi], bh
    mov [arr + esi + 1], bl

no_swap:
    inc cl
    jmp inner_loop

inner_loop_end:
    inc al
    inc byte [pass_num]
    jmp outer_loop

sort_end:
    write msg4, msg4len
    mov cl, [pass_num]
    mov [temp], cl
    write temp, 1
    write msg5, msg5len
    call display
    ret
