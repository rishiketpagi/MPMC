;ALP to validate Password
section .data

    set_prompt db 'Enter new password: ', 0
    set_prompt_len equ $ - set_prompt

    confirm_prompt db 'Confirm new password: ', 0
    confirm_prompt_len equ $ - confirm_prompt

    val_prompt db 'Enter password to validate: ', 0
    val_prompt_len equ $ - val_prompt

    success_set db 'Password entered successfully!', 0xA, 0
    success_set_len equ $ - success_set

    match_error db 'Passwords do not match! Try again.', 0xA, 0
    match_error_len equ $ - match_error

    valid_msg db 'Password is valid!', 0xA, 0
    valid_len equ $ - valid_msg

    invalid_msg db 'Password is invalid!', 0xA, 0
    invalid_len equ $ - invalid_msg

    no_pwd_msg db 'No password has been set!', 0xA, 0
    no_pwd_len equ $ - no_pwd_msg

    invalid_choice db 'Invalid choice! Please try again.', 0xA, 0
    invalid_choice_len equ $ - invalid_choice

    protected_msg db 'Access Granted.', 0xA, 0
    protected_len equ $ - protected_msg

    newline db 0xA, 0
    newline_len equ $ - newline

    menu_msg db '|---> Password Manager <---|', 0xA
             db '1. Enter Password', 0xA
             db '2. Validate Password', 0xA
             db '3. Exit', 0xA
             db 'Enter choice : ', 0
    menu_len equ $ - menu_msg

section .bss
    choice resb 2
    input_buffer resb 64
    confirm_buffer resb 64
    stored_password resb 64
    password_length resb 1

section .text
    global _start

_start:
    mov byte [password_length], 0

display_menu:
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

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 0x80

    mov al, byte [choice]

    cmp al, '1'
    je option_set_password

    cmp al, '2'
    je option_validate_password

    cmp al, '3'
    je exit_program

    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_choice
    mov edx, invalid_choice_len
    int 0x80
    jmp display_menu

option_set_password:
    mov eax, 4
    mov ebx, 1
    mov ecx, set_prompt
    mov edx, set_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 64
    int 0x80

    dec eax
    mov byte [password_length], al

    mov eax, 4
    mov ebx, 1
    mov ecx, confirm_prompt
    mov edx, confirm_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, confirm_buffer
    mov edx, 64
    int 0x80

    dec eax

    mov esi, input_buffer
    mov edi, confirm_buffer
    mov ecx, eax

    mov al, byte [password_length]
    cmp al, cl
    jne passwords_do_not_match

    xor edx, edx
compare_confirm_loop:
    mov al, [input_buffer + edx]
    mov bl, [confirm_buffer + edx]
    cmp al, bl
    jne passwords_do_not_match
    inc edx
    cmp edx, ecx
    jl compare_confirm_loop

    mov esi, input_buffer
    mov edi, stored_password
    mov ecx, eax
    cld
    rep movsb
    mov byte [stored_password + eax], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, success_set
    mov edx, success_set_len
    int 0x80

    jmp display_menu

passwords_do_not_match:
    mov eax, 4
    mov ebx, 1
    mov ecx, match_error
    mov edx, match_error_len
    int 0x80

    jmp display_menu

option_validate_password:
    cmp byte [password_length], 0
    jne password_exists

    mov eax, 4
    mov ebx, 1
    mov ecx, no_pwd_msg
    mov edx, no_pwd_len
    int 0x80
    jmp display_menu

password_exists:
    mov eax, 4
    mov ebx, 1
    mov ecx, val_prompt
    mov edx, val_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 64
    int 0x80

    mov esi, eax
    dec esi

    call validate_password

    test eax, eax
    jz invalid_password

    mov eax, 4
    mov ebx, 1
    mov ecx, valid_msg
    mov edx, valid_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, protected_msg
    mov edx, protected_len
    int 0x80

    jmp display_menu

invalid_password:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, invalid_len
    int 0x80
    jmp display_menu

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

validate_password:
    push ebp
    mov ebp, esp

    movzx edx, byte [password_length]
    cmp esi, edx
    jne not_valid

    xor ecx, ecx
compare_loop:
    mov al, [input_buffer + ecx]
    mov bl, [stored_password + ecx]
    cmp al, bl
    jne not_valid

    inc ecx
    cmp ecx, edx
    jl compare_loop

    mov eax, 1
    jmp end_validate

not_valid:
    xor eax, eax

end_validate:
    mov esp, ebp
    pop ebp
    ret
