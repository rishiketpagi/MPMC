;ALP to search an element
section .data
    msg_array_size db 'Enter the number of elements : '
    msg_array_size_len equ $-msg_array_size

    msg1 db 'Enter the elements in array: ',10
    msg1len equ $-msg1

    menu_msg db 10,'Menu:',10,'1.Linear Search',10,'2.Binary Search',10,'3.Exit',10,'Enter choice: '
    menu_msg_len equ $-menu_msg

    msg2 db 'Enter number to be searched: ' 
    msg2len equ $-msg2 
    
    msg3 db 'Number found at index: ' 
    msg3len equ $-msg3

    msg4 db 'Number not found' 
    msg4len equ $-msg4

    msg5 db ': not found'
    msg5len equ $-msg5

    msg6 db 'Searching index '
    msg6len equ $-msg6

    msg_found db ': found'
    msg_found_len equ $-msg_found
    
    lb_msg db "lb: "
    lb_msg_len equ $-lb_msg

    mid_msg db " mid: "
    mid_msg_len equ $-mid_msg

    ub_msg db " ub: "
    ub_msg_len equ $-ub_msg
    
    newline db '',10 
    n1 equ $-newline

    space db ' '

    invalid_choice db 'Invalid choice! Try again.',10
    invalid_len equ $-invalid_choice

%macro write 2
    mov eax, 4          
    mov ebx, 1         
    mov ecx, %1          
    mov edx, %2          
    int 80h             
%endmacro
 
%macro read 2
    mov eax, 3        
    mov ebx, 0        
    mov ecx, %1         
    mov edx, %2       
    int 80h              
%endmacro

section .bss
    arr resb 20          
    array_size resb 2     
    searche resb 10       
    i resb 1              
    index resb 2         
    element resb 2       
    num resb 10           
    temp resb 5          
    choice resb 2         
    lb resb 1             
    ub resb 1             
    mid resb 1            
    digit_buff resb 1

section .text
global _start

_start:
    call input_array_size
    call input_array   
    
menu:
    write menu_msg, menu_msg_len
    read choice, 2
    
    mov al, byte [choice]
    cmp al, '1'
    je do_linear_search
    cmp al, '2'
    je do_binary_search
    cmp al, '3'
    je exit_program
    
    write invalid_choice, invalid_len
    jmp menu

do_linear_search:
    write msg2, msg2len
    read searche, 10
    call linear_search
    jmp menu
    
do_binary_search:
    write msg2, msg2len
    read searche, 10
    call binary_search
    jmp menu
    
exit_program:
    mov eax, 1
    mov ebx, 0
    int 80h

input_array_size:
    write msg_array_size, msg_array_size_len
    read array_size, 2
    mov al, [array_size]
    sub al, '0'
    mov [array_size], al
    ret

input_array:
    write msg1, msg1len
    mov byte[i], 0
    mov esi, arr     
l_input:
    read element, 2   
    mov ebx, [element]
    sub ebx, '0'      
    mov [esi], ebx   
    inc esi         
    inc byte[i]
    mov al, [i]    
    cmp al, [array_size]
    jl l_input      
    ret

linear_search:
    movzx ecx, byte [array_size] 
    mov esi, 0         
search_loop:
    push ecx
    write msg6, msg6len
    add esi, '0'              
    mov [index], esi
    write index, 1
    sub esi, '0' 
    movzx edi, byte[arr+esi]
    mov [temp], edi           
    mov al, [temp]          
    mov bl, [searche]
    sub bl, '0'
    cmp al, bl
    jne element_not_found
    write msg_found, msg_found_len
    write newline, n1
    write msg3, msg3len
    add esi, '0'              
    mov [index], esi
    write index, 1
    write newline, n1
    pop ecx
    ret
    
element_not_found:
    write msg5, msg5len
    write newline, n1
    pop ecx
    inc esi
    dec ecx
    jnz search_loop
    write msg4, msg4len            
    write newline, n1
    ret

binary_search:
    mov al, [searche]
    sub al, '0'
    mov [num], al
    movzx edi, byte [num]
    mov byte [lb], 0
    mov al, [array_size]
    dec al
    mov [ub], al 
repeat_search:
    mov cl, [lb]
    mov dl, [ub]
    cmp cl, dl
    jg not_found
    pushad
    write lb_msg, lb_msg_len
    mov al, [lb]
    add al, '0'
    mov [digit_buff], al
    write digit_buff, 1
    movzx eax, byte [lb]
    movzx ebx, byte [ub]
    add eax, ebx
    mov ebx, 2
    div ebx
    mov [mid], al
    write mid_msg, mid_msg_len
    mov al, [mid]
    add al, '0'
    mov [digit_buff], al
    write digit_buff, 1
    write ub_msg, ub_msg_len
    mov al, [ub]
    add al, '0'
    mov [digit_buff], al
    write digit_buff, 1
    write newline, 1
    popad
    movzx eax, byte [lb]
    movzx ebx, byte [ub]
    add eax, ebx
    shr eax, 1
    mov [mid], al
    xor edx, edx
    mov dl, byte [mid]
    movzx esi, byte [arr+edx]
    cmp edi, esi
    je found
    jl lower_part
upper_part:
    mov al, [mid]
    inc al
    mov [lb], al
    cmp al, [ub]
    jg not_found
    jmp repeat_search
lower_part:
    mov al, [mid]
    dec al
    mov [ub], al
    cmp al, [lb]
    jl not_found
    jmp repeat_search
found:
    write msg3, msg3len
    mov al, [mid]
    add al, '0'
    mov [index], al
    write index, 1
    write newline, n1
    ret
not_found:
    write msg4, msg4len
    write newline, n1
    ret
