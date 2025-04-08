section .data
	msg db "Enter number of elements: "
	msglen equ $-msg
	msg2 db "Enter the elements in the array: "
	msg2len equ $-msg2
	msg3 db "The sorted array is: "
	msg3len equ $-msg3
	msg4 db "Pass "
	msg4len equ $-msg4
	msg5 db " : "
	msg5len equ $-msg5
	newline db 10
	space db ' '

; Define a macro for writing to stdout
%macro write 2
	mov eax,4         ; Syscall number for sys_write
	mov ebx,1         ; File descriptor 1 (stdout)
	mov ecx,%1        ; Address of the string to print
	mov edx,%2        ; Length of the string
	int 80h           ; Call kernel
%endmacro
	
; Define a macro for reading from stdin
%macro read 2
	mov eax,3         ; Syscall number for sys_read
	mov ebx,2         ; File descriptor 2 (stdin)
	mov ecx,%1        ; Buffer to read into
	mov edx,%2        ; Number of bytes to read
	int 80h           ; Call kernel
	mov eax,3         ; Syscall number for sys_read (cleanup)
	mov ebx,2         ; File descriptor 2 (stdin)
	mov ecx,trash     ; Buffer for clearing leftover input
	mov edx,1         ; Number of bytes to read
	int 80h           ; Call kernel
%endmacro

input:
	write msg2,msg2len        ; Prompt for input
	mov [i],dword '0'         ; Initialize loop counter to '0'
loop1:
	mov esi,[i]               ; Load loop counter into esi
	cmp esi,[n]               ; Compare loop counter with number of elements
	jge end1                  ; If loop counter >= number of elements, end loop
	sub esi,'0'               ; Convert loop counter to integer
	add esi,arr               ; Calculate address of array element to read into
	read esi,1                ; Read a single byte into the array
	inc dword[i]              ; Increment loop counter
	jmp loop1                 ; Repeat loop
end1:
	ret                       ; Return from function

display:
	mov [i],dword '0'         ; Initialize loop counter to '0'
loop2:
	mov esi,[i]               ; Load loop counter into esi
	cmp esi,[n]               ; Compare loop counter with number of elements
	jge end2                  ; If loop counter >= number of elements, end loop
	sub esi,'0'               ; Convert loop counter to integer
	add esi,arr               ; Calculate address of array element to display
	write esi,1               ; Display the array element
	write space,1             ; Display a space
	inc dword[i]              ; Increment loop counter
	jmp loop2                 ; Repeat loop
end2:
	write newline,1           ; Print a newline
	ret                       

bubble_sort:
	mov al,0                   ; Initialize outer loop counter (pass counter) to '0'
	mov bl,[n]                 ; Load number of elements into bl
	sub bl,'0'                 ; Convert number of elements to integer
	sub bl,1                   ; Decrement by 1 for zero-based indexing
loop3:
	cmp al,bl                  ; Compare pass counter with number of elements - 1
	jge end3                   ; If pass counter >= number of elements - 1, end loop
	pushad                     ; Save registers
	write msg4,msg4len        ; Display pass number
	write j,9                 ; Display pass counter
	write msg5,msg5len        ; Display delimiter
	call display               ; Display the array
	popad                      ; Restore registers
	mov ecx,0                  ; Initialize inner loop counter to '0'
	mov dl,bl                  ; Load number of elements into dl
	sub dl,al                  ; Subtract pass counter from number of elements
loop4:
	cmp cl,dl                  ; Compare inner loop counter with remaining elements
	jge update1                ; If inner loop counter >= remaining elements, go to update1
	mov esi,arr                ; Load base address of array into esi
	add esi,ecx                ; Calculate address of current element to compare
	mov ah,[esi]               ; Load current element into ah
	mov bh,[esi+1]             ; Load next element into bh
	cmp ah,bh                  ; Compare current element with next element
	jle update2                ; If current element <= next element, go to update2
	mov [esi+1],ah             ; Swap elements if current > next
	mov [esi],bh
update2:
	inc cl                     ; Increment inner loop counter
	jmp loop4                  ; Repeat inner loop
update1:
	inc al                     ; Increment pass counter
	inc byte[j]                ; Increment display counter
	jmp loop3                  ; Repeat outer loop
end3:
	write msg4,msg4len         ; Display final pass number
	write j,9                  ; Display final pass counter
	write msg5,msg5len         ; Display delimiter
	call display                ; Display the sorted array
ret                           ; Return from function

section .bss
	n resb 4                   ; Number of elements (buffer)
	arr resb 10                ; Array to store elements (buffer)
	i resb 4                   ; Loop counter (buffer)
	j resb 9                   ; Display counter (buffer)
	trash resb 1               ; Trash buffer for clearing input

section .text
global _start

_start:
	write msg,msglen           ; Prompt for number of elements
	read n,1                   ; Read number of elements
	call input                 ; Input elements into array
	write newline,1            ; Print a newline
	mov eax,'0'                ; Initialize display counter to '0'
	mov [j],eax                ; Reset display counter
	call bubble_sort           ; Sort the array
	write newline,1            ; Print a newline
	write msg3,msg3len         ; Display "The sorted array is: "
	call display               ; Display the sorted array
	mov eax,1                  ; Exit syscall
	mov ebx,0                  ; Exit status (success)
	int 80h                    ; Call kernel
