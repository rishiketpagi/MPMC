section .data
    msg_digits db 'Enter number of digits: ', 0   
    len_digits equ $-msg_digits                   

    msg1 db 'Enter number: ', 0
    len1 equ $-msg1

    msg2 db 'The addition of the two numbers is ', 0
    len2 equ $-msg2

    newline db 10
    l equ $-newline

section .bss
    num_digits resb 10        
    digit_count resd 1        ; Holds digit count as int

    num1 resb 10
    num2 resb 10
    sum resb 10

section .text
global _start
_start:

    ; Prompt and read number of digits
    writesystem msg_digits, len_digits
    readsystem num_digits, 10

    ; Convert num_digits to integer
    mov esi, num_digits
    call atoi
    mov [digit_count], eax

    ; Prompt and read first number
    writesystem msg1, len1
    readsystem num1, 10

    ; Prompt and read second number
    writesystem msg1, len1
    readsystem num2, 10

    ; Convert num1
    mov esi, num1
    mov ecx, [digit_count]       ; limit digits
    call atoi_limit
    mov ebx, eax                 ; store result in EBX

    ; Convert num2
    mov esi, num2
    mov ecx, [digit_count]
    call atoi_limit
    add eax, ebx                 ; EAX = num1 + num2

    ; Convert result to string
    mov esi, sum
    call itoa

    ; Output result
    writesystem msg2, len2
    writesystem sum, 10
    writesystem newline, l

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 80h

; --------- atoi (regular, no limit) ----------
; Converts string in ESI to integer in EAX
atoi:
    xor eax, eax
    xor ecx, ecx
.next_digit:
    movzx edx, byte [esi + ecx]
    cmp edx, 10         ; newline? (Linux input includes newline)
    je .done
    cmp edx, '0'
    jl .done
    cmp edx, '9'
    jg .done
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc ecx
    jmp .next_digit
.done:
    ret

; --------- atoi_limit ----------
; ESI = input string, ECX = max digits, EAX = result
atoi_limit:
    xor eax, eax
    xor edx, edx
    xor edi, edi
.convert_loop:
    cmp edi, ecx
    jge .done
    movzx edx, byte [esi + edi]
    cmp edx, 10
    je .done
    cmp edx, '0'
    jl .done
    cmp edx, '9'
    jg .done
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc edi
    jmp .convert_loop
.done:
    ret

; --------- itoa ----------
; Converts integer in EAX to string at ESI (in-place)
itoa:
    mov ebx, 10
    xor ecx, ecx          ; digit counter
.reverse:
    xor edx, edx
    div ebx               ; EAX /= 10, remainder in EDX
    add dl, '0'
    push dx
    inc ecx
    test eax, eax
    jnz .reverse

.write_digits:
    pop dx
    mov [esi], dl
    inc esi
    loop .write_digits
    mov byte [esi], 0     ; null-terminate
    ret
