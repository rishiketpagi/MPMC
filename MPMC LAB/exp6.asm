;ALP to sort array of characters
section .data
    msg1 db "Enter the size of array : "
    msg1len equ $-msg1

    msg2 db "Enter the characters in the array: "
    msg2len equ $-msg2

    menu_msg db "Choose sorting method:", 10, "1. Bubble Sort", 10, "2. Selection Sort", 10, "3. Insertion Sort", 10, "Enter choice :"
    menu_len equ $-menu_msg

    msg3 db "The sorted array is: "
    msg3len equ $-msg3

    msg4 db "Pass "
    msg4len equ $-msg4

    msg5 db ": "
    msg5len equ $-msg5

    newline db 10
    space db ' '

section .bss
    arr resb 50
    size resb 1
    i resb 1
    pass_num resb 1
    temp resb 1
    buffer resb 2
    sort_order resb 1

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
    ; Ask for array size first
    write msg1, msg1len
    readchar size
    sub byte [size], '0'       ; Convert ASCII to number

    ; Ask for array elements
    write msg2, msg2len
    mov byte [i], 0

input_loop:
    mov al, [i]
    cmp al, [size]
    jge input_done
    movzx esi, byte [i]
    readchar arr+esi
    inc byte [i]
    jmp input_loop

input_done:
    ; Ask for sorting method
    write menu_msg, menu_len
    readchar sort_order
    sub byte [sort_order], '0'

    cmp byte [sort_order], 1
    je bubble_sort_call
    cmp byte [sort_order], 2
    je selection_sort_call
    cmp byte [sort_order], 3
    je insertion_sort_call

    ; If invalid input, just exit
    mov eax, 1
    mov ebx, 0
    int 80h

bubble_sort_call:
    call bubble_sort
    jmp display_result

selection_sort_call:
    call selection_sort
    jmp display_result

insertion_sort_call:
    call insertion_sort
    jmp display_result

display_result:
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
    lea ecx, [arr+esi]
    write ecx, 1
    write space, 1
    inc byte [i]
    jmp display_loop
display_done:
    write newline, 1
    ret

bubble_sort:
    mov byte [pass_num], '1'
    mov al, 0

bubble_outer:
    movzx ecx, byte [size]
    dec ecx
    cmp al, cl
    jge bubble_end

    pushad
    write msg4, msg4len
    mov cl, [pass_num]
    mov [temp], cl
    write temp, 1
    write msg5, msg5len
    call display
    popad

    mov cl, 0

bubble_inner:
    movzx edx, byte [size]
    dec edx
    sub dl, al
    cmp cl, dl
    jge bubble_inner_end

    movzx esi, cl
    mov bl, [arr + esi]
    mov bh, [arr + esi + 1]

    cmp bl, bh
    jle bubble_no_swap

    ; swap arr[cl] and arr[cl+1]
    mov [arr + esi], bh
    mov [arr + esi + 1], bl

bubble_no_swap:
    inc cl
    jmp bubble_inner

bubble_inner_end:
    inc al
    inc byte [pass_num]
    jmp bubble_outer

bubble_end:
    ret

selection_sort:
    mov byte [pass_num], '1'
    mov al, 0

sel_outer:
    movzx ecx, byte [size]
    dec ecx
    cmp al, cl
    jge sel_end

    pushad
    write msg4, msg4len
    mov cl, [pass_num]
    mov [temp], cl
    write temp, 1
    write msg5, msg5len
    call display
    popad

    mov bl, al            ; min_index = al
    mov cl, al
    inc cl                ; j = al + 1

sel_inner:
    movzx edx, byte [size]
    cmp cl, dl
    jge sel_inner_end

    movzx esi, cl
    mov dl, [arr + esi]
    movzx edi, bl
    mov dh, [arr + edi]

    cmp dl, dh
    jge sel_no_update
    mov bl, cl           ; min_index = j

sel_no_update:
    inc cl
    jmp sel_inner

sel_inner_end:
    cmp bl, al
    je sel_no_swap

    ; swap arr[al] and arr[min_index]
    movzx esi, al
    mov dl, [arr + esi]
    movzx edi, bl
    mov dh, [arr + edi]

    movzx esi, al
    mov [arr + esi], dh
    movzx edi, bl
    mov [arr + edi], dl

sel_no_swap:
    inc al
    inc byte [pass_num]
    jmp sel_outer

sel_end:
    ret

insertion_sort:
    mov byte [pass_num], '1'
    mov cl, 1

ins_outer:
    movzx edx, byte [size]
    cmp cl, dl
    jge ins_end

    movzx esi, cl
    mov bl, [arr + esi]   ; key = arr[cl]
    mov al, cl
    dec al                ; j = cl - 1

ins_inner:
    cmp al, 255           ; unsigned underflow check (al >= 0)
    jl ins_inner_end

    movzx edi, al
    mov dl, [arr + edi]

    cmp dl, bl
    jle ins_inner_end

    movzx esi, al
    inc esi
    mov [arr + esi], dl   ; arr[j+1] = arr[j]
    dec al
    jmp ins_inner

ins_inner_end:
    movzx esi, al
    inc esi
    mov [arr + esi], bl   ; arr[j+1] = key

    pushad
    write msg4, msg4len
    mov al, [pass_num]
    mov [temp], al
    write temp, 1
    write msg5, msg5len
    call display
    popad

    inc cl
    inc byte [pass_num]
    jmp ins_outer

ins_end:
    ret
